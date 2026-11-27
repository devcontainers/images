/*--------------------------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See https://go.microsoft.com/fwlink/?linkid=2090316 for license information.
 *-------------------------------------------------------------------------------------------------------------*/

const config = require('../../config.json');

function shouldSquashUniversalImage(definitionId) {
    if (definitionId !== 'universal') {
        return false;
    }

    const rawEnvironmentValue = process.env.SQUASH_UNIVERSAL_IMAGE;
    const environmentValue = typeof rawEnvironmentValue === 'string' ? rawEnvironmentValue.trim().toLocaleLowerCase() : undefined;
    if (environmentValue === 'true') {
        console.log('(*) Universal image squashing enabled by SQUASH_UNIVERSAL_IMAGE.');
        return true;
    }
    if (environmentValue === 'false') {
        console.log('(*) Universal image squashing disabled by SQUASH_UNIVERSAL_IMAGE.');
        return false;
    }

    const configValue = config.squashUniversalImage === true;
    if (typeof rawEnvironmentValue === 'undefined') {
        console.log(`(*) SQUASH_UNIVERSAL_IMAGE is not set. Using build/config.json value: ${configValue}.`);
    } else {
        console.log(`(*) Invalid SQUASH_UNIVERSAL_IMAGE value ${JSON.stringify(rawEnvironmentValue)}. Using build/config.json value: ${configValue}.`);
    }
    return configValue;
}

module.exports = {
    shouldSquashUniversalImage: shouldSquashUniversalImage
};
