# Go

## Summary

*Develop Go based applications. Includes appropriate runtime args, Go, common tools, extensions, and dependencies.*

| Metadata | Value |
|----------|-------|
| *Contributors* | The VS Code Team |
| *Categories* | Core, Languages |
| *Definition type* | Dockerfile |
| *Published images* | mcr.microsoft.com/devcontainers/go |
| *Available image variants* | 1 / 1-bookworm, 1.24 / 1.24-bookworm, 1.23 / 1.23-bookworm, 1.22 / 1.22-bookworm, 1-bullseye, 1.22-bullseye ([full list](https://mcr.microsoft.com/v2/devcontainers/go/tags/list)) |
| *Published image architecture(s)* | x86-64, arm64/aarch64 for `bookworm`, and `bullseye` variants |
| *Container host OS support* | Linux, macOS, Windows |
| *Container OS* | Debian |
| *Languages, platforms* | Go |

See **[history](history)** for information on the contents of published images.

## Using this image

You can directly reference pre-built versions of `Dockerfile` by using the `image` property in `.devcontainer/devcontainer.json` or updating the `FROM` statement in your own  `Dockerfile` to one of the following. An example `Dockerfile` is included in this repository.

- `mcr.microsoft.com/devcontainers/go` (latest)
- `mcr.microsoft.com/devcontainers/go:1` (or `1-bookworm`, `1-bullseye` to pin to an OS version)
- `mcr.microsoft.com/devcontainers/go:1.24` (or `1.24-bookworm`, `1.24-bullseye` to pin to an OS version)
- `mcr.microsoft.com/devcontainers/go:1.23` (or `1.23-bookworm`, `1.23-bullseye` to pin to an OS version)
- `mcr.microsoft.com/devcontainers/go:1.22` (or `1.22-bookworm`, `1.22-bullseye` to pin to an OS version)

Refer to [this guide](https://containers.dev/guide/dockerfile) for more details.

You can decide how often you want updates by referencing a [semantic version](https://semver.org/) of each image. For example:

- `mcr.microsoft.com/devcontainers/go:1-1.24` (or `1-1.24-bookworm`, `1-1.24-bullseye`)
- `mcr.microsoft.com/devcontainers/go:1.4-1.24` (or `1.4-1.24-bookworm`, `1.4-1.24-bullseye`)
- `mcr.microsoft.com/devcontainers/go:1.4.0-1.24` (or `1.4.0-1.24-bookworm`, `1.4.0-1.24-bullseye`)

However, we only do security patching on the latest [non-breaking, in support](https://github.com/devcontainers/images/issues/90) versions of images (e.g. `1-1.24`). You may want to run `apt-get update && apt-get upgrade` in your Dockerfile if you lock to a more specific version to at least pick up OS security updates.

See [history](history) for information on the contents of each version and [here for a complete list of available tags](https://mcr.microsoft.com/v2/devcontainers/go/tags/list).


#### Installing Node.js

Given JavaScript front-end web client code written for use in conjunction with a Go back-end often requires the use of Node.js-based utilities to build, you can use a [Node feature](https://github.com/devcontainers/features/tree/main/src/node) to install any version of Node by adding the following to `devcontainer.json`:

```json
{
  "features": {
    "ghcr.io/devcontainers/features/node:1": {
      "version": "latest"
    }
  }
}
```

## License

Copyright (c) Microsoft Corporation. All rights reserved.

Licensed under the MIT License. See [LICENSE](https://github.com/microsoft/vscode-dev-containers/blob/main/LICENSE).
