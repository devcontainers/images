# Build and image generation for devcontainers

This folder contains scripts to build and push images into the Microsoft Container Registry (MCR) from this repository, generate or modify any associated content to use the built image, and track dependencies.

## Build CLI

The Node.js based build CLI (`build/vsdc`) has commands to:

1. Build and push to a repository: `build/vsdc push`
2. Generate cgmanifest.json and history markdown files: `build/vsdc cg`, `build/vsdc info`

Run with the `--help` option to see inputs.

This CLI is used in the GitHub Actions workflows in this repository.

- `push-dev.yml`: Pushes a "dev" tag for each image to be generated in this repository and fires repository dispatch to trigger cgmanifest.json generation.
- `push.yml`: Triggers when a release tag is pushed (`vX.Y.Z`). Builds and pushes a release version of the images. Note that this update the tag with source files that contain a SHA hash for script sources. You may need to run `git fetch --tags --force` locally after it runs.
- `push-again.yml`: A manually triggered workflow that can be used to push an updated version of an image for an existing release. This should only be used in cases where the image push to the registry only partially succeeded (e.g. `linux/amd64` was pushed, but a connection error happened when pushing `linux/arm64` for the same image.)
- `smoke-*.yaml` (using the `smoke-test` action in this repository) - Runs a build without pushing and executes `test-project/test.sh` (if present) inside the container to verify that there are no breaking changes to the image when the repository contents are updated.
- `version-history.yml`: Listens for workflow dispatch events to trigger cgmanifest.json and history markdown generation.

## Setting up a container to be built

> **Note:** Only @devcontainers/maintainers can currently onboard an image to this process since it requires access the Microsoft Container Registry. [See here for details](https://github.com/microsoft/vscode-internalbacklog/wiki/Remote-Container-Images-MCR-Setup).
>
> However, if you have your own pre-built image or build process, you can simply reference it directly in you contributed container.

Image build/push to MCR is managed using config in `manifest.json` files that are located in the images' folder. So, the steps to onboard an image are:

1. **Important:** Update any `ARG` values in your `Dockerfile` to reflect what you want in the image. Use boolean `ARGS` with `if` statements to skip installing certain things in the image.

    > **Note:** The `build.args` and `build.dockerfile` properties are **intentionally ignored** during image build so that you can vary image defaults and devcontainer.json defaults as appropriate. The only property considered is `build.context` since this may be required for the build to succeed.

2. Create a [`Dockerfile`](#creating-a-dockerfile)

3. Create [a `manifest.json` file](#the-manifestjson-file)

4. Set up [meta.env file](#Adding-a-meta.env-file)

5. Update the `vscode` [config files for MCR](https://github.com/microsoft/vscode-internalbacklog/wiki/Remote-Container-Images-MCR-Setup) as appropriate (MS internal only).

## Testing the build

Once you have your build configuration setup, you can use the `vscdc` CLI to test that everything is configured as you would expect.

1. First, build the image(s) using the CLI as follows:

   ```bash
   build/vscdc push --no-push --registry mcr.microsoft.com --registry-path devcontainers --release main <your-image-name-here>
   ```

2. Use the Docker CLI to verify all of the expected images and tags and have the right contents:

    ```bash
    docker run -it --init --privileged --rm mcr.microsoft.com/devcontainers/<expected-repository>:dev-<expected tag> bash
    ```

3. Test manifest generation by running:

   ```bash
   build/vscdc cg --registry mcr.microsoft.com --registry-path devcontainers --release main <your-image-name-here>
   ```

4. Test markdown image history by running:

    ```bash
        build/vscdc info --build --markdown --overwrite --registry mcr.microsoft.com --registry-path devcontainers --release main <your-image-name-here>
    ```

## Creating a `Dockerfile`

In some cases you may want to include some special instructions for developers. In this case, you can add a custom stub Dockerfile by creating the following files:

- `Dockerfile`: Dockerfile used to generate the image itself

You can then reference `Dockerfile` in `devcontainer.json` to make editing the file that is used to create the image easy.

If you're using the [variants property](#the-variants-property) in `manifest.json`, you can set up the custom stub so that you can specify the variant from `devcontainer.json` by adding an argument called `VARIANT` right before the `FROM` statement that uses it.

In your `Dockerfile`:

```Dockerfile
ARG VARIANT=3
FROM mcr.microsoft.com/devcontainers/python:${VARIANT}
```

In `devcontainer.json`:

```json
"build": {
    "args": {
        "VARIANT": "3.8"
    }
}
```

### Adding a `meta.env` file
The build system will automatically populate the meta.env file with the correct contents on build if found with some key information like the image version, repository, and history file. This will power a `devcontainer-info` command added by the `common-debian.sh` script.

## The `definition.json` file

Let's run through the `manifest.json` file.

### The `build` namespace

The `build` namespace includes properties that defines how the templates maps to image tags. For example:

```json
"build": {
    "architectures": [ "linux/amd64", "linux/arm64" ],
    "rootDistro": "debian",
    "latest": true,
    "tags": [
        "base:${VERSION}-debian-11",
        "base:${VERSION}-bullseye"
    ]
}
```

The **`build.architectures`** property specifies how many chip architectures should be built for the image. By default only 64-bit x86 (`linux/amd64`) is built. Note that there are a suprising number of problems when adding another architecture. For example, adding `linux/arm64` does not work well with Debian 10/buster or Ubuntu 20.04/focal because of an OS issue with libssl, so each architecture needs to be tested carefully.

The **`build.rootDistro`** property can be `debian`, `alpine`, or `redhat` currently, but stick with Debian or Ubuntu for images wherever possible. Ubuntu-based containers should use `debian`. 

The **`build.latest`** and **`build.tags`** properties affect how tags are applied. For example, here is how several dev container folders map:

```text
debian => mcr.microsoft.com/devcontainers/base:debian
alpine => mcr.microsoft.com/devcontainers/base:alpine
ubuntu => mcr.microsoft.com/devcontainers/base:ubuntu
```

This results in just one "repository" in the registry much like you would see for other images in Docker Hub.

- mcr.microsoft.com/devcontainers/base

The package version is then automatically added to these various tags in the `${VERSION}` location for an item in the `tags` property array as a part of the release. For example, release 0.40.0 would result in:

- 0.40.0-debian-11
- 0.40-debian-11
- 0-debian-11
- debian-11 <= Equivalent of latest for debian-11 specifically
- 0.40.0-bullseye
- 0.40-bullseye
- 0-bullseye
- bullseye <= Equivalent of latest for bullseye specifically

In this case, Debian is also the one that is used for `latest` for the `base` repository, so that tag gets applied too.  If you ran only the Alpine or Ubuntu versions, the latest tag would not update.

> **NOTE:** The version number used for this repository should be kept in sync with the VS Code Remote - Containers extension to make it easy for developers to find.

There's a special "dev" version that can be used to build main on CI - I ended up needing this to test and others would if they base an image off of one of the MCR images.  e.g. `dev-debian-11`.

### The `version` property

While in most cases it makes sense to version the contents of a image with the repository, there may be scenarios where you want to be able to version independently. A good example of this [is the `universal` image](../src/universal/) where upstream edits could cause breaking changes in this image.

When this is necessary, the `version` property in the `manifest.json` file can be set.

```json
"version": "1.0.0"
```

### The `variants` property

In many cases, you will only need to create one image. Even if there is only one or two versions of a given runtime available at a given time, it can be useful to simply have different images to aid discoverability.

In other cases, you may want to generate multiple images but with one small change. This is where the variants property comes in. Consider this `manifest.json`:

```json
"variants": [ "3", "3.6", "3.7", "3.8" ],
"build": {
    "rootDistro": "debian",
    "tags": [
        "python:${VERSION}-${VARIANT}"
    ],
    "latest": "3"
}
```

The variant specified in the `build.latest` property is the one that will have the `latest` tag applied if applicable. Set this to `false` if you do not want any variant to get the `latest` tag.

Here is its corresponding Dockerfile:

```Dockerfile
ARG VARIANT=3
FROM python:${VARIANT}
```

This configuration would cause separate image variants, each with a different `VARIANT` build argument value passed in, that are then tagged as follows:

- mcr.microsoft.com/devcontainers/python:3
- mcr.microsoft.com/devcontainers/python:3.6
- mcr.microsoft.com/devcontainers/python:3.7
- mcr.microsoft.com/devcontainers/python:3.8

In addition `mcr.microsoft.com/devcontainers/python` would point to `mcr.microsoft.com/devcontainers/python:3` since it is the first in the list.

#### The `build.variantTags` property

In some cases you may want to have different tags for each variant in the `variants` property. This is where `variantTags` come in. These tags add to the common list already set in `tags`.

For example:

```jsonc
"variants": ["buster", "bullseye"],
"build": {
    "latest": "bullseye",
    "tags": [
        "base:${VARIANT}"
    ],
    "variantTags": {
        "bullseye": [
            "base:debian-11",
            "base:debian11",
            "base:debian",
        ],
        "buster": [
            "base:debian-10",
            "base:debian10"
        ]
    },
    //...
}
```

In this case, the image built for the `bullseye` variant will be tagged as follows:

- mcr.microsoft.com/devcontaienrs/base:latest
- mcr.microsoft.com/devcontaienrs/base:bullseye
- mcr.microsoft.com/devcontaienrs/base:debian
- mcr.microsoft.com/devcontaienrs/base:debian-11
- mcr.microsoft.com/devcontaienrs/base:debian11

#### The `build.variantBuildArgs` property
In some cases, you may need to vary build arguments in the images' `Dockerfile` by variant (beyond the `VARIANT` build arg itself). This can be done using the `build.variantBuildArgs` property. For example, consider the following:

```jsonc
"build": {
    "variantBuildArgs": {
        "17-bullseye": {
            "TARGET_JAVA_VERSION": "17",
            "BASE_IMAGE_VERSION_CODENAME": "bullseye"
        },
        "11-bullseye": {
            "TARGET_JAVA_VERSION": "11",
            "BASE_IMAGE_VERSION_CODENAME": "bullseye"
        },
        "17-buster": {
            "TARGET_JAVA_VERSION": "17",
            "BASE_IMAGE_VERSION_CODENAME": "buster"
        },
        "11-buster": {
            "JAVA_IMAGE_TAG": "11",
            "BASE_IMAGE_VERSION_CODENAME": "buster"
        }
    },
    //...
}
```

...and the related `Dockerfile`:

```Dockerfile
# This Dockerfile uses separate build arguments instead of VARIANT
ARG TARGET_JAVA_VERSION=11
ARG BASE_IMAGE_VERSION_CODENAME=bullseye
FROM openjdk:${TARGET_JAVA_VERSION}-jdk-${BASE_IMAGE_VERSION_CODENAME}
```

The value of these arguments is then passed in for a given variant.

#### Using `build.architecture` with variants
Because of problems with different OS versions, you may need to specify different architectures to build for different variants of the same image. This can be done using the `build.architecture` property with an object that maps a variant to an array of architectures. For example, the actual `debian` image contains the following:

```jsonc
"build": {
    "architectures": {
        "bullseye": ["linux/amd64", "linux/arm64"],
        "buster": ["linux/amd64"]
    },
    //...
}
```

This configuration will build ARM64 and x86_64 for Debian 11/bullseye and Debian 9/bullseye but not Debian 10/buster.

### The `dependencies` namespace

> **Note:** Whenever a new 3rd party OSS dependency is added to an image, be sure to also update NOTICES.txt in the root of this repository with its license terms. Packages installed from Linux distros directly via their package manager (not from 3rd party feeds) can be skipped as they are covered by the distribution image. Closed source dependencies are not allowed.

The dependencies namespace is used for dependency management and generation of [history markdown files](). It has no affect on the build process.  Consider the Debian [manifest.json](../src/debian/manifest.json) file.

```jsonc
"dependencies": {
    "image": "debian:${VARIANT}",
    "imageLink": "https://hub.docker.com/_/debian",
    "apt": [
        "apt-utils",
        //...
    ]
}
```

The **`image`** property is the actual base Docker image either in Docker Hub or MCR. **`imageLink`** is then the link to a description of the image.

Following this is a list of libraries installed in the image by its Dockerfile. The following package types are currently supported:

- `apt` - Debian/Ubuntu packages (apt-get)
- `apk` - Alpine Linux packages (apk)
- `git` - Dependencies downloaded using Git
- `pip` - Python pip packages
- `pipx` - Python utilities installed using pipx
- `npm` - npmjs.com packages installed using npm or yarn
- `go` - Dependencies downloaded using go get/install
- `cargo` - Rust dependencies downloaded using cargo
- `gem` - Ruby dependencies downloaded using gem
- `other` - Useful for other types of registrations that do not have a specific type that should be registered.
- `language` - Used primarily to elevate certain dependencies as language runtimes in history markdown files.

#### `dependencies.apt`, `dependencies.apk`

These two properties are arrays of either strings or objects that reference apt or apk package names. Given most installed packages are there simply for visibility because they come with the distro, these are not tracked in `cgmanifest.json` by default. When something comes from a 3rd party repository, the object syntax can be used to set `"cgIgnore": false`. An `annotation` property can also be used to for a description that should appear in history markdown files.

For example:

```jsonc
"apt": [{
        "cgIgnore": false,
        "name": "azure-cli",
        "annotation": "Azure CLI"
    },
    "cmake",
    "cppcheck",
    "valgrind"
]
```

Needed version information will be automatically extracted.

#### `dependencies.git`
Some dependencies like nvm or Oh My Zsh! are installed using a shallow git clone. The `git` property accepts a mapping of a description to a the path where the clone occurred in the resulting image. For example:

```jsonc
"git": {
    "Oh My Zsh!": "/home/codespace/.oh-my-zsh",
    "nvm": "/home/codespace/.nvm"
}
```

The commit ID will be automatically extracted.

#### `dependencies.pip`, `dependencies.pipx`, `dependencies.gem`, `dependencies.npm`
Any installed PyPl packages can be tracked by adding them to an array for the `pip` property. Tools installed using pipx can similarly be referenced using the `pipx` property.  For example:

```jsonc
"pipx": [
    "pylint",
    "virtualenv"
]
```

Ruby Gems and globally installed npm packages can be referenced the same way:

```jsonc
"gem": [
    "rake",
    "ruby-debug-ide",
    "debase",
    "jekyll"
],
"npm": [
    "eslint",
    "typescript"
]
```

#### `dependencies.go`, `dependencies.cargo`

Both Go modules/packages and Cargo packages can be referenced in a form similar to Gems, npm packages, or PyPl packages. However, there can sometimes be cases that require different commands to determine the version number that as actually installed. As a result, the `go` and `cargo` properties accept an object that maps the package to a command. A command of `null` causes the system to try to automatically detect the version.

For example:

```json
"cargo": {
    "rustfmt": null,
    "rust-analysis": "rustc --version",
    "rust-src": "rustc --version",
    "clippy": "rustc --version"
},
"go": {
    "golang.org/x/tools/gopls": null
}
```


#### `dependencies.other`, `dependencies.language`

The `other` property is intended to handle scenarios that one of the other supported `dependencies` properties cannot. It is an object that maps dependency names to a `versionCommand`, install `path`, and a `downloadUrl`.  The optional `cgIgnore` and `markdownIgnore` boolean properties can be used to specify whether the dependency should be excluded from tracking (`cgIgnore`) or excluded from history markdown output (`markdownIgnore`).

For example, if `kubectl` is installed by downloading the binary directly, the following would registry it and add it to the history markdown:

```jsonc
"other": {
    "kubectl": {
        "versionCommand": "kubectl version --client | grep -oP 'GitVersion\\s*:\\s*\\\"v\\K[0-9]+\\.[0-9]+\\.[0-9]+'",
        "path": "/usr/local/bin",
        "downloadUrl": "https://github.com/kubernetes/kubectl"
    }
}
```

The `languages` property is similar, but is primarily intended to provide an easy way to add things that are installed into the "Languages" section of the history markdown. If `"cgIgnore": true`, the version command can return a newline delimited list of versions if more than one is installed. Each line will then appear in the history markdown for the entry.

For example:

```jsonc
"languages": {
    "Java": {
        "cgIgnore": true,
        "versionCommand": "ls /opt/java | grep -oE '[0-9]+\\.[0-9]+\\.[0-9]+'",
        "path": "/opt/java/&lt;version&gt;"
    },
    ".NET": {
        "cgIgnore": true,
        "versionCommand": "ls /opt/dotnet | grep -oE '[0-9]+\\.[0-9]+\\.[0-9]+'",
        "path": "/home/codespaces/.dotnet<br />/opt/dotnet"
    },
    "Ruby": {
        "cgIgnore": true,
        "versionCommand": "ls /opt/ruby | grep -oE '[0-9]+\\.[0-9]+\\.[0-9]+'",
        "path": "/opt/ruby/&lt;version&gt;"
    }
}
```

Since the same dependencies can be in more than one image, default settings named dependencies can be set in the `otherDependencyDefaultSettings` property in [config.json](./config.json). When present in this file, only the name of the dependency and any overrides need to be specified for in `manifest.json`. For example, consider these examples that have default settings:

```jsonc
"other": {
    "kubectl": null,
    "Helm": null,
    "git": {
        "path": "/usr/local"
    }
},
"languages": {
    "PowerShell": {
        "cgIgnore": true
    },
    "GCC": {
        "cgIgnore": true
    },
    "Go": null
}
```


---

## Build process details and background

Currently the devcontainers repo contains pure Dockerfiles that need to be built when used. While this works well from the perspective of providing samples, some of the images install a significant number of runtimes or tools which can take a long time to build.

We can resolve this by pre-building some of these images, but in-so-doing we want to make sure we:

1. Ensure devcontainers continues to be a good source of samples
2. Improve the performance using the most popular (or in some cases slowest to build) container images
3. Make it easy for users to add additional software to the images
4. Make it easy for contributors to build, customize, and contribute new images

We won't be able to build all images in the repository or publish them under a Microsoft registry, but we would want to allow contributors to build their own images for contributions if they wanted to do so by keeping the ability to use a stand alone Dockerfile, image reference, or docker-compose file like today.

In order to meet the above requirements, this first phase keeps the way the dev containers deployed as it is now - an npm package. Future phases could introduce a formal registry, but this is overkill current state.

### Versioning

At this phase, versioning of the image can be tied to the release of the npm package. For example, as of this writing, the current version is 0.35.0. All images that are generated would then inherit this version.

We would follow semver rules for bumping up the repository name - any fix that needs to be deployed immediately would be "fix" level semver bump. When released as latest, the image would be tagged as is done in other Docker images. Using the 0.35.0 example, new images would be tagged as:

- 0
- 0.35
- 0.35.0
- latest

In the unlikely event a break fix needed to be deployed and not tagged latest, we would have a facility to tag as follows:

- 0.35
- 0.35.0

This has a few advantages:

1. Tags are generated for each version of the repository that is cut. This allows us to refer directly to the exact version of the source code used to build the container image to avoid confusion. e.g. `https://github.com/microsoft/devcontainers/tree/v0.35.0/containers/javascript-node-8`
2. Similarly, as containers are deprecated and removed from the repository, you can still refer back to the container source and README.
3. Upstream changes that break existing images can be handled as needed.
4. Developers can opt to use the image tag 0.35 to get the latest break fix version if desired or 0 to always get the latest non-breaking update.

When necessary, a specific version can also be specified for an individual image using a `version` property, but this is generally the exception.

### Release process and the contents of the npm package

When a release is cut, there are a few things that need to happen. One is obviously releasing the appropriate image. However, to continue to help customers understand how to customize their images, we would want to reference a user modifiable "stub" Dockerfile instead of an image directly. This also is important to help deal with shortcomings and workarounds that require something like specifying a build argument. For example:

```Dockerfile
FROM mcr.microsoft.com/devcontainer/javascript-node:0-10

# ** [Optional] Uncomment this section to install additional packages. **
#
# RUN apt-get update \
#    && export DEBIAN_FRONTEND=noninteractive \
#    && apt-get -y install --no-install-recommends <your-package-list-here>
```

This retains its value as a sample but minimizes the number of actual build steps. This template can evolve over time as new features are added Referencing The MAJOR version of the image in this Dockerfile allows us to push fixes or upstream updates that do not materially change the image without developers having to change their projects.

#### Repository contents

Consequently, this user stub Dockerfile needs to be versioned with the `devcontainer.json` file and can technically version independently of the actual main Dockerfile and image. Given this tie, it makes sense to keep this file with `devcontainer.json` in the repository. The repository therefore would could contain:

```text
📁 .devcontainer
     📄 base.Dockerfile
     📄 devcontainer.json
     📄 Dockerfile
📄 manifest.json
📄 README.md
📁 test-project
```

The `manifest.json` file dictates how the build process should behave as [described above](#setting-up-a-container-to-be-built). In this case, `devcontainer.json` points to `Dockerfile` used to generate the actual image.

Testing, then, is as simple as it is now - open the folder in `devcontainers` in a container and edit / test as required. Anyone simply copying the folder contents then gets a fully working version of the container even if in-flight and there is no image for it yet.

In the devcontainers repo itself, the `FROM` statement in `Dockerfile` would always point to `latest` or `dev` since it what is in main may not have even been released yet. This would get dynamically updated as a part of the release process - which we will cover next.

```Dockerfile
FROM mcr.microsoft.com/vs/devcontainer/javascript-node:dev-10
```

##### Automated updates of other Dockerfiles

The process also automatically swaps out referenced MCR images for MAJOR versions of built images in any Dockerfile that is added to the package. This allows us to push break fix and or security patches as break fix releases and people will get them. The build supports an option to not update `latest` and MAJOR versions, so we can also rev old MAJOR versions if we have to, but normally we'd roll forward instead.

#### Release process

When a release is cut, the contents of devcontainers repo are staged. The build process then does the following for the appropriate dev containers:

1. Build an image using the `Dockerfile` and push it to a container registry with the appropriate version tags. If the `variants` property is set, one image is built per variant, with the variant value being passed in as the `VARIANT` build argument.

2. After the image is built and pushed, `Dockerfile` is deleted from staging if present.

3. Next, `Dockerfile` is updated to point to the correct MAJOR version and a link is added to the Dockerfile used to build the referenced image.

    ```Dockerfile
    # For information on the contents of the image referenced below, see the Dockerfile at
    # https://github.com/microsoft/devcontainers/tree/v0.35.0/containers/javascript-node-10/.devcontainer/Dockerfile
    FROM mcr.microsoft.com/devcontainer/javascript-node:0-10
    ```

    This also works when the `VARIANT` ARG is used. The MAJOR part of the release version is placed in front of the argument in the FROM statement:

    ```Dockerfile
    ARG VARIANT="3"
    FROM mcr.microsoft.com/devcontainer/python:0-${VARIANT}
    ```

4. `devcontainer.json` is updated to point to `Dockerfile` and a comment is added that points to the image in this repository (along with its associated README for this specific version).

    ```json
    // For format details, see https://aka.ms/vscode-remote/devcontainer.json
    {
        "name": "Node.js 10",
        "dockerFile": "Dockerfile",
    }
    ```

## Linux ARM64 Specific Builds

The below provides a mechanism to build and test against targeted platforms (e.g. Linux ARM64). The following example uses the the dotnet container image for reference.

### Build

Run the @devcontainers/cli build command in the dotnet directory within the project repo (`src/dotnet/`).

Note a few of the arguments:

- `--platform`: specifies the architecture to target, in this case we will be targeting Linux ARM64

```bash
devcontainer build --workspace-foler /src/dotnet --platform linux/arm64 -t dotnet-arm64.
```

Once the build is complete, run the image using the below example. Note that the dotnet directory is mounted. The dotnet directory includes test scripts which will be used in the subsequent steps.

```bash
docker up --workspace-foler /src/dotnet --platform linux/arm64 -it dotnet-arm64 bash
```

Once in the running container, verify that the architecture is ARM64 by running the command:

```bash
 uname -m
```

For ARM64 on Linux, the architecture will show as `aarch64`.

### Test

For Linux ARM64 and the Dotnet container, attach to the running instance of the image previously created, run the test script and they should all pass.

```bash
/workspace/test-project/test.sh
```

### Reference

- [ARM documentation](https://developer.arm.com/documentation/102475/0100/Multi-architecture-images) for how to build multi-architecture images.
- [List of Supported Linux ARM64 DotNet SDK Images](https://hub.docker.com/_/microsoft-dotnet-sdk)
