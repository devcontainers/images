# Java 8

## Summary

*Develop Java applications. Includes the JDK 8 and Java extensions.*

| Metadata | Value |  
|----------|-------|
| *Categories* | Core, Languages |
| *Image type* | Dockerfile |
| *Published images* | mcr.microsoft.com/devcontainers/java:8 |
| *Available image variants* | 8 / 8-bookworm, 8-bullseye ([full list](https://mcr.microsoft.com/v2/devcontainers/java/tags/list)) |
| *Published image architecture(s)* | x86-64, arm64/aarch64 for `bullseye` and `bookworm` variants |
| *Container host OS support* | Linux, macOS, Windows |
| *Container OS* | Debian |
| *Languages, platforms* | Java |

See **[history](history)** for information on the contents of published images.

## Using this image

> **Note:** A version of this [image for **newer JDKs**](../java) is also available!

You can directly reference pre-built versions of `Dockerfile` by using the `image` property in `.devcontainer/devcontainer.json` or updating the `FROM` statement in your own  `Dockerfile` to one of the following. An example `Dockerfile` is included in this repository.

- `mcr.microsoft.com/devcontainers/java:8` (or `8-bookworm`, `8-bullseye`, `8-buster` to pin to an OS version)

Refer to [this guide](https://containers.dev/guide/dockerfile) for more details.

You can decide how often you want updates by referencing a [semantic version](https://semver.org/) of each image. For example:

- `mcr.microsoft.com/devcontainers/java:2-8` (or `2-8-bookworm`, `2-8-bullseye` to pin to an OS version)
- `mcr.microsoft.com/devcontainers/java:2.0-8` (or `2.0-8-bookworm`, `2.0-8-bullseye` to pin to an OS version)
- `mcr.microsoft.com/devcontainers/java:2.0.0-8` (or `2.0.0-8-bookworm`, `2.0.0-8-bullseye` to pin to an OS version)

However, we only do security patching on the latest [non-breaking, in support](https://github.com/devcontainers/images/issues/90) versions of images (e.g. `2-8`). You may want to run `apt-get update && apt-get upgrade` in your Dockerfile if you lock to a more specific version to at least pick up OS security updates.

See [history](history) for information on the contents of each version and [here for a complete list of available tags](https://mcr.microsoft.com/v2/devcontainers/java/tags/list).

Alternatively, you can use the contents of [.devcontainer](.devcontainer) to fully customize your container's contents or to build it for a container host architecture not supported by the image.

### Installing Maven or Gradle

You can use the [Java Feature](https://github.com/devcontainers/features/tree/main/src/java) to install `maven` and `gradle` in `.devcontainer/devcontainer.json`:

```json
{
  "features": {
     "ghcr.io/devcontainers/features/java:1": {
        "version": "none",
        "installGradle": "true",
        "installMaven": "true"
    }
  }
}
```

### Installing Node.js

Given JavaScript front-end web client code written for use in conjunction with a Java back-end often requires the use of Node.js-based utilities to build, this container also includes `nvm` so that you can easily install Node.js.

Also, you can use a [Node Feature](https://github.com/devcontainers/features/tree/main/src/node) to install any version of Node by adding the following to `.devcontainer/devcontainer.json`:

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

Licensed under the MIT License. See [LICENSE](https://github.com/devcontainers/images/blob/main/LICENSE).
