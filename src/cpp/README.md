# C++

## Summary

*Develop C++ applications on Linux. Includes Fedora C++ build tools.*

| Metadata | Value |  
|----------|-------|
| *Categories* | Core, Languages |
| *Image type* | Dockerfile |
| *Published images* | ghcr.io/sebst/devcontainers/cpp |
| *Available image variants* | fedora43, fedora42 ([full list](https://ghcr.io/v2/sebst/devcontainers/cpp/tags/list)) |
| *Published image architecture(s)* | x86-64, aarch64/arm64 for `fedora43` and `fedora42` variants |
| *Container host OS support* | Linux, macOS, Windows |
| *Container OS* | Fedora |
| *Languages, platforms* | C++ |

See **[history](history)** for information on the contents of published images.

## Using this image

You can directly reference pre-built versions of `Dockerfile` by using the `image` property in `.devcontainer/devcontainer.json` or updating the `FROM` statement in your own  `Dockerfile` to one of the following. An example `Dockerfile` is included in this repository.

- `ghcr.io/sebst/devcontainers/cpp` (latest Fedora)
- `ghcr.io/sebst/devcontainers/cpp:fedora` (latest Fedora)
- `ghcr.io/sebst/devcontainers/cpp:fedora43` (or `43`)
- `ghcr.io/sebst/devcontainers/cpp:fedora42` (or `42`)

Refer to [this guide](https://containers.dev/guide/dockerfile) for more details.

You can decide how often you want updates by referencing a [semantic version](https://semver.org/) of each image. For example:
- `ghcr.io/sebst/devcontainers/cpp:3-43`
- `ghcr.io/sebst/devcontainers/cpp:3.0-43`
- `ghcr.io/sebst/devcontainers/cpp:3.0.0-43`
- `ghcr.io/sebst/devcontainers/cpp:3-42`
- `ghcr.io/sebst/devcontainers/cpp:3.0-42`
- `ghcr.io/sebst/devcontainers/cpp:3.0.0-42`

However, we only do security patching on the latest [non-breaking, in support](https://github.com/sebst/devcontainer-images-fork/issues/90) versions of images (e.g. `3-43`). You may want to run `dnf -y update` in your Dockerfile if you lock to a more specific version to at least pick up OS security updates.

See [history](history) for information on the contents of each version and [here for a complete list of available tags](https://ghcr.io/v2/sebst/devcontainers/cpp/tags/list).

Alternatively, you can use the contents of [.devcontainer](.devcontainer) to fully customize your container's contents or to build it for a container host architecture not supported by the image.

Beyond `git`, this image / `Dockerfile` includes `zsh`, [Oh My Zsh!](https://ohmyz.sh/), a non-root `vscode` user with `sudo` access, a set of common dependencies for development, and [Vcpkg](https://github.com/microsoft/vcpkg) a cross-platform package manager for C++.

### Using Vcpkg
This dev container and its associated image includes a clone of the [`Vcpkg`](https://github.com/microsoft/vcpkg) repo for library packages, and a bootstrapped instance of the [Vcpkg-tool](https://github.com/microsoft/vcpkg-tool) itself.

The minimum version of `cmake` required to install packages is higher than the version available in the main package repositories for Debian (<=11) and Ubuntu (<=21.10).  `Vcpkg` will download a compatible version of `cmake` for its own use if that is the case (on x86_64 architectures).

Most additional library packages installed using Vcpkg will be downloaded from their [official distribution locations](https://github.com/microsoft/vcpkg#security). To configure Vcpkg in this container to access an alternate registry, more information can be found here: [Registries: Bring your own libraries to vcpkg](https://devblogs.microsoft.com/cppblog/registries-bring-your-own-libraries-to-vcpkg/).

To update the available library packages, pull the latest from the git repository using the following command in the terminal:

```sh
cd "${VCPKG_ROOT}"
git pull --ff-only
```
Please install additonal system packages `autoconf automake libtool m4 autoconf-archive` to use vcpkg in manifest
mode. It can be added in the Dockerfile as following:
```
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install autoconf automake libtool m4 autoconf-archive \
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*
```
If building the image from source directly please uncomment respective `# && apt-get -y install autoconf automake libtool m4 autoconf-archive \` line in Dockerfile.
> Note: Please review the [Vcpkg license details](https://github.com/microsoft/vcpkg#license) to better understand its own license and additional license information pertaining to library packages and supported ports.

## License

Copyright (c) Microsoft Corporation. All rights reserved.

Licensed under the MIT License. See [LICENSE](https://github.com/sebst/devcontainer-images-fork/blob/main/LICENSE).
