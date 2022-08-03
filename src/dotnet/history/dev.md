# [dotnet](https://github.com/devcontainers/images/tree/main/src/dotnet)

**Image version:** dev

**Source release/branch:** [main](https://github.com/devcontainers/images/tree/main/src/dotnet)

**Image variations:**
- [6.0-bullseye-slim](#variant-60-bullseye-slim)
- [6.0-focal](#variant-60-focal)
- [5.0-bullseye-slim](#variant-50-bullseye-slim)
- [5.0-focal](#variant-50-focal)
- [3.1-bullseye](#variant-31-bullseye)
- [3.1-focal](#variant-31-focal)

## Variant: 6.0-bullseye-slim

**Digest:** sha256:23a24b030a5243a4e7599f2a77b02d6bbeccbcb5f9c24e7a54acced6fa5b87a4

**Tags:**
```
mcr.microsoft.com/devcontainers/dotnet:dev-6.0-bullseye-slim
mcr.microsoft.com/devcontainers/dotnet:dev-6.0
mcr.microsoft.com/devcontainers/dotnet:dev-6.0-bullseye
```
> *To keep up to date, we recommend using partial version numbers. Use the major version number to get all non-breaking changes (e.g. `0-`) or major and minor to only get fixes (e.g. `0.200-`).*

**Linux distribution:** Debian GNU/Linux 11 (bullseye)

**Architectures:** linux/amd64, linux/arm64

**Available (non-root) user:** vscode

### Contents
**Languages and runtimes**

| Language / runtime | Version | Path |
|--------------------|---------|------|
| [.NET](https://dotnet.microsoft.com/) | 6.0.302 (6.0.7) | /usr |

**Tools installed using git**

| Tool | Commit | Path |
|------|--------|------|
| [Oh My Zsh!](https://github.com/ohmyzsh/ohmyzsh) | 97134d1eed19b72a9c4bf90a2effa847221608bf | /home/vscode/.oh-my-zsh |
| [nvm](https://github.com/nvm-sh/nvm.git) | 3fea5493a431ac64470d4230d4b51438cf213bd1 | /usr/local/share/nvm |

**Additional linux tools and packages**

| Tool / library | Version |
|----------------|---------|
| apt-transport-https | 2.2.4 |
| apt-utils | 2.2.4 |
| ca-certificates | 20210119 |
| curl | 7.74.0-1.3+deb11u2 |
| dialog | 1.3-20201126-1 |
| git | 1:2.30.2-1 |
| gnupg2 | 2.2.27-2+deb11u2 |
| htop | 3.0.5-7 |
| iproute2 | 5.10.0-4 |
| jq | 1.6-2.1 |
| less | 551-2 |
| libc6 | 2.31-13+deb11u3 |
| libgssapi-krb5-2 | 1.18.3-6+deb11u1 |
| libicu67 | 67.1-7 |
| libkrb5-3 | 1.18.3-6+deb11u1 |
| liblttng-ust0 | 2.12.1-1 |
| libssl1.1 | 1.1.1n-0+deb11u3 |
| libstdc++6 | 10.2.1-6 |
| locales | 2.31-13+deb11u3 |
| lsb-release | 11.1.0 |
| lsof | 4.93.2+dfsg-1.1 |
| man-db | 2.9.4-2 |
| manpages | 5.10-1 |
| manpages-dev | 5.10-1 |
| nano | 5.4-2+deb11u1 |
| ncdu | 1.15.1-1 |
| net-tools | 1.60+git20181103.0eebece-1 |
| openssh-client | 1:8.4p1-5+deb11u1 |
| procps | 2:3.3.17-5 |
| psmisc | 23.4-2 |
| rsync | 3.2.3-4+deb11u1 |
| strace | 5.10-1 |
| sudo | 1.9.5p2-3 |
| unzip | 6.0-26 |
| vim-tiny | 2:8.2.2434-3+deb11u1 |
| wget | 1.21-1+deb11u1 |
| yarn | 1.22.19-1 |
| zip | 3.0-12 |
| zlib1g | 1:1.2.11.dfsg-2+deb11u1 |
| zsh | 5.8-6+deb11u1 |

## Variant: 6.0-focal

**Digest:** sha256:af98a50d7ea5f276f9375a127efb735c7eff1170c0840422b4683f2be02f14d1

**Tags:**
```
mcr.microsoft.com/devcontainers/dotnet:dev-6.0-focal
```
> *To keep up to date, we recommend using partial version numbers. Use the major version number to get all non-breaking changes (e.g. `0-`) or major and minor to only get fixes (e.g. `0.200-`).*

**Linux distribution:** Ubuntu 20.04.4 LTS (debian-like distro)

**Architectures:** linux/amd64

**Available (non-root) user:** vscode

### Contents
**Languages and runtimes**

| Language / runtime | Version | Path |
|--------------------|---------|------|
| [.NET](https://dotnet.microsoft.com/) | 6.0.302 (6.0.7) | /usr |

**Tools installed using git**

| Tool | Commit | Path |
|------|--------|------|
| [Oh My Zsh!](https://github.com/ohmyzsh/ohmyzsh) | 97134d1eed19b72a9c4bf90a2effa847221608bf | /home/vscode/.oh-my-zsh |
| [nvm](https://github.com/nvm-sh/nvm.git) | 3fea5493a431ac64470d4230d4b51438cf213bd1 | /usr/local/share/nvm |

**Additional linux tools and packages**

| Tool / library | Version |
|----------------|---------|
| apt-transport-https | 2.0.9 |
| apt-utils | 2.0.9 |
| ca-certificates | 20211016~20.04.1 |
| curl | 7.68.0-1ubuntu2.12 |
| dialog | 1.3-20190808-1 |
| git | 1:2.25.1-1ubuntu3.5 |
| gnupg2 | 2.2.19-3ubuntu2.2 |
| htop | 2.2.0-2build1 |
| iproute2 | 5.5.0-1ubuntu1 |
| jq | 1.6-1ubuntu0.20.04.1 |
| less | 551-1ubuntu0.1 |
| libc6 | 2.31-0ubuntu9.9 |
| libgcc1 | 1:10.3.0-1ubuntu1~20.04 |
| libgssapi-krb5-2 | 1.17-6ubuntu4.1 |
| libicu66 | 66.1-2ubuntu2.1 |
| libkrb5-3 | 1.17-6ubuntu4.1 |
| liblttng-ust0 | 2.11.0-1 |
| libssl1.1 | 1.1.1f-1ubuntu2.16 |
| libstdc++6 | 10.3.0-1ubuntu1~20.04 |
| locales | 2.31-0ubuntu9.9 |
| lsb-release | 11.1.0ubuntu2 |
| lsof | 4.93.2+dfsg-1ubuntu0.20.04.1 |
| man-db | 2.9.1-1 |
| manpages | 5.05-1 |
| manpages-dev | 5.05-1 |
| nano | 4.8-1ubuntu1 |
| ncdu | 1.14.1-1 |
| net-tools | 1.60+git20180626.aebd88e-1ubuntu1 |
| openssh-client | 1:8.2p1-4ubuntu0.5 |
| procps | 2:3.3.16-1ubuntu2.3 |
| psmisc | 23.3-1 |
| rsync | 3.1.3-8ubuntu0.3 |
| strace | 5.5-3ubuntu1 |
| sudo | 1.8.31-1ubuntu1.2 |
| unzip | 6.0-25ubuntu1 |
| vim-tiny | 2:8.1.2269-1ubuntu5.7 |
| wget | 1.20.3-1ubuntu2 |
| yarn | 1.22.19-1 |
| zip | 3.0-11build1 |
| zlib1g | 1:1.2.11.dfsg-2ubuntu1.3 |
| zsh | 5.8-3ubuntu1.1 |

## Variant: 5.0-bullseye-slim

**Digest:** sha256:7324a63c0af8d0b9473571d853b888f825c816c74f57f181a73aa536e2c7b988

**Tags:**
```
mcr.microsoft.com/devcontainers/dotnet:dev-5.0-bullseye-slim
mcr.microsoft.com/devcontainers/dotnet:dev-5.0-bullseye
mcr.microsoft.com/devcontainers/dotnetcore:dev-5.0-bullseye
```
> *To keep up to date, we recommend using partial version numbers. Use the major version number to get all non-breaking changes (e.g. `0-`) or major and minor to only get fixes (e.g. `0.200-`).*

**Linux distribution:** Debian GNU/Linux 11 (bullseye)

**Architectures:** linux/amd64, linux/arm64

**Available (non-root) user:** vscode

### Contents
**Languages and runtimes**

| Language / runtime | Version | Path |
|--------------------|---------|------|
| [.NET](https://dotnet.microsoft.com/) | 5.0.408 (5.0.1) | /usr |

**Tools installed using git**

| Tool | Commit | Path |
|------|--------|------|
| [Oh My Zsh!](https://github.com/ohmyzsh/ohmyzsh) | 97134d1eed19b72a9c4bf90a2effa847221608bf | /home/vscode/.oh-my-zsh |
| [nvm](https://github.com/nvm-sh/nvm.git) | 3fea5493a431ac64470d4230d4b51438cf213bd1 | /usr/local/share/nvm |

**Additional linux tools and packages**

| Tool / library | Version |
|----------------|---------|
| apt-transport-https | 2.2.4 |
| apt-utils | 2.2.4 |
| ca-certificates | 20210119 |
| curl | 7.74.0-1.3+deb11u2 |
| dialog | 1.3-20201126-1 |
| git | 1:2.30.2-1 |
| gnupg2 | 2.2.27-2+deb11u2 |
| htop | 3.0.5-7 |
| iproute2 | 5.10.0-4 |
| jq | 1.6-2.1 |
| less | 551-2 |
| libc6 | 2.31-13+deb11u3 |
| libgssapi-krb5-2 | 1.18.3-6+deb11u1 |
| libicu67 | 67.1-7 |
| libkrb5-3 | 1.18.3-6+deb11u1 |
| liblttng-ust0 | 2.12.1-1 |
| libssl1.1 | 1.1.1n-0+deb11u3 |
| libstdc++6 | 10.2.1-6 |
| locales | 2.31-13+deb11u3 |
| lsb-release | 11.1.0 |
| lsof | 4.93.2+dfsg-1.1 |
| man-db | 2.9.4-2 |
| manpages | 5.10-1 |
| manpages-dev | 5.10-1 |
| nano | 5.4-2+deb11u1 |
| ncdu | 1.15.1-1 |
| net-tools | 1.60+git20181103.0eebece-1 |
| openssh-client | 1:8.4p1-5+deb11u1 |
| procps | 2:3.3.17-5 |
| psmisc | 23.4-2 |
| rsync | 3.2.3-4+deb11u1 |
| strace | 5.10-1 |
| sudo | 1.9.5p2-3 |
| unzip | 6.0-26 |
| vim-tiny | 2:8.2.2434-3+deb11u1 |
| wget | 1.21-1+deb11u1 |
| yarn | 1.22.19-1 |
| zip | 3.0-12 |
| zlib1g | 1:1.2.11.dfsg-2+deb11u1 |
| zsh | 5.8-6+deb11u1 |

## Variant: 5.0-focal

**Digest:** sha256:ef54a48f38019276956826f71a3c22ba88632749f4cd5d93f05eca5118853949

**Tags:**
```
mcr.microsoft.com/devcontainers/dotnet:dev-5.0-focal
mcr.microsoft.com/devcontainers/dotnet:dev-5.0
mcr.microsoft.com/devcontainers/dotnetcore:dev-5.0
```
> *To keep up to date, we recommend using partial version numbers. Use the major version number to get all non-breaking changes (e.g. `0-`) or major and minor to only get fixes (e.g. `0.200-`).*

**Linux distribution:** Ubuntu 20.04.4 LTS (debian-like distro)

**Architectures:** linux/amd64

**Available (non-root) user:** vscode

### Contents
**Languages and runtimes**

| Language / runtime | Version | Path |
|--------------------|---------|------|
| [.NET](https://dotnet.microsoft.com/) | 5.0.408 (5.0.1) | /usr |

**Tools installed using git**

| Tool | Commit | Path |
|------|--------|------|
| [Oh My Zsh!](https://github.com/ohmyzsh/ohmyzsh) | 97134d1eed19b72a9c4bf90a2effa847221608bf | /home/vscode/.oh-my-zsh |
| [nvm](https://github.com/nvm-sh/nvm.git) | 3fea5493a431ac64470d4230d4b51438cf213bd1 | /usr/local/share/nvm |

**Additional linux tools and packages**

| Tool / library | Version |
|----------------|---------|
| apt-transport-https | 2.0.9 |
| apt-utils | 2.0.9 |
| ca-certificates | 20211016~20.04.1 |
| curl | 7.68.0-1ubuntu2.12 |
| dialog | 1.3-20190808-1 |
| git | 1:2.25.1-1ubuntu3.5 |
| gnupg2 | 2.2.19-3ubuntu2.2 |
| htop | 2.2.0-2build1 |
| iproute2 | 5.5.0-1ubuntu1 |
| jq | 1.6-1ubuntu0.20.04.1 |
| less | 551-1ubuntu0.1 |
| libc6 | 2.31-0ubuntu9.9 |
| libgcc1 | 1:10.3.0-1ubuntu1~20.04 |
| libgssapi-krb5-2 | 1.17-6ubuntu4.1 |
| libicu66 | 66.1-2ubuntu2.1 |
| libkrb5-3 | 1.17-6ubuntu4.1 |
| liblttng-ust0 | 2.11.0-1 |
| libssl1.1 | 1.1.1f-1ubuntu2.16 |
| libstdc++6 | 10.3.0-1ubuntu1~20.04 |
| locales | 2.31-0ubuntu9.9 |
| lsb-release | 11.1.0ubuntu2 |
| lsof | 4.93.2+dfsg-1ubuntu0.20.04.1 |
| man-db | 2.9.1-1 |
| manpages | 5.05-1 |
| manpages-dev | 5.05-1 |
| nano | 4.8-1ubuntu1 |
| ncdu | 1.14.1-1 |
| net-tools | 1.60+git20180626.aebd88e-1ubuntu1 |
| openssh-client | 1:8.2p1-4ubuntu0.5 |
| procps | 2:3.3.16-1ubuntu2.3 |
| psmisc | 23.3-1 |
| rsync | 3.1.3-8ubuntu0.3 |
| strace | 5.5-3ubuntu1 |
| sudo | 1.8.31-1ubuntu1.2 |
| unzip | 6.0-25ubuntu1 |
| vim-tiny | 2:8.1.2269-1ubuntu5.7 |
| wget | 1.20.3-1ubuntu2 |
| yarn | 1.22.19-1 |
| zip | 3.0-11build1 |
| zlib1g | 1:1.2.11.dfsg-2ubuntu1.3 |
| zsh | 5.8-3ubuntu1.1 |

## Variant: 3.1-bullseye

**Digest:** sha256:c72e8acb6acff81bd10b7f7791ef9c35d475c8b2be0143773d47e92bf98a0563

**Tags:**
```
mcr.microsoft.com/devcontainers/dotnet:dev-3.1-bullseye
mcr.microsoft.com/devcontainers/dotnetcore:dev-3.1-bullseye
```
> *To keep up to date, we recommend using partial version numbers. Use the major version number to get all non-breaking changes (e.g. `0-`) or major and minor to only get fixes (e.g. `0.200-`).*

**Linux distribution:** Debian GNU/Linux 11 (bullseye)

**Architectures:** linux/amd64, linux/arm64

**Available (non-root) user:** vscode

### Contents
**Languages and runtimes**

| Language / runtime | Version | Path |
|--------------------|---------|------|
| [.NET](https://dotnet.microsoft.com/) | 3.1.421 (3.1.2) | /usr |

**Tools installed using git**

| Tool | Commit | Path |
|------|--------|------|
| [Oh My Zsh!](https://github.com/ohmyzsh/ohmyzsh) | 97134d1eed19b72a9c4bf90a2effa847221608bf | /home/vscode/.oh-my-zsh |
| [nvm](https://github.com/nvm-sh/nvm.git) | 3fea5493a431ac64470d4230d4b51438cf213bd1 | /usr/local/share/nvm |

**Additional linux tools and packages**

| Tool / library | Version |
|----------------|---------|
| apt-transport-https | 2.2.4 |
| apt-utils | 2.2.4 |
| ca-certificates | 20210119 |
| curl | 7.74.0-1.3+deb11u2 |
| dialog | 1.3-20201126-1 |
| git | 1:2.30.2-1 |
| gnupg2 | 2.2.27-2+deb11u2 |
| htop | 3.0.5-7 |
| iproute2 | 5.10.0-4 |
| jq | 1.6-2.1 |
| less | 551-2 |
| libc6 | 2.31-13+deb11u3 |
| libgssapi-krb5-2 | 1.18.3-6+deb11u1 |
| libicu67 | 67.1-7 |
| libkrb5-3 | 1.18.3-6+deb11u1 |
| liblttng-ust0 | 2.12.1-1 |
| libssl1.1 | 1.1.1n-0+deb11u3 |
| libstdc++6 | 10.2.1-6 |
| locales | 2.31-13+deb11u3 |
| lsb-release | 11.1.0 |
| lsof | 4.93.2+dfsg-1.1 |
| man-db | 2.9.4-2 |
| manpages | 5.10-1 |
| manpages-dev | 5.10-1 |
| nano | 5.4-2+deb11u1 |
| ncdu | 1.15.1-1 |
| net-tools | 1.60+git20181103.0eebece-1 |
| openssh-client | 1:8.4p1-5+deb11u1 |
| procps | 2:3.3.17-5 |
| psmisc | 23.4-2 |
| rsync | 3.2.3-4+deb11u1 |
| strace | 5.10-1 |
| sudo | 1.9.5p2-3 |
| unzip | 6.0-26 |
| vim-tiny | 2:8.2.2434-3+deb11u1 |
| wget | 1.21-1+deb11u1 |
| yarn | 1.22.19-1 |
| zip | 3.0-12 |
| zlib1g | 1:1.2.11.dfsg-2+deb11u1 |
| zsh | 5.8-6+deb11u1 |

## Variant: 3.1-focal

**Digest:** sha256:f95ba427dcaca7b2d20bd0f0f491d2e5dc37d6bf582df75f589cf1675a2d6780

**Tags:**
```
mcr.microsoft.com/devcontainers/dotnet:dev-3.1-focal
mcr.microsoft.com/devcontainers/dotnet:dev-3.1
mcr.microsoft.com/devcontainers/dotnetcore:dev-3.1
```
> *To keep up to date, we recommend using partial version numbers. Use the major version number to get all non-breaking changes (e.g. `0-`) or major and minor to only get fixes (e.g. `0.200-`).*

**Linux distribution:** Ubuntu 20.04.4 LTS (debian-like distro)

**Architectures:** linux/amd64

**Available (non-root) user:** vscode

### Contents
**Languages and runtimes**

| Language / runtime | Version | Path |
|--------------------|---------|------|
| [.NET](https://dotnet.microsoft.com/) | 3.1.421 (3.1.2) | /usr |

**Tools installed using git**

| Tool | Commit | Path |
|------|--------|------|
| [Oh My Zsh!](https://github.com/ohmyzsh/ohmyzsh) | 97134d1eed19b72a9c4bf90a2effa847221608bf | /home/vscode/.oh-my-zsh |
| [nvm](https://github.com/nvm-sh/nvm.git) | 3fea5493a431ac64470d4230d4b51438cf213bd1 | /usr/local/share/nvm |

**Additional linux tools and packages**

| Tool / library | Version |
|----------------|---------|
| apt-transport-https | 2.0.9 |
| apt-utils | 2.0.9 |
| ca-certificates | 20211016~20.04.1 |
| curl | 7.68.0-1ubuntu2.12 |
| dialog | 1.3-20190808-1 |
| git | 1:2.25.1-1ubuntu3.5 |
| gnupg2 | 2.2.19-3ubuntu2.2 |
| htop | 2.2.0-2build1 |
| iproute2 | 5.5.0-1ubuntu1 |
| jq | 1.6-1ubuntu0.20.04.1 |
| less | 551-1ubuntu0.1 |
| libc6 | 2.31-0ubuntu9.9 |
| libgcc1 | 1:10.3.0-1ubuntu1~20.04 |
| libgssapi-krb5-2 | 1.17-6ubuntu4.1 |
| libicu66 | 66.1-2ubuntu2.1 |
| libkrb5-3 | 1.17-6ubuntu4.1 |
| liblttng-ust0 | 2.11.0-1 |
| libssl1.1 | 1.1.1f-1ubuntu2.16 |
| libstdc++6 | 10.3.0-1ubuntu1~20.04 |
| locales | 2.31-0ubuntu9.9 |
| lsb-release | 11.1.0ubuntu2 |
| lsof | 4.93.2+dfsg-1ubuntu0.20.04.1 |
| man-db | 2.9.1-1 |
| manpages | 5.05-1 |
| manpages-dev | 5.05-1 |
| nano | 4.8-1ubuntu1 |
| ncdu | 1.14.1-1 |
| net-tools | 1.60+git20180626.aebd88e-1ubuntu1 |
| openssh-client | 1:8.2p1-4ubuntu0.5 |
| procps | 2:3.3.16-1ubuntu2.3 |
| psmisc | 23.3-1 |
| rsync | 3.1.3-8ubuntu0.3 |
| strace | 5.5-3ubuntu1 |
| sudo | 1.8.31-1ubuntu1.2 |
| unzip | 6.0-25ubuntu1 |
| vim-tiny | 2:8.1.2269-1ubuntu5.7 |
| wget | 1.20.3-1ubuntu2 |
| yarn | 1.22.19-1 |
| zip | 3.0-11build1 |
| zlib1g | 1:1.2.11.dfsg-2ubuntu1.3 |
| zsh | 5.8-3ubuntu1.1 |

