# Alpine

## Summary

*Simple Alpine container with Git installed.*

| Metadata | Value |  
|----------|-------|
| *Categories* | Core, Other |
| *Image type* | Dockerfile |
| *Published images* | mcr.microsoft.com/devcontainers/base:alpine |
| *Available image variants* | alpine-3.21, alpine-3.20, alpine-3.19, alpine-3.18 ([full list](https://mcr.microsoft.com/v2/devcontainers/base/tags/list)) |
| *Published image architecture(s)* | x86-64, aarch64/arm64 |
| *Container host OS support* | Linux, macOS, Windows |
| *Container OS* | Alpine Linux |
| *Languages, platforms* | Any |

See **[history](history)** for information on the contents of published images.

## Using this image

You can also directly reference pre-built versions of `.devcontainer/Dockerfile` by using the `image` property in `.devcontainer/devcontainer.json` or updating the `FROM` statement in your own  `Dockerfile` to one of the following. An example `Dockerfile` is included in this repository.

- `mcr.microsoft.com/devcontainers/base:alpine` (latest)
- `mcr.microsoft.com/devcontainers/base:alpine-3.21`
- `mcr.microsoft.com/devcontainers/base:alpine-3.20`
- `mcr.microsoft.com/devcontainers/base:alpine-3.19`
- `mcr.microsoft.com/devcontainers/base:alpine-3.18`

Refer to [this guide](https://containers.dev/guide/dockerfile) for more details.

You can decide how often you want updates by referencing a [semantic version](https://semver.org/) of each image. For example:

- `mcr.microsoft.com/devcontainers/base:0-alpine`
- `mcr.microsoft.com/devcontainers/base:0.209-alpine`
- `mcr.microsoft.com/devcontainers/base:0.209.0-alpine`

See [history](history) for information on the contents of each version and [here for a complete list of available tags](https://mcr.microsoft.com/v2/devcontainers/base/tags/list).

Beyond `git`, this image / `Dockerfile` includes `zsh`, [Oh My Zsh!](https://ohmyz.sh/), a non-root `vscode` user with `sudo` access, and a set of common dependencies for development.

## License

Copyright (c) Microsoft Corporation. All rights reserved.

Licensed under the MIT License. See [LICENSE](https://github.com/devcontainers/images/blob/main/LICENSE)
