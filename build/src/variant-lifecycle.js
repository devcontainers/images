/*--------------------------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See https://go.microsoft.com/fwlink/?linkid=2090316 for license information.
 *-------------------------------------------------------------------------------------------------------------*/

const fs = require('fs');
const path = require('path');

const SCHEMA_VERSION = 1;
const DEFAULT_STALE_DAYS = 45;
const STATUSES = new Set(['supported', 'eol', 'unknown']);
const DATE_PATTERN = /^(\d{4})(?:-(\d{2})(?:-(\d{2}))?)?$/;
const REPORT_MARKER = '<!-- devcontainers-variant-lifecycle-report:v1 -->';

function readJson(filePath) {
    return JSON.parse(fs.readFileSync(filePath, 'utf8'));
}

function writeJson(filePath, value) {
    fs.writeFileSync(filePath, `${JSON.stringify(value, null, 2)}\n`);
}

function fail(message) {
    throw new Error(message);
}

function parseDate(value, field, allowNull = true) {
    if (value === null && allowNull) {
        return null;
    }
    if (typeof value !== 'string') {
        fail(`${field} must be a YYYY, YYYY-MM, YYYY-MM-DD string, or null`);
    }
    const match = DATE_PATTERN.exec(value);
    if (!match) {
        fail(`${field} has an invalid date: ${value}`);
    }
    const month = match[2] ? Number(match[2]) : null;
    const day = match[3] ? Number(match[3]) : null;
    if (month !== null && (month < 1 || month > 12)) {
        fail(`${field} has an invalid month: ${value}`);
    }
    if (day !== null) {
        const maxDay = new Date(Date.UTC(Number(match[1]), month, 0)).getUTCDate();
        if (day < 1 || day > maxDay) {
            fail(`${field} has an invalid day: ${value}`);
        }
    }
    return {
        value,
        precision: day !== null ? 'day' : month !== null ? 'month' : 'year'
    };
}

function ensureObject(value, label) {
    if (!value || typeof value !== 'object' || Array.isArray(value)) {
        fail(`${label} must be an object`);
    }
}

function normalizeImages(images, recordId) {
    if (!Array.isArray(images)) {
        fail(`records[${recordId}].images must be an array`);
    }
    return images.map((image, index) => {
        ensureObject(image, `records[${recordId}].images[${index}]`);
        if (typeof image.image !== 'string' || image.image.length === 0) {
            fail(`records[${recordId}].images[${index}].image must be non-empty`);
        }
        const variant = image.variant === undefined ? '*' : image.variant;
        if (variant !== null && (typeof variant !== 'string' || variant.length === 0)) {
            fail(`records[${recordId}].images[${index}].variant must be a string or null`);
        }
        return {
            image: image.image,
            variant
        };
    });
}

function validateVersions(input) {
    ensureObject(input, 'versions');
    if (input.schemaVersion !== SCHEMA_VERSION) {
        fail(`schemaVersion must be ${SCHEMA_VERSION}`);
    }
    ensureObject(input.source, 'source');
    if (input.source.discussionNumber !== 1464) {
        fail('source.discussionNumber must be 1464');
    }
    for (const field of ['url', 'updatedAt', 'retrievedAt']) {
        if (typeof input.source[field] !== 'string' || input.source[field].length === 0) {
            fail(`source.${field} must be a non-empty string`);
        }
    }
    if (!Array.isArray(input.records) || input.records.length === 0) {
        fail('records must be a non-empty array');
    }

    const ids = new Set();
    const records = input.records.map((record, index) => {
        ensureObject(record, `records[${index}]`);
        if (typeof record.id !== 'string' || record.id.length === 0) {
            fail(`records[${index}].id must be a non-empty string`);
        }
        if (ids.has(record.id)) {
            fail(`duplicate record id: ${record.id}`);
        }
        ids.add(record.id);
        for (const field of ['platform', 'version', 'status', 'evidence']) {
            if (typeof record[field] !== 'string' || record[field].length === 0) {
                fail(`records[${index}].${field} must be a non-empty string`);
            }
        }
        if (!STATUSES.has(record.status)) {
            fail(`records[${index}].status must be one of ${[...STATUSES].join(', ')}`);
        }
        const releaseDate = parseDate(record.releaseDate === undefined ? null : record.releaseDate, `records[${index}].releaseDate`);
        const eolDate = parseDate(record.eolDate === undefined ? null : record.eolDate, `records[${index}].eolDate`);
        const images = normalizeImages(record.images, index);
        return {
            id: record.id,
            platform: record.platform,
            version: record.version,
            status: record.status,
            releaseDate: releaseDate?.value || null,
            releaseDatePrecision: releaseDate?.precision || null,
            eolDate: eolDate?.value || null,
            eolDatePrecision: eolDate?.precision || null,
            eolEstimated: record.eolEstimated === true,
            images,
            evidence: record.evidence
        };
    });
    return {
        schemaVersion: SCHEMA_VERSION,
        source: { ...input.source },
        records
    };
}

function endOfDate(value, precision) {
    const [year, month = '01', day = '01'] = value.split('-');
    if (precision === 'year') {
        return new Date(Date.UTC(Number(year) + 1, 0, 1));
    }
    if (precision === 'month') {
        return new Date(Date.UTC(Number(year), Number(month), 1));
    }
    return new Date(Date.UTC(Number(year), Number(month) - 1, Number(day) + 1));
}

function eolHasPassed(record, now) {
    if (!record.eolDate) {
        return false;
    }
    return endOfDate(record.eolDate, record.eolDatePrecision) <= now;
}

function wildcardMatches(pattern, value) {
    if (pattern === null || pattern === '*') {
        return true;
    }
    const escaped = pattern.replace(/[.+?^${}()|[\]\\]/g, '\\$&').replace(/\*/g, '.*');
    return new RegExp(`^${escaped}$`).test(value);
}

function loadManifests(repoRoot) {
    const srcPath = path.join(repoRoot, 'src');
    const definitions = [];
    for (const entry of fs.readdirSync(srcPath, { withFileTypes: true })) {
        if (!entry.isDirectory()) {
            continue;
        }
        const definitionPath = path.join(srcPath, entry.name);
        if (fs.existsSync(path.join(definitionPath, '.deprecated'))) {
            continue;
        }
        const manifestPath = path.join(definitionPath, 'manifest.json');
        if (!fs.existsSync(manifestPath)) {
            continue;
        }
        const manifest = readJson(manifestPath);
        const variants = manifest.variants === null ? [null] : manifest.variants;
        if (!Array.isArray(variants)) {
            fail(`${manifestPath}: variants must be an array or null`);
        }
        definitions.push({
            image: entry.name,
            manifestPath: path.relative(repoRoot, manifestPath),
            variants
        });
    }
    return definitions;
}

function compareVersions(versions, repoRoot, now = new Date(), staleDays = DEFAULT_STALE_DAYS) {
    const normalized = validateVersions(versions);
    const definitions = loadManifests(repoRoot);
    const missingSupported = [];
    const eolVariants = [];
    const unlistedVariants = [];
    const dataQuality = [];
    const sourceUpdated = new Date(normalized.source.updatedAt);
    if (Number.isNaN(sourceUpdated.getTime())) {
        dataQuality.push(`source.updatedAt is not a valid ISO timestamp: ${normalized.source.updatedAt}`);
    } else if (now - sourceUpdated > staleDays * 24 * 60 * 60 * 1000) {
        dataQuality.push(`Discussion source is stale: updated ${normalized.source.updatedAt}, threshold ${staleDays} days`);
    }

    for (const record of normalized.records) {
        if (record.status === 'supported' && record.images.length === 0) {
            dataQuality.push(`${record.id} is supported but has no image mapping`);
        }
        for (const mapping of record.images) {
            const definition = definitions.find((item) => item.image === mapping.image);
            if (!definition) {
                dataQuality.push(`${record.id} maps to unknown image ${mapping.image}`);
                continue;
            }
            const matched = definition.variants.some((variant) => {
                if (variant === null) {
                    return mapping.variant === null || mapping.variant === '*';
                }
                return mapping.variant === null || wildcardMatches(mapping.variant, variant);
            });
            if (!matched && record.status === 'supported') {
                missingSupported.push({
                    record: record.id,
                    image: mapping.image,
                    variant: mapping.variant,
                    evidence: record.evidence
                });
            }
        }
    }

    for (const definition of definitions) {
        for (const variant of definition.variants) {
            const matchingRecords = normalized.records.filter((record) =>
                record.images.some((mapping) =>
                    mapping.image === definition.image &&
                    (variant === null
                        ? mapping.variant === null || mapping.variant === '*'
                        : mapping.variant === null || wildcardMatches(mapping.variant, variant))
                )
            );
            const variantLabel = variant === null ? '(default)' : variant;
            if (matchingRecords.length === 0) {
                unlistedVariants.push({ image: definition.image, variant: variantLabel });
                continue;
            }
            const states = new Set(matchingRecords.map((record) =>
                record.status === 'eol' || eolHasPassed(record, now) ? 'eol' : record.status
            ));
            if (states.has('eol') && states.size > 1) {
                dataQuality.push(`${definition.image}:${variantLabel} maps to conflicting lifecycle states`);
            } else if (states.has('eol')) {
                eolVariants.push({
                    image: definition.image,
                    variant: variantLabel,
                    records: matchingRecords.map((record) => record.id)
                });
            }
        }
    }

    const sortItems = (items) => items.sort((left, right) =>
        JSON.stringify(left).localeCompare(JSON.stringify(right))
    );
    return {
        source: normalized.source,
        generatedAt: now.toISOString(),
        staleDays,
        missingSupported: sortItems(missingSupported),
        eolVariants: sortItems(eolVariants),
        unlistedVariants: sortItems(unlistedVariants),
        dataQuality: dataQuality.sort()
    };
}

function formatItems(items, formatter) {
    return items.length === 0 ? '- None' : items.map((item) => `- ${formatter(item)}`).join('\n');
}

function renderReport(report) {
    return `${REPORT_MARKER}
# Variant lifecycle report

Source: [Discussion #${report.source.discussionNumber}](${report.source.url})  
Discussion updated: \`${report.source.updatedAt}\`  
Report generated: \`${report.generatedAt}\`  
Stale threshold: \`${report.staleDays} days\`

## Supported versions without a matching variant
${formatItems(report.missingSupported, (item) => `${item.image}:${item.variant || '*'} for \`${item.record}\``)}

## EOL or past-EOL variants
${formatItems(report.eolVariants, (item) => `${item.image}:${item.variant} (${item.records.join(', ')})`)}

## Variants not listed in the Discussion
${formatItems(report.unlistedVariants, (item) => `${item.image}:${item.variant}`)}

## Data-quality and freshness findings
${formatItems(report.dataQuality, (item) => item)}
`;
}

function parseArgs(argv) {
    const args = {};
    for (let index = 0; index < argv.length; index += 1) {
        const arg = argv[index];
        if (!arg.startsWith('--')) {
            continue;
        }
        args[arg.slice(2)] = argv[index + 1] && !argv[index + 1].startsWith('--')
            ? argv[++index]
            : true;
    }
    return args;
}

function main(argv) {
    const [command, ...rest] = argv;
    const args = parseArgs(rest);
    if (command === 'validate') {
        const normalized = validateVersions(readJson(args.input));
        writeJson(args.output || args.input, normalized);
        return;
    }
    if (command === 'check') {
        const report = compareVersions(
            readJson(args.versions),
            path.resolve(args.repo || process.cwd()),
            args.now ? new Date(args.now) : new Date(),
            args.staleDays ? Number(args.staleDays) : DEFAULT_STALE_DAYS
        );
        writeJson(args.output || 'variant-lifecycle-report.json', report);
        if (args.markdown) {
            fs.writeFileSync(args.markdown, renderReport(report));
        }
        return;
    }
    fail('Usage: variant-lifecycle.js <validate|check> --input/--versions <file> [options]');
}

if (require.main === module) {
    try {
        main(process.argv.slice(2));
    } catch (error) {
        console.error(error.message);
        process.exitCode = 1;
    }
}

module.exports = {
    DEFAULT_STALE_DAYS,
    REPORT_MARKER,
    compareVersions,
    renderReport,
    validateVersions
};
