# Linux Universal Image

## Summary

*Use or extend the new Ubuntu-based default, large, and multi-language universal image which contains many popular languages/frameworks/SDKS/runtimes*

| Metadata | Value |  
|----------|-------|
| *Categories* | Services, GitHub |
| *Image type* | Dockerfile |
| *Published image* | mcr.microsoft.com/devcontainers/universal:linux<br />mcr.microsoft.com/devcontainers/universal:focal |
| *Published image architecture(s)* | x86-64 |
| *Container host OS support* | Linux, macOS, Windows |
| *Container OS* | Ubuntu |
| *Languages, platforms* | Python, Node.js, JavaScript, TypeScript, C++, Java, C#, F#, .NET Core, PHP, Go, Ruby, Conda |

See **[history](history)** for information on the contents of published images.

## Description

While language specific development containers can be useful, in some cases you may want to use more than one in a project without having to set them all up. In other cases you may be looking to create a general "sandbox" container you intend to use with multiple projects or repositories. The large container image generated here (`mcr.microsoft.com/devcontainers/universal:linux`) includes a number of runtime versions for popular languages like Python, Node, PHP, Java, Go, C++, Ruby, and .NET Core/C#.

If you use GitHub Codespaces, this is the "universal" image that is used by default if no custom Dockerfile or image is specified. If you like what you see but want to make a few additions or changes, you can use a custom Dockerfile to extend it and add whatever you need.

The container includes the `zsh` (and Oh My Zsh!) and `fish` shells that you can opt into using instead of the default `bash`. It also includes [nvm](https://github.com/nvm-sh/nvm), [rvm](https://rvm.io/), [rbenv](https://github.com/rbenv/rbenv), and [SDKMAN!](https://sdkman.io/) if you need to install a different version Node, Ruby, or Java tools than the container defaults. You can also set things up to access the container [via SSH](#accessing-the-container-using-ssh-scp-or-sshfs).

You can decide how often you want updates by referencing a [semantic version](https://semver.org/) of each image.
For example:

- `mcr.microsoft.com/devcontainers/universal:2-focal`
- `mcr.microsoft.com/devcontainers/universal:2.0-focal`
- `mcr.microsoft.com/devcontainers/universal:2.0.6-focal`

See [history](history) for information on the contents of each version and [here for a complete list of available tags](https://mcr.microsoft.com/v2/devcontainers/universal/tags/list).

## Accessing the container using SSH, or SSHFS

This container also includes a running SSH server that you can use to access the contents if needed. To use it, refer to the [SSHD Feature](https://github.com/devcontainers/features/tree/main/src/sshd#usage) for instructions.


## Using Conda
This dev container and its associated image includes [the `conda` package manager](https://aka.ms/vscode-remote/conda/about). Additional packages installed using Conda will be downloaded from Anaconda or another repository if you configure one. To reconfigure Conda in this container to access an alternative repository, please see information on [configuring Conda channels here](https://aka.ms/vscode-remote/conda/channel-setup).

Access to the Anaconda repository is covered by the [Anaconda Terms of Service](https://aka.ms/vscode-remote/conda/terms), which may require some organizations to obtain a commercial license from Anaconda. **However**, when this dev container or its associated image is used with GitHub Codespaces or GitHub Actions, **all users are permitted** to use the Anaconda Repository through the service, including organizations normally required by Anaconda to obtain a paid license for commercial activities. Note that third-party packages may be licensed by their publishers in ways that impact your intellectual property, and are used at your own risk.

## Using this image

While the image itself works unmodified, you can also directly reference pre-built versions of `Dockerfile` by using the `image` property in `.devcontainer/devcontainer.json` or updating the `FROM` statement in your own `Dockerfile` to:

`mcr.microsoft.com/devcontainers/universal:2-linux`

Alternatively, you can use the contents of [.devcontainer](.devcontainer) to fully customize your container's contents or to build it for a container host architecture not supported by the image.

Refer to [this guide](https://containers.dev/guide/dockerfile) for more details.

## Disabling Automatic Setup in Codespaces

Codespaces will automatically perform some default setup when the `universal` image is used and no `postCreateCommand` is provided. This can be disabled with the `customizations.codespaces.disableAutomaticConfiguration` setting:

```jsonc
"customizations": {
	// Configure properties specific to Codespaces.
	"codespaces": {
		"disableAutomaticConfiguration": true
	}
}
```

## License

Copyright (c) Microsoft Corporation. All rights reserved.

Licensed under the MIT License. See [LICENSE](https://github.com/devcontainers/images/blob/main/LICENSE).

