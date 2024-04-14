# Jekyll

## Summary

*Develop static sites with Jekyll, includes everything you need to get up and running.*

| Metadata | Value |  
|----------|-------|
| *Categories* | Community, Languages, Frameworks |
| *Image type* | Dockerfile |
| *Published images* | mcr.microsoft.com/devcontainers/jekyll |
| *Available image variants* | bookworm, bullseye, buster ([full list](https://mcr.microsoft.com/v2/devcontainers/jekyll/tags/list)) |
| *Published image architecture(s)* | x86-64, arm64/aarch64 for `bookworm`, and `bullseye` variant |
| *Container host OS support* | Linux, macOS, Windows |
| *Container OS* | Debian |
| *Languages, platforms* | Ruby, Jekyll |

See **[history](history)** for information on the contents of published images.

## Using this image

In addition to Ruby and Bundler, this development container installs Jekyll and the required tools at startup:

- If your Jekyll project contains a `Gemfile` in the root folder, the development container will install all gems at startup by running `bundle install`. This is the [recommended](https://jekyllrb.com/docs/step-by-step/10-deployment/#gemfile) approach as it allows you to specify the exact Jekyll version your project requires and list all additional Jekyll plugins.
- If there's no `Gemfile`, the development container will install Jekyll automatically, picking the latest version. You might need to manually install the other dependencies your project relies on, including all relevant Jekyll plugins.

Refer to [this guide](https://containers.dev/guide/dockerfile) for more details.

You can directly reference pre-built versions of `Dockerfile` by using the `image` property in `.devcontainer/devcontainer.json` or updating the `FROM` statement in your own  `Dockerfile` to one of the following. An example `Dockerfile` is included in this repository.


- `mcr.microsoft.com/devcontainers/jekyll` (latest)
- `mcr.microsoft.com/devcontainers/jekyll:bookworm`
- `mcr.microsoft.com/devcontainers/jekyll:bullseye`
- `mcr.microsoft.com/devcontainers/jekyll:buster`

You can decide how often you want updates by referencing a [semantic version](https://semver.org/) of each image. For example:

- `mcr.microsoft.com/devcontainers/jekyll:2` (or `2-bookworm`, `2-bullseye`, `2-buster` to pin to an OS version)
- `mcr.microsoft.com/devcontainers/jekyll:2.0` (or `2.0-bookworm`, `2.0-bullseye`, `2.0-buster` to pin to an OS version)
- `mcr.microsoft.com/devcontainers/jekyll:2.0.0` (or `2.0.0-bookworm`, `2.0.0-bullseye`, `2.0.0-buster` to pin to an OS version)

However, we only do security patching on the latest [non-breaking, in support](https://github.com/devcontainers/images/issues/90) versions of images (e.g. `2-bullseye`). You may want to run `apt-get update && apt-get upgrade` in your Dockerfile if you lock to a more specific version to at least pick up OS security updates.

See [history](history) for information on the contents of each version and [here for a complete list of available tags](https://mcr.microsoft.com/v2/devcontainers/jekyll/tags/list).

Alternatively, you can use the contents of [.devcontainer](.devcontainer) to fully customize your container's contents or to build it for a container host architecture not supported by the image.

### Installing Node.js

Given JavaScript front-end web client code written for use in conjunction with a Jekyll site often requires the use of Node.js-based utilities to build, this container also includes `nvm` so that you can easily install Node.js.

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
