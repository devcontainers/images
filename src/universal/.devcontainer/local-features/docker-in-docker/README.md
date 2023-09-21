
# Docker (Docker-in-Docker) (docker-in-docker)

Create child containers *inside* a container, independent from the host's docker instance. Installs Docker extension in the container along with needed CLIs.

## Example Usage

```json
"features": {
    "ghcr.io/devcontainers/features/docker-in-docker:2": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| version | Select or enter a Docker/Moby Engine version. (Availability can vary by OS version.) | string | latest |
| moby | Install OSS Moby build instead of Docker CE | boolean | true |
| dockerDashComposeVersion | Default version of Docker Compose (v1 or v2 or none) | string | v1 |
| azureDnsAutoDetection | Allow automatically setting the dockerd DNS server when the installation script detects it is running in Azure | boolean | true |
| dockerDefaultAddressPool | Define default address pools for Docker networks. e.g. base=192.168.0.0/16,size=24 | string | - |
| installDockerBuildx | Install Docker Buildx | boolean | true |

## Customizations

### VS Code Extensions

- `ms-azuretools.vscode-docker`

## Limitations

This docker-in-docker Dev Container Feature is roughly based on the [official docker-in-docker wrapper script](https://github.com/moby/moby/blob/master/hack/dind) that is part of the [Moby project](https://mobyproject.org/). With this in mind:
* As the name implies, the Feature is expected to work when the host is running Docker (or the OSS Moby container engine it is built on). It may be possible to get running in other container engines, but it has not been tested with them.
* The host and the container must be running on the same chip architecture. You will not be able to use it with an emulated x86 image with Docker Desktop on an Apple Silicon Mac, like in this example:
  ```
  FROM --platform=linux/amd64 mcr.microsoft.com/devcontainers/typescript-node:16
  ```
  See [Issue #219](https://github.com/devcontainers/features/issues/219) for more details.


## OS Support

This Feature should work on recent versions of Debian/Ubuntu-based distributions with the `apt` package manager installed.

`bash` is required to execute the `install.sh` script.


---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/devcontainers/features/blob/main/src/docker-in-docker/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
