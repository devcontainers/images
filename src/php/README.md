# PHP

## Summary

*Develop PHP based applications. Includes needed tools, extensions, and dependencies.*

| Metadata | Value |  
|----------|-------|
| *Categories* | Languages |
| *Image type* | Dockerfile |
| *Published images* | mcr.microsoft.com/devcontainers/php |
| *Available image variants* | 8 / 8-bookworm, 8.4 / 8.4-bookworm, 8.3 / 8.3-bookworm, 8.2 / 8.2-bookworm, 8-bullseye, 8.4-bullseye,,8.3-bullseye, 8.2-bullseye ([full list](https://mcr.microsoft.com/v2/devcontainers/php/tags/list)) |
| *Published image architecture(s)* | x86-64, arm64/aarch64 for `bookworm`, and `bullseye` variants |
| *Container host OS support* | Linux, macOS, Windows |
| *Container OS* | Debian |
| *Languages, platforms* | PHP |

See **[history](history)** for information on the contents of published images.

## Using this image

You can directly reference pre-built versions of `Dockerfile` by using the `image` property in `.devcontainer/devcontainer.json` or updating the `FROM` statement in your own `Dockerfile` with one of the following:

- `mcr.microsoft.com/devcontainers/php` (latest)
- `mcr.microsoft.com/devcontainers/php:8` (or `8-bookworm`, `8-bullseye` to pin to an OS version)
- `mcr.microsoft.com/devcontainers/php:8.4` (or `8.4-bookworm`, `8.4-bullseye` to pin to an OS version)
- `mcr.microsoft.com/devcontainers/php:8.3` (or `8.3-bookworm`, `8.3-bullseye` to pin to an OS version)
- `mcr.microsoft.com/devcontainers/php:8.2` (or `8.2-bookworm`, `8.2-bullseye` to pin to an OS version)

Refer to [this guide](https://containers.dev/guide/dockerfile) for more details.

You can decide how often you want updates by referencing a [semantic version](https://semver.org/) of each image. For example:

- `mcr.microsoft.com/devcontainers/php:1-8` (or `1-8-bookworm`, `1-8-bullseye`)
- `mcr.microsoft.com/devcontainers/php:1.0-8` (or `1.0-8-bookworm`, `1.0-8-bullseye`)
- `mcr.microsoft.com/devcontainers/php:1.0.3-8` (or `1.0.3-8-bookworm`, `1.0.3-8-bullseye`)

However, we only do security patching on the latest [non-breaking, in support](https://github.com/devcontainers/images/issues/90) versions of images (e.g. `1-8`). You may want to run `apt-get update && apt-get upgrade` in your Dockerfile if you lock to a more specific version to at least pick up OS security updates.

See [history](history) for information on the contents of each version and [here for a complete list of available tags](https://mcr.microsoft.com/v2/devcontainers/php/tags/list).

Alternatively, you can use the contents of [.devcontainer](.devcontainer) to fully customize your container's contents or to build it for a container host architecture not supported by the image.

### Installing Node.js

Given JavaScript front-end web client code written for use in conjunction with a PHP back-end often requires the use of Node.js-based utilities to build, this container also includes `nvm` so that you can easily install Node.js. 

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

### Starting / stopping Apache

This dev container includes Apache in addition to the PHP CLI. While you can use PHP's built in CLI (e.g. `php -S 0.0.0.0:8080`), you can start Apache by running:

```bash
apache2ctl start
```

Apache will be available on port `8080`.

If you want to wire in something directly from your source code into the `www` folder, you can add a symlink as follows to `postCreateCommand`:

```json
"postCreateCommand": "sudo chmod a+x \"$(pwd)\" && sudo rm -rf /var/www/html && sudo ln -s \"$(pwd)\" /var/www/html"
```

...or execute this from a terminal window once the container is up:

```bash
sudo chmod a+x "$(pwd)" && sudo rm -rf /var/www/html && sudo ln -s "$(pwd)" /var/www/html
```

## License

Copyright (c) Microsoft Corporation. All rights reserved.

Licensed under the MIT License. See [LICENSE](https://github.com/devcontainers/images/blob/main/LICENSE).
