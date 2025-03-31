/*--------------------------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See https://go.microsoft.com/fwlink/?linkid=2090316 for license information.
 *-------------------------------------------------------------------------------------------------------------*/

const path = require('path');
const jsonc = require('jsonc').jsonc;
const asyncUtils = require('./utils/async');
const configUtils = require('./utils/config');
const prep = require('./prep');
const builderName = 'dev-containers-builder';

async function push(repo, release, updateLatest, registry, registryPath, stubRegistry,
    stubRegistryPath, pushImages, prepOnly, definitionsToSkip, page, pageTotal, replaceImages, definitionId, secondaryRegistryPath) {

    // Optional argument defaults
    prepOnly = typeof prepOnly === 'undefined' ? false : prepOnly;
    pushImages = typeof pushImages === 'undefined' ? true : pushImages;
    page = page || 1;
    pageTotal = pageTotal || 1;
    stubRegistry = stubRegistry || registry;
    stubRegistryPath = stubRegistryPath || registryPath;
    definitionsToSkip = definitionsToSkip || [];

    // Always replace images when building and pushing the "dev" tag
    replaceImages = (configUtils.getVersionFromRelease(release, definitionId) == 'dev') || replaceImages;

    // Stage content
    let stagingFolder = await configUtils.getStagingFolder(release);
    await configUtils.loadConfig(stagingFolder);

    // Use or create a buildx / buildkit "builder" that using the docker-container driver which internally 
    // uses QEMU to emulate different architectures for cross-platform builds. Setting up a separate
    // builder avoids problems with the default config being different otherwise altered. It also can
    // be tweaked down the road to use a different driver like using separate machines per architecture.
    // See https://docs.docker.com/engine/reference/commandline/buildx_create/
    console.log('(*) Setting up builder...');
    await createOrUseBuilder();

    // This step sets up the QEMU emulators for cross-platform builds. See https://github.com/docker/buildx#building-multi-platform-images
    await asyncUtils.spawn('docker', ['run', '--privileged', '--rm', 'tonistiigi/binfmt', '--install', 'all']);

    // Build and push subset of images
    if (definitionId) {
        const variants = configUtils.getVariants(definitionId) || [null];
        await asyncUtils.forEach(variants, async (variant) => {
            stagingFolder = await configUtils.getStagingFolder(release);
            await configUtils.loadConfig(stagingFolder);

            console.log(`**** Pushing ${definitionId}: ${variant} ${release} ****`);
            await pushImage(
                definitionId, variant, repo, release, updateLatest, registry, registryPath, stubRegistry, stubRegistryPath, prepOnly, pushImages, replaceImages, secondaryRegistryPath);
        });
    } else {
        const definitionsToPush = configUtils.getSortedDefinitionBuildList(page, pageTotal, definitionsToSkip);
        await asyncUtils.forEach(definitionsToPush, async (currentJob) => {
            stagingFolder = await configUtils.getStagingFolder(release);
            await configUtils.loadConfig(stagingFolder);

            const registryName = registry.replace(/\.azurecr\.io.*/, '');
            const spawnOpts = { stdio: 'inherit', shell: true };
            await asyncUtils.spawn('az', [
                'acr',
                'login',
                '--name',
                registryName,
                '--username',
                '$TOKEN_NAME',
                '--password',
                '$PASSWORD'
            ], spawnOpts);

            console.log(`**** Pushing ${currentJob['id']}: ${currentJob['variant']} ${release} ****`);
            await pushImage(
                currentJob['id'], currentJob['variant'] || null, repo, release, updateLatest, registry, registryPath, stubRegistry, stubRegistryPath, prepOnly, pushImages, replaceImages, secondaryRegistryPath);
        });
    }

    return stagingFolder;
}

async function pushImage(definitionId, variant, repo, release, updateLatest,
    registry, registryPath, stubRegistry, stubRegistryPath, prepOnly, pushImages, replaceImage, secondaryRegistryPath) {
    const definitionPath = configUtils.getDefinitionPath(definitionId);
    const dotDevContainerPath = path.join(definitionPath, '.devcontainer');
    // Use Dockerfile for image build
    const dockerFilePath = path.join(dotDevContainerPath, 'Dockerfile');

    // Make sure there's a Dockerfile present
    if (!await asyncUtils.exists(dockerFilePath)) {
        throw `Definition ${definitionId} does not exist! Invalid path: ${definitionPath}`;
    }

    // Look for context in devcontainer.json and use it to build the Dockerfile
    console.log('(*) Reading devcontainer.json...');
    const devContainerJsonPath = path.join(dotDevContainerPath, 'devcontainer.json');
    const devContainerJsonRaw = await asyncUtils.readFile(devContainerJsonPath);
    const devContainerJson = jsonc.parse(devContainerJsonRaw);

    // Update common setup script download URL, SHA, parent tag if applicable
    console.log(`(*) Prep Dockerfile for ${definitionId} ${variant ? 'variant "' + variant + '"' : ''}...`);
    const prepResult = await prep.prepDockerFile(dockerFilePath,
        definitionId, repo, release, registry, registryPath, stubRegistry, stubRegistryPath, true, variant);

    if (prepOnly) {
        console.log(`(*) Skipping build and push to registry.`);
    } else {
        if (prepResult.shouldFlattenBaseImage) {
            console.log(`(*) Flattening base image...`);
            await flattenBaseImage(prepResult.baseImageTag, prepResult.flattenedBaseImageTag, pushImages);
        }

        // Build image
        console.log(`(*) Building image...`);
        // Determine tags to use
        const imageNamesWithVersionTags = configUtils.getTagList(definitionId, release, updateLatest, registry, registryPath, variant);
        const imageName = imageNamesWithVersionTags[0].split(':')[0];

        // Dual publish image to devcontainers and vscode/devcontainers
        const secondaryImageNamesWithVersionTags = configUtils.getTagList(definitionId, release, updateLatest, registry, secondaryRegistryPath, variant);

        console.log(`(*) Tags:${imageNamesWithVersionTags.reduce((prev, current) => prev += `\n     ${current}`, '')}`);
        console.log(`(*) Secondary Tags:${secondaryImageNamesWithVersionTags.reduce((prev, current) => prev += `\n     ${current}`, '')}`);

        const buildSettings = configUtils.getBuildSettings(definitionId);

        let architectures = buildSettings.architectures;
        switch (typeof architectures) {
            case 'string': architectures = [architectures]; break;
            case 'object': if (!Array.isArray(architectures)) { architectures = architectures[variant]; } break;
            case 'undefined': architectures = ['linux/amd64']; break;
        }

        console.log(`(*) Target image architectures: ${architectures.reduce((prev, current) => prev += `\n     ${current}`, '')}`);
        let localArchitecture = process.arch;
        switch (localArchitecture) {
            case 'arm': localArchitecture = 'linux/arm/v7'; break;
            case 'aarch32': localArchitecture = 'linux/arm/v7'; break;
            case 'aarch64': localArchitecture = 'linux/arm64'; break;
            case 'x64': localArchitecture = 'linux/amd64'; break;
            case 'x32': localArchitecture = 'linux/386'; break;
            default: localArchitecture = `linux/${localArchitecture}`; break;
        }

        console.log(`(*) Local architecture: ${localArchitecture}`);
        if (!pushImages) {
            console.log(`(*) Push disabled: Only building local architecture (${localArchitecture}).`);
        }

        if (replaceImage || !await isDefinitionVersionAlreadyPublished(definitionId, release, registry, registryPath, variant)) {

            let skipPersistingCustomizationsFromFeatures = false;
            let platformParams = "";
            // Universal image does not need to be multi-arch
            // ubuntu:focal image supports multiarch but Universal does not. Hence, the build fails similar to https://github.com/docker/buildx/issues/235
            if (definitionId !== "universal") {
                platformParams = "--platform " + (pushImages ? architectures.reduce((prev, current) => prev + ',' + current, '').substring(1) : localArchitecture)
            } else {
                skipPersistingCustomizationsFromFeatures = true;
            }

            const context = devContainerJson.build ? devContainerJson.build.context || '.' : devContainerJson.context || '.';
            const workingDir = path.resolve(dotDevContainerPath, context);
            let imageNameParams = imageNamesWithVersionTags.reduce((prev, current) => prev.concat(['--image-name', current]), []);

            const secondaryImageNameParams = secondaryImageNamesWithVersionTags.reduce((prev, current) => prev.concat(['--image-name', current]), []);
            imageNameParams = imageNameParams.concat(secondaryImageNameParams);

            const spawnOpts = { stdio: 'inherit', cwd: workingDir, shell: true };
            await asyncUtils.spawn('devcontainer', [
                'build',
                '--workspace-folder', definitionPath,
                '--log-level ', 'info',
                ...imageNameParams,
                '--no-cache', 'true',
                platformParams,
                pushImages ? '--push' : '',
                '--skip-persisting-customizations-from-features', skipPersistingCustomizationsFromFeatures,
            ], spawnOpts);

            if (!pushImages) {
                console.log(`(*) Skipping push to registry.`);
            }

            console.log("(*) Docker images", imageName);
            await asyncUtils.spawn('docker', [`images`], spawnOpts);

        } else {
            console.log(`(*) Version already published. Skipping.`);
        }
    }

    await prep.createStub(
        dotDevContainerPath, definitionId, repo, release, stubRegistry, stubRegistryPath);

    console.log('(*) Done!\n');
}

async function flattenBaseImage(baseImageTag, flattenedBaseImageTag, pushImages) {
    const flattenedImageCaptureGroups = /([^\/]+)\/(.+):(.+)/.exec(flattenedBaseImageTag);
    if (await isImageAlreadyPublished(flattenedImageCaptureGroups[1], flattenedImageCaptureGroups[2], flattenedImageCaptureGroups[3])) {
        console.log('(*) Flattened base image already published.')
        return;
    }

    // Flatten
    const processOpts = { stdio: 'inherit', shell: true };
    console.log('(*) Preparing base image...');
    await asyncUtils.spawn('docker', ['run', '-d', '--name', 'devcontainers-build-flatten', baseImageTag, 'bash'], processOpts);
    const containerInspectOutput = await asyncUtils.spawn('docker', ['inspect', 'devcontainers-build-flatten'], { shell: true, stdio: 'pipe' });
    console.log('(*) Flattening (this could take a while)...');
    const config = JSON.parse(containerInspectOutput)[0].Config;
    const envString = config.Env.reduce((prev, current) => prev + ' ' + current, '');
    const importArgs = `-c 'ENV ${envString}' -c 'ENTRYPOINT ${JSON.stringify(config.Entrypoint)}' -c 'CMD ${JSON.stringify(config.Cmd)}'`;
    await asyncUtils.exec(`docker export devcontainers-build-flatten | docker import ${importArgs} - ${flattenedBaseImageTag}`, processOpts);
    await asyncUtils.spawn('docker', ['container', 'rm', '-f', 'devcontainers-build-flatten'], processOpts);

    // Push if enabled
    if (pushImages) {
        console.log('(*) Pushing...');
        await asyncUtils.spawn('docker', ['push', flattenedBaseImageTag], processOpts);
    } else {
        console.log('(*) Skipping push.');
    }
}

async function isDefinitionVersionAlreadyPublished(definitionId, release, registry, registryPath, variant) {
    // See if image already exists
    const tagsToCheck = configUtils.getTagList(definitionId, release, false, registry, registryPath, variant);
    const tagParts = tagsToCheck[0].split(':');
    const registryName = registry.replace(/\..*/, '');
    return await isImageAlreadyPublished(registryName, tagParts[0].replace(/[^\/]+\//, ''), tagParts[1]);
}

async function isImageAlreadyPublished(registryName, repositoryName, tagName) {
    registryName = registryName.replace(/\.azurecr\.io.*/, '');
    // Check if repository exists
    const repositoriesOutput = await asyncUtils.spawn('az', ['acr', 'repository', 'list', '--name', registryName, '--username', '$TOKEN_NAME', '--password', '$PASSWORD'], { shell: true, stdio: 'inherit' });
    const repositories = JSON.parse(repositoriesOutput);
    if (repositories.indexOf(repositoryName) < 0) {
        console.log('(*) Repository does not exist. Image version has not been published yet.')
        return false;
    }

    // Assuming repository exists, check if tag exists
    const tagListOutput = await asyncUtils.spawn('az', ['acr', 'repository', 'show-tags',
        '--name', registryName,
        '--repository', repositoryName,
        '--query', `"[?@=='${tagName}']"`,
        '--username', '$TOKEN_NAME',
        '--password', '$PASSWORD'
    ], { shell: true, stdio: 'inherit' });
    const tagList = JSON.parse(tagListOutput);
    if (tagList.length > 0) {
        console.log('(*) Image version has already been published.')
        return true;
    }
    console.log('(*) Image version has not been published yet.')
    return false;
}

async function createOrUseBuilder() {
    const builders = await asyncUtils.exec('docker buildx ls');
    if (builders.indexOf(builderName) < 0) {
        await asyncUtils.spawn('docker', ['buildx', 'create', '--use', '--name', builderName]);
    } else {
        await asyncUtils.spawn('docker', ['buildx', 'use', builderName]);
    }
}


module.exports = {
    push: push
}
