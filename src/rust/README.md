# Rust

## Summary

*Develop Rust based applications. Includes appropriate runtime args and everything you need to get up and running.*

| Metadata | Value |  
|----------|-------|
| *Categories* | Core, Languages |
| *Image type* | Dockerfile |
| *Published images* | mcr.microsoft.com/devcontainers/rust |
| *Available image variants* | trixie, bookworm ([full list](https://mcr.microsoft.com/v2/devcontainers/rust/tags/list)) |
| *Published image architecture(s)* | x86-64, arm64/aarch64 for `trixie` and `bookworm` variant |
| *Container host OS support* | Linux, macOS, Windows |
| *Container OS* | Debian |
| *Languages, platforms* | Rust |

See **[history](history)** for information on the contents of published images.

## Using this image

You can directly reference pre-built versions of `.devcontainer/Dockerfile` by using the `image` property in `.devcontainer/devcontainer.json` or updating the `FROM` statement in your own `Dockerfile` to the following. An example `Dockerfile` is included in this repository.

- `mcr.microsoft.com/devcontainers/rust:latest` (or `trixie` `bookworm` to pin to an OS version)
- `mcr.microsoft.com/devcontainers/rust:1` (or `1-trixie` `1-bookworm` to pin to an OS version)

Refer to [this guide](https://containers.dev/guide/dockerfile) for more details.

We publish stable releases and experimental development images (`dev-*`, which contain the latest available changes from `main`). Latest stable: `mcr.microsoft.com/devcontainers/rust:latest` ([MCR](https://mcr.microsoft.com/en-us/artifact/mar/devcontainers/rust/tag/latest)). Other stable releases can be found at: [MCR Tags](https://mcr.microsoft.com/en-us/artifact/mar/devcontainers/rust/tags). Development images use the `dev-` prefix, for example `mcr.microsoft.com/devcontainers/rust:dev-1`, and may be updated in place; pin the image for reproducibility.

The examples below demonstrate stable image [semantic versioning](https://semver.org/); see the links above for current tags.

- `mcr.microsoft.com/devcontainers/rust:2-1` (or `2-1-trixie`, `2-1-bookworm` to pin to an OS version)
- `mcr.microsoft.com/devcontainers/rust:2.1-1` (or `2.1-1-trixie`, `2.1-1-bookworm` to pin to an OS version)
- `mcr.microsoft.com/devcontainers/rust:2.1.2-1` (or `2.1.2-1-trixie`, `2.1.2-1-bookworm` to pin to an OS version)

However, we only do security patching on the latest [non-breaking, in support](https://github.com/devcontainers/images/issues/90) versions of images (e.g. `2-1`). You may want to run `apt-get update && apt-get upgrade` in your Dockerfile if you lock to a more specific version to at least pick up OS security updates.

See [history](history) for information on the contents of each version and [here for a complete list of available tags](https://mcr.microsoft.com/v2/devcontainers/rust/tags/list).

Alternatively, you can use the contents of [.devcontainer](.devcontainer) to fully customize your container's contents or to build it for a container host architecture not supported by the image.

## License

Copyright (c) Microsoft Corporation. All rights reserved.

Licensed under the MIT License. See [LICENSE](https://github.com/devcontainers/images/blob/main/LICENSE).
