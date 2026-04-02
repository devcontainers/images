# Java

## Summary

*Develop Java applications. Includes the JDK and Java extensions.*

| Metadata | Value |  
|----------|-------|
| *Categories* | Core, Languages |
| *Image type* | Dockerfile |
| *Published images* | ghcr.io/sebst/devcontainers/java |
| *Available image variants* | 11 / 11-fedora43, 17 / 17-fedora43, 21 / 21-fedora43, 25 / 25-fedora43, 25-fedora42, 21-fedora42, 17-fedora42, 11-fedora42 ([full list](https://ghcr.io/v2/sebst/devcontainers/java/tags/list)) |
| *Published image architecture(s)* | x86-64, arm64/aarch64 for `fedora43` and `fedora42` variants |
| *Container host OS support* | Linux, macOS, Windows |
| *Container OS* | Fedora |
| *Languages, platforms* | Java |

See **[history](history)** for information on the contents of published images.

## Using this image

You can directly reference pre-built versions of `Dockerfile` by using the `image` property in `.devcontainer/devcontainer.json` or updating the `FROM` statement in your own  `Dockerfile` to one of the following. An example `Dockerfile` is included in this repository.

- `ghcr.io/sebst/devcontainers/java` (latest)
- `ghcr.io/sebst/devcontainers/java:25` (or `25-fedora43`, `25-fedora42` to pin to an OS version)
- `ghcr.io/sebst/devcontainers/java:21` (or `21-fedora43`, `21-fedora42` to pin to an OS version)
- `ghcr.io/sebst/devcontainers/java:11` (or `11-fedora43`, `11-fedora42` to pin to an OS version)
- `ghcr.io/sebst/devcontainers/java:17` (or `17-fedora43`, `17-fedora42` to pin to an OS version)

Refer to [this guide](https://containers.dev/guide/dockerfile) for more details.

You can decide how often you want updates by referencing a [semantic version](https://semver.org/) of each image. For example:

- `ghcr.io/sebst/devcontainers/java:4-11` (or `4-11-fedora43`, `4-11-fedora42` to pin to an OS version)
- `ghcr.io/sebst/devcontainers/java:4.0-11` (or `4.0-11-fedora43`, `4.0-11-fedora42` to pin to an OS version)
- `ghcr.io/sebst/devcontainers/java:4.0.0-11` (or `4.0.0-11-fedora43`, `4.0.0-11-fedora42` to pin to an OS version)

However, we only do security patching on the latest [non-breaking, in support](https://github.com/sebst/devcontainer-images-fork/issues/90) versions of images (e.g. `4-11`). You may want to run `dnf -y update` in your Dockerfile if you lock to a more specific version to at least pick up OS security updates.

See [history](history) for information on the contents of each version and [here for a complete list of available tags](https://ghcr.io/v2/sebst/devcontainers/java/tags/list).

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

Licensed under the MIT License. See [LICENSE](https://github.com/sebst/devcontainer-images-fork/blob/main/LICENSE).
