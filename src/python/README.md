# Python 3

## Summary

*Develop Python 3 applications.*

| Metadata | Value |
|----------|-------|
| *Categories* | Core, Languages |
| *Image type* | Dockerfile |
| *Published image* | mcr.microsoft.com/devcontainers/python |
| *Available image variants* | 3 / 3-bookworm, 3.9 / 3.9-bookworm, 3.10 / 3.10-bookworm, 3.11-bookworm / 3.11, 3.12-bookworm / 3.12, 3.13-bookworm / 3.13, 3-bullseye, 3.9-bullseye, 3.10-bullseye, 3.11-bullseye, 3.12-bullseye, 3.13-bullseye ([full list](https://mcr.microsoft.com/v2/devcontainers/python/tags/list)) |
| *Published image architecture(s)* | x86-64, arm64/aarch64 for `bookworm`, and `bullseye` variants |
| *Container Host OS Support* | Linux, macOS, Windows |
| *Container OS* | Debian |
| *Languages, platforms* | Python |

See **[history](history)** for information on the contents of published images.

## Using this image

### Configuration

You can directly reference [pre-built](https://containers.dev/implementors/reference/#prebuilding) versions of this image by using the `image` property in `.devcontainer/devcontainer.json` or updating the `FROM` statement in your own `Dockerfile` with one of the following:

- `mcr.microsoft.com/devcontainers/python:3`    (latest)
- `mcr.microsoft.com/devcontainers/python:3.9`  (or `3.9-bookworm`, `3.9-bullseye` to pin to an OS version)
- `mcr.microsoft.com/devcontainers/python:3.10` (or `3.10-bookworm`, `3.10-bullseye` to pin to an OS version)
- `mcr.microsoft.com/devcontainers/python:3.11` (or `3.11-bookworm`, `3.11-bullseye` to pin to an OS version)
- `mcr.microsoft.com/devcontainers/python:3.12` (or `3.12-bookworm`, `3.12-bullseye` to pin to an OS version)
- `mcr.microsoft.com/devcontainers/python:3.13` (or `3.13-bookworm`, `3.13-bullseye` to pin to an OS version)

Refer to [this guide](https://containers.dev/guide/dockerfile) for more details.

You can decide how often you want updates by referencing a [semantic version](https://semver.org/) of each image. For example:

- `mcr.microsoft.com/devcontainers/python:1-3.9` (or `1-3.9-bullseye`)
- `mcr.microsoft.com/devcontainers/python:1.0-3.9` (or `1.0-3.9-bullseye`)
- `mcr.microsoft.com/devcontainers/python:1.0.0-3.9` (or `1.0.0-3.9-bullseye`)

However, we only do security patching on the latest [non-breaking, in support](https://github.com/devcontainers/images/issues/90) versions of images (e.g. `1-3`). 
You may want to run `apt-get update && apt-get upgrade` in your Dockerfile if you lock to a more specific version to at least pick up OS security updates.

See [history](history) for information on the contents of each version and [here for a complete list of available tags](https://mcr.microsoft.com/v2/devcontainers/python/tags/list).

Alternatively, you can use the contents of [.devcontainer](.devcontainer) to fully customize the your container's contents or build for a container architecture the image does not support.

Beyond Python and `git`, this image includes a number of Python tools, `zsh`, [Oh My Zsh!](https://ohmyz.sh/), a non-root `vscode` user with `sudo` access, and a set of common dependencies for development. See [.devcontainer](.devcontainer) for the full config.

### Installing Node.js

Given JavaScript front-end web client code written for use in conjunction with a Python back-end often requires the use of Node.js-based utilities to build, this container also includes `nvm` so that you can easily install Node.js. 

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

#### Installing or updating Python utilities

This container installs all Python development utilities using [pipx](https://pipxproject.github.io/pipx/) to avoid impacting the global Python environment. You can use this same utility to add additional utilities in an isolated environment. For example:

```bash
pipx install prospector
```

See the [pipx documentation](https://pipxproject.github.io/pipx/docs/) for additional information.

#### Using the forwardPorts property

By default, frameworks like Flask only listen to localhost inside the container. As a result, we recommend using the `forwardPorts` property (available in v0.98.0+) to make these ports available locally.

```json
"forwardPorts": [5000]
```

The `appPort` property [publishes](https://docs.docker.com/config/containers/container-networking/#published-ports) rather than forwards the port, so applications need to listen to `*` or `0.0.0.0` for the application to be accessible externally. This conflicts with the defaults of some Python frameworks, but fortunately the `forwardPorts` property does not have this limitation.

If you've already opened your folder in a container, rebuild the container using the **Remote-Containers: Rebuild Container** command from the Command Palette (<kbd>F1</kbd>) so the settings take effect.

#### [Optional] Building your requirements into the container image

If your requirements rarely change, you can include the contents of `requirements.txt` in the container by adding the following to your `Dockerfile`:

```Dockerfile
COPY requirements.txt /tmp/pip-tmp/
RUN pip3 --disable-pip-version-check --no-cache-dir install -r /tmp/pip-tmp/requirements.txt \
    && rm -rf /tmp/pip-tmp
```

Since `requirements.txt` is likely in the folder you opened be sure to include `"context": ".."` to `devcontainer.json`. This allows the Dockerfile to access everything in the opened folder.

#### [Optional] Allowing the non-root vscode user to pip install globally without sudo

You can opt into using the `vscode` non-root user in the container by adding `"remoteUser": "vscode"` to `devcontainer.json`. However, by default, you will need to use `sudo` to perform global pip installs.

```bash
sudo pip install <your-package-here>
```

Or stick with user installs:

```bash
pip install --user <your-package-here>
```

If you prefer, you can add the following to your `Dockerfile` to cause global installs to go into a different folder that the `vscode` user can write to.

```Dockerfile
ENV PIP_TARGET=/usr/local/pip-global
ENV PYTHONPATH=${PIP_TARGET}:${PYTHONPATH}
ENV PATH=${PIP_TARGET}/bin:${PATH}
RUN if ! cat /etc/group | grep -e "^pip-global:" > /dev/null 2>&1; then groupadd -r pip-global; fi \
    && usermod -a -G pip-global vscode \
    && umask 0002 && mkdir -p ${PIP_TARGET} \
    && chown :pip-global ${PIP_TARGET} \
    && ( [ ! -f "/etc/profile.d/00-restore-env.sh" ] || sed -i -e "s/export PATH=/export PATH=\/usr\/local\/pip-global:/" /etc/profile.d/00-restore-env.sh )
```

#### [Optional] Installing multiple versions of Python in the same image

If you would prefer to have multiple Python versions in your container, use `Dockerfile` and update the `FROM` statement:

```Dockerfile
FROM ubuntu:jammy
ARG PYTHON_PACKAGES="python3.13 python3.12 python3 python3-pip python3-venv"
RUN apt-get update && apt-get install --no-install-recommends -yq software-properties-common \
     && add-apt-repository ppa:deadsnakes/ppa && apt-get update \
     && apt-get install -yq --no-install-recommends ${PYTHON_PACKAGES} \
     && pip3 install --no-cache-dir --upgrade pip setuptools wheel
```

## License

Copyright (c) Microsoft Corporation. All rights reserved.

Licensed under the MIT License. See [LICENSE](https://github.com/devcontainers/images/blob/main/LICENSE)

