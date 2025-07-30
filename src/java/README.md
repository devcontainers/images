# Java

## Summary

*Develop Java applications. Includes the JDK and Java extensions.*

| Metadata | Value |  
|----------|-------|
| *Categories* | Core, Languages |
| *Image type* | Dockerfile |
| *Published images* | mcr.microsoft.com/devcontainers/java |
| *Available image variants* | 11 / 11-bookworm, 17 / 17-bookworm, 21 / 21-bookworm, 11-bullseye, 17-bullseye, 21-bullseye ([full list](https://mcr.microsoft.com/v2/devcontainers/java/tags/list)) |
| *Published image architecture(s)* | x86-64, arm64/aarch64 for `bookworm`, and `bullseye` variants |
| *Container host OS support* | Linux, macOS, Windows |
| *Container OS* | Debian |
| *Languages, platforms* | Java |

See **[history](history)** for information on the contents of published images.

## Using this image

You can directly reference pre-built versions of `Dockerfile` by using the `image` property in `.devcontainer/devcontainer.json` or updating the `FROM` statement in your own  `Dockerfile` to one of the following. An example `Dockerfile` is included in this repository.

- `mcr.microsoft.com/devcontainers/java` (latest)
- `mcr.microsoft.com/devcontainers/java:21` (or `21-bookworm`, `21-bullseye` to pin to an OS version)
- `mcr.microsoft.com/devcontainers/java:11` (or `17-bookworm`, `11-bullseye` to pin to an OS version)
- `mcr.microsoft.com/devcontainers/java:17` (or `17-bookworm`, `17-bullseye` to pin to an OS version)

Refer to [this guide](https://containers.dev/guide/dockerfile) for more details.

You can decide how often you want updates by referencing a [semantic version](https://semver.org/) of each image. For example:

- `mcr.microsoft.com/devcontainers/java:1-11` (or `1-11-bookworm`, `1-11-bullseye` to pin to an OS version)
- `mcr.microsoft.com/devcontainers/java:1.0-11` (or `1.0-11-bookworm`, `1.0-11-bullseye` to pin to an OS version)
- `mcr.microsoft.com/devcontainers/java:1.0.0-11` (or `1.0.0-11-bookworm`, `1.0.0-11-bullseye` to pin to an OS version)

However, we only do security patching on the latest [non-breaking, in support](https://github.com/devcontainers/images/issues/90) versions of images (e.g. `1-11`). You may want to run `apt-get update && apt-get upgrade` in your Dockerfile if you lock to a more specific version to at least pick up OS security updates.

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

Also, you can use a [Node feature](https://github.com/devcontainers/features/tree/main/src/node) to install any version of Node by adding the following to `devcontainer.json`:

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
