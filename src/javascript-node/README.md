# Node.js & JavaScript

## Summary

*Develop Node.js based applications. Includes Node.js, eslint, nvm, and yarn.*

| Metadata | Value |  
|----------|-------|
| *Categories* | Core, Languages |
| *Image type* | Dockerfile |
| *Published image* | mcr.microsoft.com/devcontainers/javascript-node |
| *Available image variants* | 22 / 22-bookworm, 20 / 20-bookworm, 18 / 18-bookworm, 20-bullseye, 18-bullseye, ([full list](https://mcr.microsoft.com/v2/devcontainers/javascript-node/tags/list)) |
| *Published image architecture(s)* | x86-64, arm64/aarch64 for `bookworm`, and `bullseye` variants |
| *Container host OS support* | Linux, macOS, Windows |
| *Container OS* | Debian |
| *Languages, platforms* | Node.js, JavaScript |

## Using this image

You can directly reference pre-built versions of `Dockerfile` by using the `image` property in `.devcontainer/devcontainer.json` or updating the `FROM` statement in your own  `Dockerfile` to one of the following. An example `Dockerfile` is included in this repository.

- `mcr.microsoft.com/devcontainers/javascript-node` (latest)
- `mcr.microsoft.com/devcontainers/javascript-node:22` (or `22-bookworm`, `22-bullseye` to pin to an OS version)
- `mcr.microsoft.com/devcontainers/javascript-node:20` (or `20-bookworm`, `20-bullseye` to pin to an OS version)
- `mcr.microsoft.com/devcontainers/javascript-node:18` (or `18-bookworm`, `18-bullseye` to pin to an OS version)

Refer to [this guide](https://containers.dev/guide/dockerfile) for more details.

You can decide how often you want updates by referencing a [semantic version](https://semver.org/) of each image. For example:

- `mcr.microsoft.com/devcontainers/typescript-node:1-22` (or `1-22-bookworm`, `1-22-bullseye`)
- `mcr.microsoft.com/devcontainers/typescript-node:1.1-22` (or `1.1-22-bookworm`, `1.1-22-bullseye`)
- `mcr.microsoft.com/devcontainers/typescript-node:1.1.0-22` (or `1.1.0-22-bookworm`, `1.1.0-22-bullseye`)

However, we only do security patching on the latest [non-breaking, in support](https://github.com/devcontainers/images/issues/90) versions of images (e.g. `1-1.0`). You may want to run `apt-get update && apt-get upgrade` in your Dockerfile if you lock to a more specific version to at least pick up OS security updates.

Beyond Node.js and `git`, this image / `Dockerfile` includes `eslint`, `zsh`, [Oh My Zsh!](https://ohmyz.sh/), a non-root `node` user with `sudo` access, and a set of common dependencies for development. [Node Version Manager](https://github.com/nvm-sh/nvm) (`nvm`) is also included in case you need to use a different version of Node.js than the one included in the image.

## License

Copyright (c) Microsoft Corporation. All rights reserved.

Licensed under the MIT License. See [LICENSE](https://github.com/devcontainers/images/blob/main/LICENSE)
