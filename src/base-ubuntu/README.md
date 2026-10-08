# Ubuntu

## Summary

*A simple Ubuntu container with Git and other common utilities installed.*

| Metadata | Value |  
|----------|-------|
| *Categories* | Core, Other |
| *Image type* | Dockerfile |
| *Published images* | mcr.microsoft.com/devcontainers/base:ubuntu |
| *Available image variants* | ubuntu26.04 / resolute, ubuntu24.04 / noble, ubuntu22.04 / jammy ([full list](https://mcr.microsoft.com/v2/devcontainers/base/tags/list)) |
| *Published image architecture(s)* | x86-64, aarch64/arm64 for `ubuntu26.04` (`resolute`) and `ubuntu24.04` (`noble`) and `ubuntu22.04` (`jammy`) variants |
| *Container host OS support* | Linux, macOS, Windows |
| *Container OS* | Ubuntu |
| *Languages, platforms* | Any |

See **[history](history)** for information on the contents of published images.

## Using this image

You can directly reference pre-built versions of `Dockerfile` by using the `image` property in `.devcontainer/devcontainer.json` or updating the `FROM` statement in your own `Dockerfile` to one of the following. An example `Dockerfile` is included in this repository.

- `mcr.microsoft.com/devcontainers/base:ubuntu` (latest LTS release)
- `mcr.microsoft.com/devcontainers/base:ubuntu26.04` (or `resolute`)
- `mcr.microsoft.com/devcontainers/base:ubuntu24.04` (or `noble`)
- `mcr.microsoft.com/devcontainers/base:ubuntu22.04` (or `jammy`)

Refer to [this guide](https://containers.dev/guide/dockerfile) for more details.

We publish stable releases and experimental development images (`dev-*`, which contain the latest available changes from `main`). Latest stable: `mcr.microsoft.com/devcontainers/base:ubuntu` ([MCR](https://mcr.microsoft.com/en-us/artifact/mar/devcontainers/base/tag/ubuntu)). Other stable releases can be found at: [MCR Tags](https://mcr.microsoft.com/en-us/artifact/mar/devcontainers/base/tags). Development images use the `dev-` prefix, for example `mcr.microsoft.com/devcontainers/base:dev-ubuntu26.04`, and may be updated in place; pin the image for reproducibility.

The examples below demonstrate stable image [semantic versioning](https://semver.org/); see the links above for current tags.

- `mcr.microsoft.com/devcontainers/base:3-jammy`
- `mcr.microsoft.com/devcontainers/base:3.0-jammy`
- `mcr.microsoft.com/devcontainers/base:3.0.9-jammy`

See [history](history) for information on the contents of each version and [here for a complete list of available tags](https://mcr.microsoft.com/v2/devcontainers/base/tags/list).

Alternatively, you can use the contents of [.devcontainer](.devcontainer) to fully customize your container's contents or to build it for a container host architecture not supported by the image.

Beyond `git`, this image / `Dockerfile` includes `zsh`, [Oh My Zsh!](https://ohmyz.sh/), a non-root `vscode` user with `sudo` access, and a set of common dependencies for development.

## License

Copyright (c) Microsoft Corporation. All rights reserved.

Licensed under the MIT License. See [LICENSE](https://github.com/devcontainers/images/blob/main/LICENSE)
