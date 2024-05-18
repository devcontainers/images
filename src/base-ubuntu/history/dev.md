# [base-ubuntu](https://github.com/devcontainers/images/tree/main/src/base-ubuntu)

**Image version:** dev

**Source release/branch:** [main](https://github.com/devcontainers/images/tree/main/src/base-ubuntu)

**Image variations:**
- [noble](#variant-noble)
- [jammy](#variant-jammy)
- [focal](#variant-focal)

## Variant: noble

**Digest:** sha256:d7365af66b1bd8f6d11c2fb7933738ced668fae48c09f5932a440dc448c4c2ce

**Tags:**
```
mcr.microsoft.com/devcontainers/base:dev-noble
mcr.microsoft.com/devcontainers/base:dev-ubuntu-24.04
mcr.microsoft.com/devcontainers/base:dev-ubuntu24.04
```
> *To keep up to date, we recommend using partial version numbers. Use the major version number to get all non-breaking changes (e.g. `0-`) or major and minor to only get fixes (e.g. `0.200-`).*

**Linux distribution:** Ubuntu 24.04 LTS (debian-like distro)

**Architectures:** linux/amd64, linux/arm64

**Available (non-root) user:** ubuntu

### Contents
**Tools installed using git**

| Tool | Commit | Path |
|------|--------|------|
| [Oh My Zsh!](https://github.com/ohmyzsh/ohmyzsh) | b0561d28b5a3efbbcca4700626fa32e62c23959b | /home/vscode/.oh-my-zsh |

**Other tools and utilities**

| Tool | Version | Path |
|------|---------|------|
| [git](https://github.com/git/git) | 2.45.0 | 

**Additional linux tools and packages**

| Tool / library | Version |
|----------------|---------|
| apt-transport-https | 2.7.14build2 |
| apt-utils | 2.7.14build2 |
| ca-certificates | 20240203 |
| curl | 8.5.0-2ubuntu10.1 |
| dialog | 1.3-20240101-1 |
| git | 1:2.43.0-1ubuntu7 |
| gnupg2 | 2.4.4-2ubuntu17 |
| htop | 3.3.0-4build1 |
| iproute2 | 6.1.0-1ubuntu6 |
| jq | 1.7.1-3build1 |
| less | 590-2ubuntu2.1 |
| libc6 | 2.39-0ubuntu8.1 |
| libgssapi-krb5-2 | 1.20.1-6ubuntu2 |
| libicu74 | 74.2-1ubuntu3 |
| libkrb5-3 | 1.20.1-6ubuntu2 |
| libstdc++6 | 14-20240412-0ubuntu1 |
| locales | 2.39-0ubuntu8.1 |
| lsb-release | 12.0-2 |
| lsof | 4.95.0-1build3 |
| man-db | 2.12.0-4build2 |
| manpages | 6.7-2 |
| manpages-dev | 6.7-2 |
| nano | 7.2-2build1 |
| ncdu | 1.19-0.1 |
| net-tools | 2.10-0.1ubuntu4 |
| openssh-client | 1:9.6p1-3ubuntu13 |
| procps | 2:4.0.4-4ubuntu3 |
| psmisc | 23.7-1build1 |
| rsync | 3.2.7-1ubuntu1 |
| strace | 6.8-0ubuntu2 |
| sudo | 1.9.15p5-3ubuntu5 |
| unzip | 6.0-28ubuntu4 |
| vim-tiny | 2:9.1.0016-1ubuntu7 |
| wget | 1.21.4-1ubuntu4 |
| zip | 3.0-13build1 |
| zlib1g | 1:1.3.dfsg-3.1ubuntu2 |
| zsh | 5.9-6ubuntu2 |

## Variant: jammy

**Digest:** sha256:821f0d6be0eb29c727ad63577ba7782d5c0cd111200568f3e31b11e083c3649c

**Tags:**
```
mcr.microsoft.com/devcontainers/base:dev-jammy
mcr.microsoft.com/devcontainers/base:dev-ubuntu-22.04
mcr.microsoft.com/devcontainers/base:dev-ubuntu22.04
mcr.microsoft.com/devcontainers/base:dev-ubuntu
```
> *To keep up to date, we recommend using partial version numbers. Use the major version number to get all non-breaking changes (e.g. `0-`) or major and minor to only get fixes (e.g. `0.200-`).*

**Linux distribution:** Ubuntu 22.04.4 LTS (debian-like distro)

**Architectures:** linux/amd64, linux/arm64

**Available (non-root) user:** vscode

### Contents
**Tools installed using git**

| Tool | Commit | Path |
|------|--------|------|
| [Oh My Zsh!](https://github.com/ohmyzsh/ohmyzsh) | b0561d28b5a3efbbcca4700626fa32e62c23959b | /home/vscode/.oh-my-zsh |

**Other tools and utilities**

| Tool | Version | Path |
|------|---------|------|
| [git](https://github.com/git/git) | 2.45.0 | 

**Additional linux tools and packages**

| Tool / library | Version |
|----------------|---------|
| apt-transport-https | 2.4.12 |
| apt-utils | 2.4.12 |
| ca-certificates | 20230311ubuntu0.22.04.1 |
| curl | 7.81.0-1ubuntu1.16 |
| dialog | 1.3-20211214-1 |
| git | 1:2.34.1-1ubuntu1.10 |
| gnupg2 | 2.2.27-3ubuntu2.1 |
| htop | 3.0.5-7build2 |
| iproute2 | 5.15.0-1ubuntu2 |
| jq | 1.6-2.1ubuntu3 |
| less | 590-1ubuntu0.22.04.3 |
| libc6 | 2.35-0ubuntu3.7 |
| libgssapi-krb5-2 | 1.19.2-2ubuntu0.3 |
| libicu70 | 70.1-2 |
| libkrb5-3 | 1.19.2-2ubuntu0.3 |
| liblttng-ust1 | 2.13.1-1ubuntu1 |
| libstdc++6 | 12.3.0-1ubuntu1~22.04 |
| locales | 2.35-0ubuntu3.7 |
| lsb-release | 11.1.0ubuntu4 |
| lsof | 4.93.2+dfsg-1.1build2 |
| man-db | 2.10.2-1 |
| manpages | 5.10-1ubuntu1 |
| manpages-dev | 5.10-1ubuntu1 |
| nano | 6.2-1 |
| ncdu | 1.15.1-1 |
| net-tools | 1.60+git20181103.0eebece-1ubuntu5 |
| openssh-client | 1:8.9p1-3ubuntu0.7 |
| procps | 2:3.3.17-6ubuntu2.1 |
| psmisc | 23.4-2build3 |
| rsync | 3.2.7-0ubuntu0.22.04.2 |
| strace | 5.16-0ubuntu3 |
| sudo | 1.9.9-1ubuntu2.4 |
| unzip | 6.0-26ubuntu3.2 |
| vim-tiny | 2:8.2.3995-1ubuntu2.16 |
| wget | 1.21.2-2ubuntu1 |
| zip | 3.0-12build2 |
| zlib1g | 1:1.2.11.dfsg-2ubuntu9.2 |
| zsh | 5.8.1-1 |

## Variant: focal

**Digest:** sha256:d75f4c880fd4f19e7d4bba0ec1d883ff6016389b26bc4d4399b8a611290a3109

**Tags:**
```
mcr.microsoft.com/devcontainers/base:dev-focal
mcr.microsoft.com/devcontainers/base:dev-ubuntu-20.04
mcr.microsoft.com/devcontainers/base:dev-ubuntu20.04
```
> *To keep up to date, we recommend using partial version numbers. Use the major version number to get all non-breaking changes (e.g. `0-`) or major and minor to only get fixes (e.g. `0.200-`).*

**Linux distribution:** Ubuntu 20.04.6 LTS (debian-like distro)

**Architectures:** linux/amd64

**Available (non-root) user:** vscode

### Contents
**Tools installed using git**

| Tool | Commit | Path |
|------|--------|------|
| [Oh My Zsh!](https://github.com/ohmyzsh/ohmyzsh) | b0561d28b5a3efbbcca4700626fa32e62c23959b | /home/vscode/.oh-my-zsh |

**Other tools and utilities**

| Tool | Version | Path |
|------|---------|------|
| [git](https://github.com/git/git) | 2.45.0 | 

**Additional linux tools and packages**

| Tool / library | Version |
|----------------|---------|
| apt-transport-https | 2.0.10 |
| apt-utils | 2.0.10 |
| ca-certificates | 20230311ubuntu0.20.04.1 |
| curl | 7.68.0-1ubuntu2.22 |
| dialog | 1.3-20190808-1 |
| git | 1:2.25.1-1ubuntu3.11 |
| gnupg2 | 2.2.19-3ubuntu2.2 |
| htop | 2.2.0-2build1 |
| iproute2 | 5.5.0-1ubuntu1 |
| jq | 1.6-1ubuntu0.20.04.1 |
| less | 551-1ubuntu0.3 |
| libc6 | 2.31-0ubuntu9.15 |
| libgcc1 | 1:10.5.0-1ubuntu1~20.04 |
| libgssapi-krb5-2 | 1.17-6ubuntu4.4 |
| libicu66 | 66.1-2ubuntu2.1 |
| libkrb5-3 | 1.17-6ubuntu4.4 |
| liblttng-ust0 | 2.11.0-1 |
| libssl1.1 | 1.1.1f-1ubuntu2.22 |
| libstdc++6 | 10.5.0-1ubuntu1~20.04 |
| locales | 2.31-0ubuntu9.15 |
| lsb-release | 11.1.0ubuntu2 |
| lsof | 4.93.2+dfsg-1ubuntu0.20.04.1 |
| man-db | 2.9.1-1 |
| manpages | 5.05-1 |
| manpages-dev | 5.05-1 |
| nano | 4.8-1ubuntu1 |
| ncdu | 1.14.1-1 |
| net-tools | 1.60+git20180626.aebd88e-1ubuntu1 |
| openssh-client | 1:8.2p1-4ubuntu0.11 |
| procps | 2:3.3.16-1ubuntu2.4 |
| psmisc | 23.3-1 |
| rsync | 3.1.3-8ubuntu0.7 |
| strace | 5.5-3ubuntu1 |
| sudo | 1.8.31-1ubuntu1.5 |
| unzip | 6.0-25ubuntu1.2 |
| vim-tiny | 2:8.1.2269-1ubuntu5.22 |
| wget | 1.20.3-1ubuntu2 |
| zip | 3.0-11build1 |
| zlib1g | 1:1.2.11.dfsg-2ubuntu1.5 |
| zsh | 5.8-3ubuntu1.1 |

