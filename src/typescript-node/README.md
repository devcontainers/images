# Node.js & TypeScript

## Summary

*Develop Node.js based applications in TypeScript. Includes Node.js, eslint, nvm, yarn, and the TypeScript compiler.*

| Metadata | Value |  
|----------|-------|
| *Categories* | Core, Languages |
| *Image type* | Dockerfile |
| *Published image* | mcr.microsoft.com/devcontainers/typescript-node |
| *Available image variants* | 22 / 22-bookworm, 20 / 20-bookworm, 18 / 18-bookworm, 22-bullseye, 20-bullseye, 18-bullseye, 20-buster, 18-buster ([full list](https://mcr.microsoft.com/v2/devcontainers/typescript-node/tags/list)) |
| *Published image architecture(s)* | x86-64, arm64/aarch64 for `bookworm`, and `bullseye` variants |
| *Container host OS support* | Linux, macOS, Windows |
| *Container OS* | Debian |
| *Languages, platforms* | Node.js, TypeScript |

## Using this image

You can directly reference pre-built versions of `Dockerfile` by using the `image` property in `.devcontainer/devcontainer.json` or updating the `FROM` statement in your own  `Dockerfile` to one of the following. An example `Dockerfile` is included in this repository.

- `mcr.microsoft.com/devcontainers/typescript-node` (latest)
- `mcr.microsoft.com/devcontainers/typescript-node:22` (or `22-bookworm`, `22-bullseye` to pin to an OS version)
- `mcr.microsoft.com/devcontainers/typescript-node:20` (or `20-bookworm`, `20-bullseye`, `20-buster` to pin to an OS version)
- `mcr.microsoft.com/devcontainers/typescript-node:18` (or `18-bookworm`, `18-bullseye`, `18-buster` to pin to an OS version)

Refer to [this guide](https://containers.dev/guide/dockerfile) for more details.

You can decide how often you want updates by referencing a [semantic version](https://semver.org/) of each image. For example:

- `mcr.microsoft.com/devcontainers/typescript-node:1-22` (or `1-22-bookworm`, `1-22-bullseye`)
- `mcr.microsoft.com/devcontainers/typescript-node:1.1-22` (or `1.1-22-bookworm`, `1.1-22-bullseye`)
- `mcr.microsoft.com/devcontainers/typescript-node:1.1.0-22` (or `1.1.0-20-bookworm`, `1.1.0-20-bullseye`)

However, we only do security patching on the latest [non-breaking, in support](https://github.com/devcontainers/images/issues/90) versions of images (e.g. `1-1.20`). You may want to run `apt-get update && apt-get upgrade` in your Dockerfile if you lock to a more specific version to at least pick up OS security updates.

Beyond TypeScript, Node.js, and `git`, this image / `Dockerfile` includes `eslint`, `zsh`, [Oh My Zsh!](https://ohmyz.sh/), a non-root `node` user with `sudo` access, and a set of common dependencies for development. Since `tslint` is [now fully deprecated](https://github.com/palantir/tslint/issues/4534), the image includes `tslint-to-eslint-config` globally to help you migrate.

Note that, while `eslint`and `typescript` are installed globally for convenience, [as of ESLint 6](https://eslint.org/docs/user-guide/migrating-to-6.0.0#-plugins-and-shareable-configs-are-no-longer-affected-by-eslints-location), you will need to install the following packages locally to lint TypeScript code: `@typescript-eslint/eslint-plugin`, `@typescript-eslint/parser`, `eslint`, `typescript`.

## License

Copyright (c) Microsoft Corporation. All rights reserved.

Licensed under the MIT License. See [LICENSE](https://github.com/devcontainers/images/blob/main/LICENSE)
