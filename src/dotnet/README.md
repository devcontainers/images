# C# (.NET)

## Summary

*Develop C# and .NET based applications. Includes all needed SDKs, extensions, and dependencies.*

| Metadata | Value |  
|----------|-------|
| *Categories* | Core, Languages |
| *Image type* | Dockerfile |
| *Published images* | mcr.microsoft.com/devcontainers/dotnet |
| *Available image variants* | 9.0 /9.0-bookworm, 8.0 /8.0-bookworm, 9.0-noble, 8.0-noble, 8.0-jammy ([full list](https://mcr.microsoft.com/v2/devcontainers/dotnet/tags/list)) |
| *Published image architecture(s)* | x86-64, arm64/aarch64 for `bookworm`, `bullseye`, `noble`, `jammy` variants |
| *Container host OS support* | Linux, macOS, Windows |
| *Container OS* | Ubuntu (`-focal`, `-jammy`, `-noble`), Debian (`-bullseye`, `-bookworm`) |
| *Languages, platforms* | .NET, .NET Core, C# |

See **[history](history)** for information on the contents of published images.

## Using this image

You can directly reference pre-built versions of `Dockerfile` by using the `image` property in `.devcontainer/devcontainer.json` or updating the `FROM` statement in your own  `Dockerfile` to one of the following. An example `Dockerfile` is included in this repository.

- `mcr.microsoft.com/devcontainers/dotnet` (latest)
- `mcr.microsoft.com/devcontainers/dotnet:9.0` (or `9.0-bookworm`, `9.0-noble` to pin to an OS version)
- `mcr.microsoft.com/devcontainers/dotnet:8.0` (or `8.0-bookworm`, `8.0-noble`, `8.0-jammy` to pin to an OS version)


Refer to [this guide](https://containers.dev/guide/dockerfile) for more details.

You can decide how often you want updates by referencing a [semantic version](https://semver.org/) of each image. For example:

- `mcr.microsoft.com/devcontainers/dotnet:1-9.0`
- `mcr.microsoft.com/devcontainers/dotnet:1.3-9.0`
- `mcr.microsoft.com/devcontainers/dotnet:1.3.0-9.0`

See [history](history) for information on the contents of each version and [here for a complete list of available tags](https://mcr.microsoft.com/v2/devcontainers/dotnet/tags/list).

Alternatively, you can use the contents of [.devcontainer](.devcontainer) to fully customize your container's contents or to build it for a container host architecture not supported by the image.

### Enabling HTTPS in ASP.NET Core by creating a dev certificate

You can use `dotnet dev-certs https` inside the dev container to create a development HTTPS certificate for ASP.NET Core. However, each time the container is recreated, the development certificate will be lost. To make the development certificate survive container rebuilds, you can use a named volume. 

For example, in `devcontainer.json`, add a named volume for the `x509stores` directory inside the `vscode` user's home folder. Also add a lifecycle script, which adds the development certificate to the dev container's trust store.

``` json
"mounts": [
    {
        "type": "volume",
        "source": "x509stores",
        "target": "/home/vscode/.dotnet/corefx/cryptography/x509stores"
    }
],
"onCreateCommand": "bash .devcontainer/setup-dotnet-dev-cert.sh"
```

The contents of `.devcontainer/setup-dotnet-dev-cert.sh`:

``` bash
#!/usr/bin/env bash

# Change ownership of the .dotnet directory to the vscode user (to avoid permission errors)
sudo chown -R vscode:vscode /home/vscode/.dotnet

# If there is no development certificate, this command will generate a new one
dotnet dev-certs https

# Export the ASP.NET Core HTTPS development certificate to a PEM file
sudo -E dotnet dev-certs https --export-path /usr/local/share/ca-certificates/dotnet-dev-cert.crt --format pem

# Add the PEM file to the trust store
sudo update-ca-certificates
```

You should see the following output when the dev container is created:

``` text
Running the onCreateCommand from devcontainer.json...

The HTTPS developer certificate was generated successfully.
Updating certificates in /etc/ssl/certs...
rehash: warning: skipping ca-certificates.crt,it does not contain exactly one certificate or CRL
1 added, 0 removed; done.
Running hooks in /etc/ca-certificates/update.d...
done.
```

Now this certificate will survive container rebuilds. The certificate will also be trusted by code running inside the container like `System.Net.HttpClient`, or tools like `wget` and `curl`. If needed, you can use Docker Desktop to export the development certificate to a local directory, in case you need to add it to any other trust stores.

### Enabling HTTPS in ASP.NET using your own dev certificate

You can mount an exported copy of your local dev certificate for enhanced convenience. This solution is ideal for private projects, but please note that the password will be included in your `devcontainer.json`. Avoid using this method for team projects or open source projects to maintain security best practices.

1. Export the local certificate using the following command:

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
