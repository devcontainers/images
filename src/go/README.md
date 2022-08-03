# Go

## Summary

*Develop Go based applications. Includes appropriate runtime args, Go, common tools, extensions, and dependencies.*

| Metadata | Value |
|----------|-------|
| *Contributors* | The VS Code Team |
| *Categories* | Core, Languages |
| *Definition type* | Dockerfile |
| *Published images* | mcr.microsoft.com/vscode/devcontainers/go |
| *Available image variants* | 1 / 1-bullseye, 1.18 / 1.18-bullseye, 1.17 / 1.17-bullseye, 1-buster, 1.18-buster, 1.17-buster  ([full list](https://mcr.microsoft.com/v2/vscode/devcontainers/go/tags/list)) |
| *Published image architecture(s)* | x86-64, arm64/aarch64 for `bullseye` variants |
| *Works in Codespaces* | Yes |
| *Container host OS support* | Linux, macOS, Windows |
| *Container OS* | Debian |
| *Languages, platforms* | Go |

See **[history](history)** for information on the contents of published images.

## Using this definition

While the definition itself works unmodified, you can select the version of Go the container uses by updating the `VARIANT` arg in the included `devcontainer.json` (and rebuilding if you've already created the container).

```json
// Or you can use 1.17-bullseye or 1.17-buster if you want to pin to an OS version
"args": { "VARIANT": "1.17" }
```

You can also directly reference pre-built versions of `.devcontainer/base.Dockerfile` by using the `image` property in `.devcontainer/devcontainer.json` or updating the `FROM` statement in your own  `Dockerfile` to one of the following. An example `Dockerfile` is included in this repository.

- `mcr.microsoft.com/vscode/devcontainers/go` (latest)
- `mcr.microsoft.com/vscode/devcontainers/go:1` (or `1-bullseye`, `1-buster` to pin to an OS version)
- `mcr.microsoft.com/vscode/devcontainers/go:1.17` (or `1.17-bullseye`, `1.17-buster` to pin to an OS version)
- `mcr.microsoft.com/vscode/devcontainers/go:1.18` (or `1.18-bullseye`, `1.18-buster` to pin to an OS version)

You can decide how often you want updates by referencing a [semantic version](https://semver.org/) of each image. For example:

- `mcr.microsoft.com/vscode/devcontainers/go:0-1.18` (or `0-1.18-bullseye`, `0-1.18-buster`)
- `mcr.microsoft.com/vscode/devcontainers/go:0.206-1.18` (or `0.205-1.18-bullseye`, `0.205-1.18-buster`)
- `mcr.microsoft.com/vscode/devcontainers/go:0.206.0-1.18` (or `0.205.0-1.18-bullseye`, `0.205.0-1.18-buster`)

However, we only do security patching on the latest [non-breaking, in support](https://github.com/microsoft/vscode-dev-containers/issues/532) versions of images (e.g. `0-1.16`). You may want to run `apt-get update && apt-get upgrade` in your Dockerfile if you lock to a more specific version to at least pick up OS security updates.

See [history](history) for information on the contents of each version and [here for a complete list of available tags](https://mcr.microsoft.com/v2/vscode/devcontainers/go/tags/list).

Alternatively, you can use the contents of `base.Dockerfile` to fully customize your container's contents or to build it for a container host architecture not supported by the image.

#### Installing Node.js

Given JavaScript front-end web client code written for use in conjunction with a Python back-end often requires the use of Node.js-based utilities to build, you can use a [Node feature](https://github.com/devcontainers/features/tree/main/src/node) to install any version of Node by adding the following to `.devcontainer.json`:

```json
{
  "features": {
    "ghcr.io/devcontainers/features/node:1": "latest"
  }
}
```

## License

Copyright (c) Microsoft Corporation. All rights reserved.

Licensed under the MIT License. See [LICENSE](https://github.com/microsoft/vscode-dev-containers/blob/main/LICENSE).
