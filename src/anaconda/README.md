# Anaconda (Python 3)

## Summary

*Develop Anaconda applications in Python3. Installs dependencies from your environment.yml file and the Python extension.*

| Metadata | Value |  
|----------|-------|
| *Categories* | Core, Languages |
| *Image type* | Dockerfile |
| *Published image* | mcr.microsoft.com/devcontainers/anaconda:3 |
| *Published image architecture(s)* | x86-64, aarch64/arm64 |
| *Container host OS support* | Linux, macOS, Windows |
| *Container OS* | Debian |
| *Languages, platforms* | Python, Anaconda |

See **[history](history)** for information on the contents of published images.

## Using this image

### Configuration

You can directly reference pre-built versions of `.devcontainer/Dockerfile` by using the `image` property in `.devcontainer/devcontainer.json` or updating the `FROM` statement in your own `Dockerfile` to the following. An example `Dockerfile` is included in this repository.

- `mcr.microsoft.com/devcontainers/anaconda`

Refer to [this guide](https://containers.dev/guide/dockerfile) for more details.

You can decide how often you want updates by referencing a [semantic version](https://semver.org/) of each image. For example:

- `mcr.microsoft.com/devcontainers/anaconda:1-3`
- `mcr.microsoft.com/devcontainers/anaconda:1.0-3`
- `mcr.microsoft.com/devcontainers/anaconda:1.0.0-3`

See [history](history) for information on the contents of each version and [here for a complete list of available tags](https://mcr.microsoft.com/v2/devcontainers/anaconda/tags/list).

Alternatively, you can use the contents of [.devcontainer](.devcontainer) to fully customize your container's contents or to build it for a container host architecture not supported by the image.

### Using Conda

This dev container and its associated image includes [the `conda` package manager](https://aka.ms/vscode-remote/conda/about). Additional packages installed using Conda will be downloaded from Anaconda or another repository if you configure one. To reconfigure Conda in this container to access an alternative repository, please see information on [configuring Conda channels here](https://aka.ms/vscode-remote/conda/channel-setup).

Access to the Anaconda repository is covered by the [Anaconda Terms of Service](https://aka.ms/vscode-remote/conda/terms), which may require some organizations to obtain a commercial license from Anaconda. **However**, when this dev container or its associated image is used with GitHub Codespaces or GitHub Actions, **all users are permitted** to use the Anaconda Repository through the service, including organizations normally required by Anaconda to obtain a paid license for commercial activities. Note that third-party packages may be licensed by their publishers in ways that impact your intellectual property, and are used at your own risk.

#### Using the forwardPorts property

By default, frameworks like Flask only listens to localhost inside the container. As a result, we recommend using the `forwardPorts` property (available in v0.98.0+) to make these ports available locally.

```json
"forwardPorts": [5000]
```

The `appPort` property [publishes](https://docs.docker.com/config/containers/container-networking/#published-ports) rather than forwards the port, so applications need to listen to `*` or `0.0.0.0` for the application to be accessible externally. This conflicts with the defaults of some Python frameworks, but fortunately the `forwardPorts` property does not have this limitation.

#### Installing Node.js

Given JavaScript front-end web client code written for use in conjunction with a Python back-end often requires the use of Node.js-based utilities to build, you can use a [Node feature](https://github.com/devcontainers/features/tree/main/src/node) to install any version of Node by adding the following to `devcontainer.json`:

```json
{
  "features": {
    "ghcr.io/devcontainers/features/node:1": {
      "version": "latest"
    }
  }
}
```

#### Using different Conda channels

This image is based on the `ContinuumIO/anaconda3` docker image, which has all the `anaconda3` packages from defaults installed into the base conda's environment. It is recommended not to install packages from different channels in one environment since it could cause conflicts. When installing a package from a different channel (e.g., `conda-forge`) is required, the better approach is to create a new conda environment.

```bash
conda create --name <env_name> -c <channel> --yes <package_name>
```

#### Installing a different version of Python

As covered in the [user FAQ](https://docs.anaconda.com/anaconda/user-guide/faq) for Anaconda, you can install different versions of Python than the one in this image by running the following from a terminal:

```bash
conda install python=3.6
```

Or in a Dockerfile:

```Dockerfile
RUN conda install -y python=3.6
```

### [Optional] Adding the contents of environment.yml to the image

For convenience, this image will automatically install dependencies from the `environment.yml` file in the parent folder when the container is built. You can change this behavior by altering this line in the `.devcontainer/Dockerfile`:

```Dockerfile
RUN if [ -f "/tmp/conda-tmp/environment.yml" ]; then /opt/conda/bin/conda env update -n base -f /tmp/conda-tmp/environment.yml; fi \
    && rm -rf /tmp/conda-tmp
```

## Running Jupyter notebooks

Use this container to run Jupyter notebooks.

1. Edit the `./.devcontainer/devcontainer.json` file and add `8888` in the `forwardPorts` array:

    ```json
    // Use 'forwardPorts' to make a list of ports inside the container available locally.
	"forwardPorts": [8888],
    ```
.
1. Edit the `./.devcontainer/devcontainer.json` file and add a `postStartCommand` command to start the Jupyter notebook web app after the container is created. Use nohup so it isn't killed when the command finishes. Logs will appear in `nohup.out`.

    ```json
	// Use 'postStartCommand' to run commands after the container is created.
	"postStartCommand": "nohup bash -c 'jupyter notebook --ip=0.0.0.0 --port=8888 --allow-root &'",
    ```

1. View the terminal output to see the correct URL including the access token:

    ```bash
     http://127.0.0.1:8888/?token=1234567
    ```

1. Open the URL in a browser. You can edit and run code from the web browser.

## License

Copyright (c) Microsoft Corporation. All rights reserved.

Licensed under the MIT License. See [LICENSE](https://github.com/devcontainers/images/blob/main/LICENSE)
