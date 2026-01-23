# [cpp](https://github.com/devcontainers/images/tree/main/src/cpp)

**Image version:** dev

**Source release/branch:** [main](https://github.com/devcontainers/images/tree/main/src/cpp)

**Image variations:**
- [trixie](#variant-trixie)
- [bookworm](#variant-bookworm)
- [noble](#variant-noble)
- [jammy](#variant-jammy)

## Variant: trixie

**Digest:** sha256:4bc757297d22506a10db5079a31c52455cf62d94b57df5aaec2584b05051bece

**Tags:**
```
mcr.microsoft.com/devcontainers/cpp:dev-trixie
mcr.microsoft.com/devcontainers/cpp:dev-debian13
mcr.microsoft.com/devcontainers/cpp:dev-debian
mcr.microsoft.com/devcontainers/cpp:dev
```
> *To keep up to date, we recommend using partial version numbers. Use the major version number to get all non-breaking changes (e.g. `0-`) or major and minor to only get fixes (e.g. `0.200-`).*

**Linux distribution:** Debian GNU/Linux 13 (trixie)

**Architectures:** linux/amd64, linux/arm64

**Available (non-root) user:** vscode

### Contents
**Languages and runtimes**

| Language / runtime | Version | Path |
|--------------------|---------|------|
| GCC | 14.2.0-19 | 
| Clang | 19.1.7 (3+b1) | 

**Tools installed using git**

| Tool | Commit | Path |
|------|--------|------|
| [Oh My Zsh!](https://github.com/ohmyzsh/ohmyzsh) | e0766905519fbc7982a590a195ee7c3e8bb594e8 | /home/vscode/.oh-my-zsh |
| [vcpkg](https://github.com/microsoft/vcpkg) | 01e159b519b7e791cc5bb3548663a26d9c0922a3 | /usr/local/vcpkg |

**Other tools and utilities**

| Tool | Version | Path |
|------|---------|------|
| [git](https://github.com/git/git) | 2.52.0 | 

**Additional linux tools and packages**

| Tool / library | Version |
|----------------|---------|
| apt-transport-https | 3.0.3 |
| apt-utils | 3.0.3 |
| bash-completion | 1:2.16.0-7 |
| build-essential | 12.12 |
| ca-certificates | 20250419 |
| clang | 1:19.0-63 |
| cmake | 3.31.6-2 |
| cppcheck | 2.17.1-2 |
| curl | 8.14.1-2+deb13u2 |
| dialog | 1.3-20250116-1 |
| gdb | 16.3-1 |
| git | 1:2.47.3-0+deb13u1 |
| gnupg2 | 2.4.7-21+deb13u1 |
| htop | 3.4.1-5 |
| iproute2 | 6.15.0-1 |
| jq | 1.7.1-6+deb13u1 |
| less | 668-1 |
| libc6 | 2.41-12+deb13u1 |
| libgssapi-krb5-2 | 1.21.3-5 |
| libicu76 | 76.1-4 |
| libkrb5-3 | 1.21.3-5 |
| libstdc++6 | 14.2.0-19 |
| lldb | 1:19.0-63 |
| llvm | 1:19.0-63 |
| locales | 2.41-12+deb13u1 |
| lsb-release | 12.1-1 |
| lsof | 4.99.4+dfsg-2 |
| man-db | 2.13.1-1 |
| manpages | 6.9.1-1 |
| manpages-dev | 6.9.1-1 |
| nano | 8.4-1 |
| ncdu | 1.22-1 |
| net-tools | 2.10-1.3 |
| ninja-build | 1.12.1-1 |
| openssh-client | 1:10.0p1-7 |
| pkg-config | 1.8.1-4 |
| procps | 2:4.0.4-9 |
| psmisc | 23.7-2 |
| rsync | 3.4.1+ds1-5+deb13u1 |
| strace | 6.13+ds-1 |
| sudo | 1.9.16p2-3 |
| tar | 1.35+dfsg-3.1 |
| unzip | 6.0-29 |
| valgrind | 1:3.24.0-3 |
| vim-tiny | 2:9.1.1230-2 |
| wget | 1.25.0-2 |
| zip | 3.0-15 |
| zlib1g | 1:1.3.dfsg+really1.3.1-1+b1 |
| zsh | 5.9-8+b18 |

## Variant: bookworm

**Digest:** sha256:a038219fd769d526571f461257ea4be391a4d0f12bb2b502f77a9f4fdf50555c

**Tags:**
```
mcr.microsoft.com/devcontainers/cpp:dev-bookworm
mcr.microsoft.com/devcontainers/cpp:dev-debian12
```
> *To keep up to date, we recommend using partial version numbers. Use the major version number to get all non-breaking changes (e.g. `0-`) or major and minor to only get fixes (e.g. `0.200-`).*

**Linux distribution:** Debian GNU/Linux 12 (bookworm)

**Architectures:** linux/amd64, linux/arm64

**Available (non-root) user:** vscode

### Contents
**Languages and runtimes**

| Language / runtime | Version | Path |
|--------------------|---------|------|
| GCC | 12.2.0-14+deb12u1 | 
| Clang | 14.0.6 | 

**Tools installed using git**

| Tool | Commit | Path |
|------|--------|------|
| [Oh My Zsh!](https://github.com/ohmyzsh/ohmyzsh) | e0766905519fbc7982a590a195ee7c3e8bb594e8 | /home/vscode/.oh-my-zsh |
| [vcpkg](https://github.com/microsoft/vcpkg) | 01e159b519b7e791cc5bb3548663a26d9c0922a3 | /usr/local/vcpkg |

**Other tools and utilities**

| Tool | Version | Path |
|------|---------|------|
| [git](https://github.com/git/git) | 2.52.0 | 

**Additional linux tools and packages**

| Tool / library | Version |
|----------------|---------|
| apt-transport-https | 2.6.1 |
| apt-utils | 2.6.1 |
| bash-completion | 1:2.11-6 |
| build-essential | 12.9 |
| ca-certificates | 20230311+deb12u1 |
| clang | 1:14.0-55.7~deb12u1 |
| cmake | 3.25.1-1 |
| cppcheck | 2.10-2 |
| curl | 7.88.1-10+deb12u14 |
| dialog | 1.3-20230209-1 |
| gdb | 13.1-3 |
| git | 1:2.39.5-0+deb12u3 |
| gnupg2 | 2.2.40-1.1+deb12u2 |
| htop | 3.2.2-2 |
| iproute2 | 6.1.0-3 |
| jq | 1.6-2.1+deb12u1 |
| less | 590-2.1~deb12u2 |
| libc6 | 2.36-9+deb12u13 |
| libgssapi-krb5-2 | 1.20.1-2+deb12u4 |
| libicu72 | 72.1-3+deb12u1 |
| libkrb5-3 | 1.20.1-2+deb12u4 |
| liblttng-ust1 | 2.13.5-1 |
| libstdc++6 | 12.2.0-14+deb12u1 |
| lldb | 1:14.0-55.7~deb12u1 |
| llvm | 1:14.0-55.7~deb12u1 |
| locales | 2.36-9+deb12u13 |
| lsb-release | 12.0-1 |
| lsof | 4.95.0-1 |
| man-db | 2.11.2-2 |
| manpages | 6.03-2 |
| manpages-dev | 6.03-2 |
| nano | 7.2-1+deb12u1 |
| ncdu | 1.18-0.2 |
| net-tools | 2.10-0.1+deb12u2 |
| ninja-build | 1.11.1-2~deb12u1 |
| openssh-client | 1:9.2p1-2+deb12u7 |
| pkg-config | 1.8.1-1 |
| procps | 2:4.0.2-3 |
| psmisc | 23.6-1 |
| rsync | 3.2.7-1+deb12u4 |
| strace | 6.1-0.1 |
| sudo | 1.9.13p3-1+deb12u3 |
| tar | 1.34+dfsg-1.2+deb12u1 |
| unzip | 6.0-28 |
| valgrind | 1:3.19.0-1 |
| vim-tiny | 2:9.0.1378-2+deb12u2 |
| wget | 1.21.3-1+deb12u1 |
| zip | 3.0-13 |
| zlib1g | 1:1.2.13.dfsg-1 |
| zsh | 5.9-4+b8 |

## Variant: noble

**Digest:** sha256:045ea991ec50ff63be040541ee13da1e1e4ce3ebb7cf5c27aa530809655973e0

**Tags:**
```
mcr.microsoft.com/devcontainers/cpp:dev-noble
mcr.microsoft.com/devcontainers/cpp:dev-ubuntu24.04
mcr.microsoft.com/devcontainers/cpp:dev-ubuntu
```
> *To keep up to date, we recommend using partial version numbers. Use the major version number to get all non-breaking changes (e.g. `0-`) or major and minor to only get fixes (e.g. `0.200-`).*

**Linux distribution:** Ubuntu 24.04.3 LTS (debian-like distro)

**Architectures:** linux/amd64, linux/arm64

**Available (non-root) user:** vscode

### Contents
**Languages and runtimes**

| Language / runtime | Version | Path |
|--------------------|---------|------|
| GCC | 13.3.0-6ubuntu2~24.04 | 
| Clang | 18.1.3 (1ubuntu1) | 

**Tools installed using git**

| Tool | Commit | Path |
|------|--------|------|
| [Oh My Zsh!](https://github.com/ohmyzsh/ohmyzsh) | e0766905519fbc7982a590a195ee7c3e8bb594e8 | /home/vscode/.oh-my-zsh |
| [vcpkg](https://github.com/microsoft/vcpkg) | 3c4706f7aba0155cb34c366b5ef3397e75e0d14e | /usr/local/vcpkg |

**Other tools and utilities**

| Tool | Version | Path |
|------|---------|------|
| [git](https://github.com/git/git) | 2.52.0 | 

**Additional linux tools and packages**

| Tool / library | Version |
|----------------|---------|
| apt-transport-https | 2.8.3 |
| apt-utils | 2.8.3 |
| bash-completion | 1:2.11-8 |
| build-essential | 12.10ubuntu1 |
| ca-certificates | 20240203 |
| clang | 1:18.0-59~exp2 |
| cmake | 3.28.3-1build7 |
| cppcheck | 2.13.0-2ubuntu3 |
| curl | 8.5.0-2ubuntu10.6 |
| dialog | 1.3-20240101-1 |
| gdb | 15.0.50.20240403-0ubuntu1 |
| git | 1:2.43.0-1ubuntu7.3 |
| gnupg2 | 2.4.4-2ubuntu17.4 |
| htop | 3.3.0-4build1 |
| iproute2 | 6.1.0-1ubuntu6.2 |
| jq | 1.7.1-3ubuntu0.24.04.1 |
| less | 590-2ubuntu2.1 |
| libc6 | 2.39-0ubuntu8.6 |
| libgssapi-krb5-2 | 1.20.1-6ubuntu2.6 |
| libicu74 | 74.2-1ubuntu3.1 |
| libkrb5-3 | 1.20.1-6ubuntu2.6 |
| libstdc++6 | 14.2.0-4ubuntu2~24.04 |
| lldb | 1:18.0-59~exp2 |
| llvm | 1:18.0-59~exp2 |
| locales | 2.39-0ubuntu8.6 |
| lsb-release | 12.0-2 |
| lsof | 4.95.0-1build3 |
| man-db | 2.12.0-4build2 |
| manpages | 6.7-2 |
| manpages-dev | 6.7-2 |
| nano | 7.2-2ubuntu0.1 |
| ncdu | 1.19-0.1 |
| net-tools | 2.10-0.1ubuntu4.4 |
| ninja-build | 1.11.1-2 |
| openssh-client | 1:9.6p1-3ubuntu13.14 |
| pkg-config | 1.8.1-2build1 |
| procps | 2:4.0.4-4ubuntu3.2 |
| psmisc | 23.7-1build1 |
| rsync | 3.2.7-1ubuntu1.2 |
| strace | 6.8-0ubuntu2 |
| sudo | 1.9.15p5-3ubuntu5.24.04.1 |
| tar | 1.35+dfsg-3build1 |
| unzip | 6.0-28ubuntu4.1 |
| valgrind | 1:3.22.0-0ubuntu3 |
| vim-tiny | 2:9.1.0016-1ubuntu7.9 |
| wget | 1.21.4-1ubuntu4.1 |
| zip | 3.0-13ubuntu0.2 |
| zlib1g | 1:1.3.dfsg-3.1ubuntu2.1 |
| zsh | 5.9-6ubuntu2 |

## Variant: jammy

**Digest:** sha256:977fe1200a65b3b5ba19c413d7fbc3aaa51330964837d879136efce18010f817

**Tags:**
```
mcr.microsoft.com/devcontainers/cpp:dev-jammy
mcr.microsoft.com/devcontainers/cpp:dev-ubuntu22.04
```
> *To keep up to date, we recommend using partial version numbers. Use the major version number to get all non-breaking changes (e.g. `0-`) or major and minor to only get fixes (e.g. `0.200-`).*

**Linux distribution:** Ubuntu 22.04.5 LTS (debian-like distro)

**Architectures:** linux/amd64, linux/arm64

**Available (non-root) user:** vscode

### Contents
**Languages and runtimes**

| Language / runtime | Version | Path |
|--------------------|---------|------|
| GCC | 11.4.0-1ubuntu1~22.04.2 | 
| Clang | 14.0.0-1ubuntu1.1 | 

**Tools installed using git**

| Tool | Commit | Path |
|------|--------|------|
| [Oh My Zsh!](https://github.com/ohmyzsh/ohmyzsh) | e0766905519fbc7982a590a195ee7c3e8bb594e8 | /home/vscode/.oh-my-zsh |
| [vcpkg](https://github.com/microsoft/vcpkg) | 3c4706f7aba0155cb34c366b5ef3397e75e0d14e | /usr/local/vcpkg |

**Other tools and utilities**

| Tool | Version | Path |
|------|---------|------|
| [git](https://github.com/git/git) | 2.52.0 | 

**Additional linux tools and packages**

| Tool / library | Version |
|----------------|---------|
| apt-transport-https | 2.4.14 |
| apt-utils | 2.4.14 |
| bash-completion | 1:2.11-5ubuntu1 |
| build-essential | 12.9ubuntu3 |
| ca-certificates | 20240203~22.04.1 |
| clang | 1:14.0-55~exp2 |
| cmake | 3.22.1-1ubuntu1.22.04.2 |
| cppcheck | 2.7-1 |
| curl | 7.81.0-1ubuntu1.21 |
| dialog | 1.3-20211214-1 |
| gdb | 12.1-0ubuntu1~22.04.2 |
| git | 1:2.34.1-1ubuntu1.15 |
| gnupg2 | 2.2.27-3ubuntu2.5 |
| htop | 3.0.5-7build2 |
| iproute2 | 5.15.0-1ubuntu2 |
| jq | 1.6-2.1ubuntu3.1 |
| less | 590-1ubuntu0.22.04.3 |
| libc6 | 2.35-0ubuntu3.12 |
| libgssapi-krb5-2 | 1.19.2-2ubuntu0.7 |
| libicu70 | 70.1-2 |
| libkrb5-3 | 1.19.2-2ubuntu0.7 |
| liblttng-ust1 | 2.13.1-1ubuntu1 |
| libstdc++6 | 12.3.0-1ubuntu1~22.04.2 |
| lldb | 1:14.0-55~exp2 |
| llvm | 1:14.0-55~exp2 |
| locales | 2.35-0ubuntu3.12 |
| lsb-release | 11.1.0ubuntu4 |
| lsof | 4.93.2+dfsg-1.1build2 |
| man-db | 2.10.2-1 |
| manpages | 5.10-1ubuntu1 |
| manpages-dev | 5.10-1ubuntu1 |
| nano | 6.2-1ubuntu0.1 |
| ncdu | 1.15.1-1 |
| net-tools | 1.60+git20181103.0eebece-1ubuntu5.4 |
| ninja-build | 1.10.1-1 |
| openssh-client | 1:8.9p1-3ubuntu0.13 |
| pkg-config | 0.29.2-1ubuntu3 |
| procps | 2:3.3.17-6ubuntu2.1 |
| psmisc | 23.4-2build3 |
| rsync | 3.2.7-0ubuntu0.22.04.4 |
| strace | 5.16-0ubuntu3 |
| sudo | 1.9.9-1ubuntu2.5 |
| tar | 1.34+dfsg-1ubuntu0.1.22.04.2 |
| unzip | 6.0-26ubuntu3.2 |
| valgrind | 1:3.18.1-1ubuntu2 |
| vim-tiny | 2:8.2.3995-1ubuntu2.24 |
| wget | 1.21.2-2ubuntu1.1 |
| zip | 3.0-12build2 |
| zlib1g | 1:1.2.11.dfsg-2ubuntu9.2 |
| zsh | 5.8.1-1 |

