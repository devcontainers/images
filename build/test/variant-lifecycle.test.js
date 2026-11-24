const fs = require('fs');
const os = require('os');
const path = require('path');
const test = require('node:test');
const assert = require('node:assert/strict');

const {
    compareVersions,
    renderReport,
    validateVersions
} = require('../src/variant-lifecycle');

function makeRepo(manifests) {
    const repoRoot = fs.mkdtempSync(path.join(os.tmpdir(), 'variant-lifecycle-'));
    for (const [image, manifest] of Object.entries(manifests)) {
        const imagePath = path.join(repoRoot, 'src', image);
        fs.mkdirSync(imagePath, { recursive: true });
        fs.writeFileSync(path.join(imagePath, 'manifest.json'), JSON.stringify(manifest));
    }
    return repoRoot;
}

function versions(records, updatedAt = '2026-02-20T00:00:00Z') {
    return {
        schemaVersion: 1,
        source: {
            discussionNumber: 1464,
            url: 'https://github.com/devcontainers/images/discussions/1464',
            updatedAt,
            retrievedAt: '2026-03-01T00:00:00Z'
        },
        records
    };
}

test('validates and normalizes lifecycle records', () => {
    const normalized = validateVersions(versions([{
        id: 'node-20',
        platform: 'Node.js',
        version: '20',
        status: 'supported',
        releaseDate: '2023-04',
        eolDate: null,
        eolEstimated: false,
        images: [{ image: 'javascript-node', variant: '20-*' }],
        evidence: 'Node.js row in canonical Discussion comment'
    }]));

    assert.equal(normalized.records[0].releaseDatePrecision, 'month');
    assert.equal(normalized.records[0].eolDate, null);
});

test('rejects duplicate IDs and invalid lifecycle states', () => {
    const record = {
        id: 'duplicate',
        platform: 'Node.js',
        version: '20',
        status: 'supported',
        releaseDate: '2023',
        eolDate: null,
        images: [],
        evidence: 'row'
    };
    assert.throws(() => validateVersions(versions([record, record])), /duplicate record id/);
    assert.throws(() => validateVersions(versions([{ ...record, id: 'bad', status: 'maybe' }])), /status must be one of/);
});

test('compares supported, EOL, unlisted, deprecated, and stale variants', () => {
    const repoRoot = makeRepo({
        'javascript-node': {
            variants: ['20-trixie', '18-bookworm', '22-trixie'],
            build: {}
        },
        'base-debian': {
            variants: ['bookworm', 'trixie'],
            build: {}
        },
        deprecated: {
            variants: ['old'],
            build: {}
        }
    });
    fs.writeFileSync(path.join(repoRoot, 'src', 'deprecated', '.deprecated'), '');

    const report = compareVersions(versions([
        {
            id: 'node-20',
            platform: 'Node.js',
            version: '20',
            status: 'supported',
            releaseDate: '2023-04-18',
            eolDate: '2026-04',
            eolEstimated: true,
            images: [{ image: 'javascript-node', variant: '20-*' }],
            evidence: 'node 20 row'
        },
        {
            id: 'node-18',
            platform: 'Node.js',
            version: '18',
            status: 'eol',
            releaseDate: '2022',
            eolDate: '2025-04',
            eolEstimated: false,
            images: [{ image: 'javascript-node', variant: '18-*' }],
            evidence: 'node 18 row'
        },
        {
            id: 'debian-bookworm',
            platform: 'Debian',
            version: '12',
            status: 'supported',
            releaseDate: '2023-06',
            eolDate: '2028-06',
            eolEstimated: false,
            images: [{ image: 'base-debian', variant: 'bookworm' }],
            evidence: 'Debian bookworm row'
        },
        {
            id: 'debian-bullseye',
            platform: 'Debian',
            version: '11',
            status: 'supported',
            releaseDate: '2021',
            eolDate: '2026-08',
            eolEstimated: false,
            images: [{ image: 'base-debian', variant: 'bullseye' }],
            evidence: 'Debian bullseye row'
        }
    ], '2025-01-01T00:00:00Z'), repoRoot, new Date('2026-03-01T00:00:00Z'));

    assert.deepEqual(report.eolVariants, [{
        image: 'javascript-node',
        variant: '18-bookworm',
        records: ['node-18']
    }]);
    assert.deepEqual(report.unlistedVariants, [
        { image: 'base-debian', variant: 'trixie' },
        { image: 'javascript-node', variant: '22-trixie' }
    ]);
    assert.deepEqual(report.missingSupported, [{
        record: 'debian-bullseye',
        image: 'base-debian',
        variant: 'bullseye',
        evidence: 'Debian bullseye row'
    }]);
    assert.ok(report.dataQuality.some((item) => item.includes('stale')));
    assert.ok(!report.unlistedVariants.some((item) => item.image === 'deprecated'));
    assert.match(renderReport(report), /Variant lifecycle report/);
});
