# Ruby

## Summary

*Develop Ruby based applications. includes everything you need to get up and running.*

| Metadata | Value |  
|----------|-------|
| *Categories* | Core, Languages |
| *Image type* | Dockerfile |
| *Published images* | mcr.microsoft.com/devcontainers/ruby |
| *Available image variants* | 3 / 3-bookworm, 3.4 / 3.4-bookworm, 3.3 / 3.3-bookworm, 3.2 / 3.2-bookworm, 3.1 / 3.1-bookworm, 3-bullseye, 3.4-bullseye, 3.3-bullseye, 3.2-bullseye, 3.1-bullseye ([full list](https://mcr.microsoft.com/v2/devcontainers/ruby/tags/list)) |
| *Published image architecture(s)* | x86-64, arm64/aarch64 for `bookworm` , and `bullseye` variants |
| *Container host OS support* | Linux, macOS, Windows |
| *Container OS* | Debian |
| *Languages, platforms* | Ruby |

See **[history](history)** for information on the contents of published images.

## Using this image

You can directly reference pre-built versions of `Dockerfile` by using the `image` property in `.devcontainer/devcontainer.json` or updating the `FROM` statement in your own  `Dockerfile` to one of the following. An example `Dockerfile` is included in this repository.

- `mcr.microsoft.com/devcontainers/ruby`     (latest)
- `mcr.microsoft.com/devcontainers/ruby:3`   (or `3-bookworm`, `3-bullseye` to pin to an OS version)
- `mcr.microsoft.com/devcontainers/ruby:3.4` (or `3.4-bookworm`, `3.4-bullseye` to pin to an OS version)
- `mcr.microsoft.com/devcontainers/ruby:3.3` (or `3.3-bookworm`, `3.3-bullseye` to pin to an OS version)
- `mcr.microsoft.com/devcontainers/ruby:3.2` (or `3.2-bookworm`, `3.2-bullseye` to pin to an OS version)
- `mcr.microsoft.com/devcontainers/ruby:3.1` (or `3.1-bookworm`, `3.1-bullseye` to pin to an OS version)

Refer to [this guide](https://containers.dev/guide/dockerfile) for more details.

You can decide how often you want updates by referencing a [semantic version](https://semver.org/) of each image. For example:

- `mcr.microsoft.com/devcontainers/ruby:1-3`     (or `1-3-bookworm`, `1-3-bullseye` to pin to an OS version)
- `mcr.microsoft.com/devcontainers/ruby:1.0-3`   (or `1.0-3-bookworm`, `1.0-3-bullseye` to pin to an OS version)
- `mcr.microsoft.com/devcontainers/ruby:1.0.0-3` (or `1.0.0-3-bookworm`, `1.0.0-3-bullseye` to pin to an OS version)

However, we only do security patching on the latest [non-breaking, in support](https://github.com/devcontainers/images/issues/90) versions of images (e.g. `1-3.2`). You may want to run `apt-get update && apt-get upgrade` in your Dockerfile if you lock to a more specific version to at least pick up OS security updates.

See [history](history) for information on the contents of each version and [here for a complete list of available tags](https://mcr.microsoft.com/v2/devcontainers/ruby/tags/list).

Alternatively, you can use the contents of [.devcontainer](.devcontainer) to fully customize your container's contents or to build it for a container host architecture not supported by the image.

### Installing Node.js

Given JavaScript front-end web client code written for use in conjunction with a Ruby back-end often requires the use of Node.js-based utilities to build, this container also includes `nvm` so that you can easily install Node.js. You can change the version of Node.js installed or disable its installation by updating the `args` property in `.devcontainer/devcontainer.json`.

```jsonc
"args": {
    "VARIANT": "2",
    "NODE_VERSION": "14" // Set to "none" to skip Node.js installation
}
```

## License

Copyright (c) Microsoft Corporation. All rights reserved.

Licensed under the MIT License. See [LICENSE](https://github.com/devcontainers/images/blob/main/LICENSE).
