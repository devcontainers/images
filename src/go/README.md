# Go

## Summary

*Develop Go based applications. Includes appropriate runtime args, Go, common tools, extensions, and dependencies.*

| Metadata | Value |
|----------|-------|
| *Contributors* | The VS Code Team |
| *Categories* | Core, Languages |
| *Definition type* | Dockerfile |
| *Published images* | mcr.microsoft.com/devcontainers/go |
| *Available image variants* | 1 / 1-trixie, 1.27 / 1.27-trixie, 1.26 / 1.26-trixie, 1.25 / 1.25-trixie, 1-bookworm, 1.27-bookworm, 1.26-bookworm, 1.25-bookworm ([full list](https://mcr.microsoft.com/v2/devcontainers/go/tags/list)) |
| *Published image architecture(s)* | x86-64, arm64/aarch64 for `trixie`, `bookworm` variants |
| *Container host OS support* | Linux, macOS, Windows |
| *Container OS* | Debian |
| *Languages, platforms* | Go |

See **[history](history)** for information on the contents of published images.

## Using this image

You can directly reference pre-built versions of `Dockerfile` by using the `image` property in `.devcontainer/devcontainer.json` or updating the `FROM` statement in your own  `Dockerfile` to one of the following. An example `Dockerfile` is included in this repository.

- `mcr.microsoft.com/devcontainers/go` (latest)
- `mcr.microsoft.com/devcontainers/go:1` (or `1-trixie`, `1-bookworm` to pin to an OS version)
- `mcr.microsoft.com/devcontainers/go:1.27` (or `1.27-trixie`, `1.27-bookworm` to pin to an OS version)
- `mcr.microsoft.com/devcontainers/go:1.26` (or `1.26-trixie`, `1.26-bookworm` to pin to an OS version)
- `mcr.microsoft.com/devcontainers/go:1.25` (or `1.25-trixie`, `1.25-bookworm` to pin to an OS version)

Refer to [this guide](https://containers.dev/guide/dockerfile) for more details.

We publish stable releases and experimental development images (`dev-*`, which contain the latest available changes from `main`). Latest stable: `mcr.microsoft.com/devcontainers/go:latest` ([MCR](https://mcr.microsoft.com/en-us/artifact/mar/devcontainers/go/tag/latest)). Other stable releases can be found at: [MCR Tags](https://mcr.microsoft.com/en-us/artifact/mar/devcontainers/go/tags). Development images use the `dev-` prefix, for example `mcr.microsoft.com/devcontainers/go:dev-1.27`, and may be updated in place; pin the image for reproducibility.

The examples below demonstrate stable image [semantic versioning](https://semver.org/); see the links above for current tags.

- `mcr.microsoft.com/devcontainers/go:2-1.27` (or `2-1.27-trixie`, `2-1.27-bookworm`)
- `mcr.microsoft.com/devcontainers/go:2.3-1.27` (or `2.3-1.27-trixie`, `2.3-1.27-bookworm`)
- `mcr.microsoft.com/devcontainers/go:2.3.1-1.27` (or `2.3.1-1.27-trixie`, `2.3.1-1.27-bookworm`)

However, we only do security patching on the latest [non-breaking, in support](https://github.com/devcontainers/images/issues/90) versions of images (e.g. `2-1.27`). You may want to run `apt-get update && apt-get upgrade` in your Dockerfile if you lock to a more specific version to at least pick up OS security updates.

See [history](history) for information on the contents of each version and [here for a complete list of available tags](https://mcr.microsoft.com/v2/devcontainers/go/tags/list).


#### Installing Node.js

Given JavaScript front-end web client code written for use in conjunction with a Go back-end often requires the use of Node.js-based utilities to build, you can use a [Node feature](https://github.com/devcontainers/features/tree/main/src/node) to install any version of Node by adding the following to `devcontainer.json`:

```json
{
  "features": {
    "ghcr.io/devcontainers/features/node:2": {
      "version": "latest"
    }
  }
}
```

## License

Copyright (c) Microsoft Corporation. All rights reserved.

Licensed under the MIT License. See [LICENSE](https://github.com/microsoft/vscode-dev-containers/blob/main/LICENSE).
