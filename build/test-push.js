/*--------------------------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See https://go.microsoft.com/fwlink/?linkid=2090316 for license information.
 *-------------------------------------------------------------------------------------------------------------*/

const assert = require('assert');
const asyncUtils = require('./src/utils/async');
const configUtils = require('./src/utils/config');
const push = require('./src/push');

async function testConfigFlag() {
    const originalValue = process.env.SQUASH_UNIVERSAL_IMAGE;

    try {
        delete process.env.SQUASH_UNIVERSAL_IMAGE;
        assert.strictEqual(configUtils.shouldSquashUniversalImage('universal'), true);
        assert.strictEqual(configUtils.shouldSquashUniversalImage('python'), false);

        process.env.SQUASH_UNIVERSAL_IMAGE = 'false';
        assert.strictEqual(configUtils.shouldSquashUniversalImage('universal'), false);

        process.env.SQUASH_UNIVERSAL_IMAGE = 'TRUE';
        assert.strictEqual(configUtils.shouldSquashUniversalImage('universal'), true);
    } finally {
        if (typeof originalValue === 'undefined') {
            delete process.env.SQUASH_UNIVERSAL_IMAGE;
        } else {
            process.env.SQUASH_UNIVERSAL_IMAGE = originalValue;
        }
    }
}

function testDevcontainerPushArgument() {
    assert.strictEqual(push.getDevcontainerPushArgument(true, false), '--push');
    assert.strictEqual(push.getDevcontainerPushArgument(true, true), '');
    assert.strictEqual(push.getDevcontainerPushArgument(false, false), '');
    assert.strictEqual(push.getDevcontainerPushArgument(false, true), '');
}

async function withSpawnStub(callback) {
    const originalSpawn = asyncUtils.spawn;
    const calls = [];
    asyncUtils.spawn = async (command, args, opts) => {
        calls.push({ command, args, opts });
    };

    try {
        await callback(calls);
    } finally {
        asyncUtils.spawn = originalSpawn;
    }
}

async function testSquashAndPushAllTags() {
    await withSpawnStub(async (calls) => {
        const tags = [
            'registry.example/devcontainers/universal:6.2.0',
            'registry.example/devcontainers/universal:6.2',
            'registry.example/vscode/devcontainers/universal:6.2.0'
        ];

        await push.squashAndPushImageTags(tags, true, {});

        assert.deepStrictEqual(calls[0].command, 'docker-squash');
        assert.deepStrictEqual(calls[0].args, [
            '--tag',
            `${tags[0]}-squashed`,
            tags[0]
        ]);
        assert.strictEqual(calls[0].args.includes('-f'), false);

        const tagCalls = calls.filter((call) => call.command === 'docker' && call.args[0] === 'tag');
        assert.deepStrictEqual(tagCalls.map((call) => call.args[2]), tags);

        const pushCalls = calls.filter((call) => call.command === 'docker' && call.args[0] === 'push');
        assert.deepStrictEqual(pushCalls.map((call) => call.args[1]), tags);
        assert.strictEqual(calls[calls.length - 1].args[0], 'push');
    });
}

async function testLocalSquashSkipsPush() {
    await withSpawnStub(async (calls) => {
        await push.squashAndPushImageTags(['universal:test'], false, {});
        assert.strictEqual(calls.some((call) => call.command === 'docker' && call.args[0] === 'push'), false);
    });
}

async function testSquashFailurePreventsPush() {
    const originalSpawn = asyncUtils.spawn;
    const calls = [];
    asyncUtils.spawn = async (command, args) => {
        calls.push({ command, args });
        if (command === 'docker-squash') {
            throw new Error('squash failed');
        }
    };

    try {
        await assert.rejects(
            push.squashAndPushImageTags(['universal:test'], true, {}),
            /squash failed/
        );
        assert.strictEqual(calls.some((call) => call.command === 'docker' && call.args[0] === 'push'), false);
    } finally {
        asyncUtils.spawn = originalSpawn;
    }
}

async function main() {
    await testConfigFlag();
    testDevcontainerPushArgument();
    await testSquashAndPushAllTags();
    await testLocalSquashSkipsPush();
    await testSquashFailurePreventsPush();
    console.log('push tests passed');
}

main().catch((error) => {
    console.error(error);
    process.exit(1);
});
