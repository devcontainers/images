# Alpine

## Summary

*Simple Alpine container with Git installed.*

| Metadata | Value |  
|----------|-------|
| *Categories* | Core, Other |
| *Image type* | Dockerfile |
| *Published images* | ghcr.io/sebst/devcontainers/base:alpine |
| *Available image variants* | alpine-3.23, alpine-3.22, alpine-3.21, alpine-3.20 ([full list](https://ghcr.io/v2/sebst/devcontainers/base/tags/list)) |

| *Published image architecture(s)* | x86-64, aarch64/arm64 |
| *Container host OS support* | Linux, macOS, Windows |
| *Container OS* | Alpine Linux |
| *Languages, platforms* | Any |

See **[history](history)** for information on the contents of published images.

## Using this image

You can also directly reference pre-built versions of `.devcontainer/Dockerfile` by using the `image` property in `.devcontainer/devcontainer.json` or updating the `FROM` statement in your own  `Dockerfile` to one of the following. An example `Dockerfile` is included in this repository.

- `ghcr.io/sebst/devcontainers/base:alpine` (latest)
- `ghcr.io/sebst/devcontainers/base:alpine-3.23`
- `ghcr.io/sebst/devcontainers/base:alpine-3.22`
- `ghcr.io/sebst/devcontainers/base:alpine-3.21`
- `ghcr.io/sebst/devcontainers/base:alpine-3.20`


Refer to [this guide](https://containers.dev/guide/dockerfile) for more details.

You can decide how often you want updates by referencing a [semantic version](https://semver.org/) of each image. For example:

- `ghcr.io/sebst/devcontainers/base:3-alpine`
- `ghcr.io/sebst/devcontainers/base:3.0-alpine`
- `ghcr.io/sebst/devcontainers/base:3.0.3-alpine`

See [history](history) for information on the contents of each version and [here for a complete list of available tags](https://ghcr.io/v2/sebst/devcontainers/base/tags/list).

Beyond `git`, this image / `Dockerfile` includes `zsh`, [Oh My Zsh!](https://ohmyz.sh/), a non-root `vscode` user with `sudo` access, and a set of common dependencies for development.

## License

Copyright (c) Microsoft Corporation. All rights reserved.

Licensed under the MIT License. See [LICENSE](https://github.com/sebst/devcontainer-images-fork/blob/main/LICENSE)
