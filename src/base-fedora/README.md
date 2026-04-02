# Fedora

## Summary

*Simple Fedora container with Git installed.*

| Metadata | Value |  
|----------|-------|
| *Categories* | Core, Other |
| *Image type* | Dockerfile |
| *Published images* | ghcr.io/sebst/devcontainers/base-fedora |
| *Available image variants* | 43, 42 ([full list](https://ghcr.io/v2/sebst/devcontainers/base-fedora/tags/list)) |
| *Published image architecture(s)* | x86-64, aarch64/arm64 for `43` and `42` variants |
| *Container host OS support* | Linux, macOS, Windows |
| *Container OS* | Fedora |
| *Languages, platforms* | Any |

See **[history](history)** for information on the contents of published images.

## Using this image

You can directly reference pre-built versions of `Dockerfile` by using the `image` property in `.devcontainer/devcontainer.json` or updating the `FROM` statement in your own `Dockerfile` to one of the following. An example `Dockerfile` is included in this repository.

- `ghcr.io/sebst/devcontainers/base-fedora` (latest)
- `ghcr.io/sebst/devcontainers/base-fedora:43` (or `fedora43`)
- `ghcr.io/sebst/devcontainers/base-fedora:42` (or `fedora42`)

Refer to [this guide](https://containers.dev/guide/dockerfile) for more details.

You can decide how often you want updates by referencing a [semantic version](https://semver.org/) of each image. For example:

- `ghcr.io/sebst/devcontainers/base-fedora:1-43`
- `ghcr.io/sebst/devcontainers/base-fedora:1.0-43`
- `ghcr.io/sebst/devcontainers/base-fedora:1.0.0-43`

See [history](history) for information on the contents of each version and [here for a complete list of available tags](https://ghcr.io/v2/sebst/devcontainers/base-fedora/tags/list).

Alternatively, you can use the contents of [.devcontainer](.devcontainer) to fully customize your container's contents or to build it for a container host architecture not supported by the image.

Beyond `git`, this image / `Dockerfile` includes `zsh`, [Oh My Zsh!](https://ohmyz.sh/), a non-root `vscode` user with `sudo` access, and a set of common dependencies for development.

## License

Copyright (c) Microsoft Corporation. All rights reserved.

Licensed under the MIT License. See [LICENSE](https://github.com/sebst/devcontainer-images-fork/blob/main/LICENSE)
