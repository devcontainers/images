# Swift

## Summary

Develop Swift based applications. Includes everything you need to get up and running.

| Metadata | Value |  
|----------|-------|
| *Contributors* | [0xTim](https://github.com/0xTim), [adam-fowler](https://github.com/adam-fowler), [cloudnull](https://github.com/cloudnull), [pvzig](https://github.com/pvzig)] |
| *Categories* | Languages |
| *Definition type* | Dockerfile |
| *Supported architecture(s)* | x86-64, arm64 |
| *Works in Codespaces* | Yes |
| *Container host OS support* | Linux, macOS, Windows |
| *Container OS* | Debian |
| *Languages, platforms* | Swift |

See **[history](history)** for information on the contents of published images.

## Using this image

You can directly reference pre-built versions of `Dockerfile` by using the `image` property in `.devcontainer/devcontainer.json` or updating the `FROM` statement in your own  `Dockerfile` to one of the following. An example `Dockerfile` is included in this repository.

- `mcr.microsoft.com/devcontainers/go` (latest)
- `mcr.microsoft.com/devcontainers/go:1` (or `1-bullseye`, `1-buster` to pin to an OS version)
- `mcr.microsoft.com/devcontainers/go:1.18` (or `1.18-bullseye`, `1.18-buster` to pin to an OS version)
- `mcr.microsoft.com/devcontainers/go:1.19` (or `1.19-bullseye`, `1.19-buster` to pin to an OS version)

Refer to [this guide](https://containers.dev/guide/dockerfile) for more details.

You can decide how often you want updates by referencing a [semantic version](https://semver.org/) of each image. For example:

- `mcr.microsoft.com/devcontainers/go:0-1.19` (or `0-1.19-bullseye`, `0-1.19-buster`)
- `mcr.microsoft.com/devcontainers/go:0.207-1.19` (or `0.207-1.19-bullseye`, `0.207-1.19-buster`)
- `mcr.microsoft.com/devcontainers/go:0.207.1-1.19` (or `0.207.1-1.19-bullseye`, `0.207.1-1.19-buster`)

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

Copyright (c) Visual Studio Code Swift extension project. All rights reserved.

Licensed under the MIT License. See [LICENSE](https://github.com/swift-server/swift-dev-container/blob/main/LICENSE).
