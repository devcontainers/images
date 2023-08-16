# C# (.NET)

## Summary

*Develop C# and .NET based applications. Includes all needed SDKs, extensions, and dependencies.*

| Metadata | Value |  
|----------|-------|
| *Categories* | Core, Languages |
| *Image type* | Dockerfile |
| *Published images* | mcr.microsoft.com/devcontainers/dotnet |
| *Available image variants* | 6.0 /6.0-bullseye, 6.0-jammy, 6.0-focal, 7.0 /7.0-bullseye, 7.0-jammy ([full list](https://mcr.microsoft.com/v2/devcontainers/dotnet/tags/list)) |
| *Published image architecture(s)* | x86-64, arm64/aarch64 for `bullseye`, `jammy` variants |
| *Container host OS support* | Linux, macOS, Windows |
| *Container OS* | Ubuntu (`-focal`, `-jammy`), Debian (`-bullseye`) |
| *Languages, platforms* | .NET, .NET Core, C# |

See **[history](history)** for information on the contents of published images.

## Using this image

You can directly reference pre-built versions of `Dockerfile` by using the `image` property in `.devcontainer/devcontainer.json` or updating the `FROM` statement in your own  `Dockerfile` to one of the following. An example `Dockerfile` is included in this repository.

- `mcr.microsoft.com/devcontainers/dotnet` (latest)
- `mcr.microsoft.com/devcontainers/dotnet:6.0` (or `6.0-bullseye`, `6.0-jammy`, `6.0-focal` to pin to an OS version)
- `mcr.microsoft.com/devcontainers/dotnet:7.0` (or `7.0-bullseye`, `7.0-jammy` to pin to an OS version)

Refer to [this guide](https://containers.dev/guide/dockerfile) for more details.

You can decide how often you want updates by referencing a [semantic version](https://semver.org/) of each image. For example:

- `mcr.microsoft.com/devcontainers/dotnet:0-7.0`
- `mcr.microsoft.com/devcontainers/dotnet:0.204-7.0`
- `mcr.microsoft.com/devcontainers/dotnet:0.204.0-7.0`

See [history](history) for information on the contents of each version and [here for a complete list of available tags](https://mcr.microsoft.com/v2/devcontainers/dotnet/tags/list).

Alternatively, you can use the contents of [.devcontainer](.devcontainer) to fully customize your container's contents or to build it for a container host architecture not supported by the image.

### Enabling HTTPS in ASP.NET using your own dev certificate

To enable HTTPS in ASP.NET, you can mount an exported copy of your local dev certificate.

1. Export it using the following command:

    **Windows PowerShell**

    ```powershell
    dotnet dev-certs https --trust; dotnet dev-certs https -ep "$env:USERPROFILE/.aspnet/https/aspnetapp.pfx" -p "SecurePwdGoesHere"
    ```

    **macOS/Linux terminal**

    ```powershell
    dotnet dev-certs https --trust; dotnet dev-certs https -ep "${HOME}/.aspnet/https/aspnetapp.pfx" -p "SecurePwdGoesHere"
    ```

2. Add the following in to `devcontainer.json`:

    ```json
    "remoteEnv": {
        "ASPNETCORE_Kestrel__Certificates__Default__Password": "SecurePwdGoesHere",
        "ASPNETCORE_Kestrel__Certificates__Default__Path": "/home/vscode/.aspnet/https/aspnetapp.pfx",
    }
    ```

3. Finally, make the certificate available in the container as follows:

    Add the following to `devcontainer.json`:

    ```json
    "mounts": [ "source=${env:HOME}${env:USERPROFILE}/.aspnet/https,target=/home/vscode/.aspnet/https,type=bind" ]
    ```

### Installing Node.js or the Azure CLI

Given JavaScript front-end web client code written for use in conjunction with an ASP.NET back-end often requires the use of Node.js-based utilities to build, this container also includes `nvm` so that you can easily install Node.js. 

If you would like to install the Azure CLI, you can reference [a dev container feature](https://github.com/devcontainers/features) by adding the following to `devcontainer.json`:

```json
{
  "features": {
    "ghcr.io/devcontainers/features/azure-cli:1": {
      "version": "latest"
    }
  }
}
```

## License

Copyright (c) Microsoft Corporation. All rights reserved.

Licensed under the MIT License. See [LICENSE](https://github.com/devcontainers/images/blob/main/LICENSE).
