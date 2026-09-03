# [universal](https://github.com/devcontainers/images/tree/main/src/universal)
This document describes the base contents of the Universal image. Note that this image also includes detection logic to dynamically install additional language / runtime versions based on your repository's contents. Dynamically installed content can be found in sub-folders under `/opt`.

**Image version:** dev

**Source release/branch:** [main](https://github.com/devcontainers/images/tree/main/src/universal)

**Digest:** sha256:9ad75754cabbcab541835d1cfc944bd2438f7938aea62756577c4832ff00d836

**Tags:**
```
mcr.microsoft.com/devcontainers/universal:dev-noble
mcr.microsoft.com/devcontainers/universal:dev-linux
mcr.microsoft.com/devcontainers/universal:dev
```
> *To keep up to date, we recommend using partial version numbers. Use the major version number to get all non-breaking changes (e.g. `0-`) or major and minor to only get fixes (e.g. `0.200-`).*

**Linux distribution:** Ubuntu 24.04.4 LTS (debian-like distro)

**Architectures:** linux/amd64

**Available (non-root) user:** codespace

### Contents
**Languages and runtimes**

| Language / runtime | Version | Path |
|--------------------|---------|------|
| [Node.js](https://nodejs.org/en/) | 22.23.2<br />24.20.0 | /usr/local/share/nvm/versions/node/&lt;version&gt; |
| [Python](https://www.python.org/) | 3.13.8<br />3.14.2 | /usr/local/python/&lt;version&gt; |
| [Java](https://adoptopenjdk.net/) | 21.0.12<br />25.0.4 | /usr/local/sdkman/candidates/java/&lt;version&gt; |
| [.NET](https://dotnet.microsoft.com/) | 10.0.400 | /usr/share/dotnet/dotnet |
| [Ruby](https://www.ruby-lang.org/en/) | 3.3.11<br />3.4.9 | /usr/local/rubies/&lt;version&gt; |
| [PHP](https://xdebug.org/) | 8.4.15<br />8.5.0 | /usr/local/php/&lt;version&gt; |
| GCC | 13.3.0-6ubuntu2~24.04.1 | 
| Clang | 18.1.3 (1ubuntu1) | 
| [Go](https://golang.org/dl) | 1.27.1 | /usr/local/go |
| [Jekyll](https://jekyllrb.com/) | 4.4.1 | 
| [Jupyter Lab](https://jupyter.org/) | 4.6.3 | /home/codespace/.local/bin/jupyter-lab |

**Tools installed using git**

| Tool | Commit | Path |
|------|--------|------|
| [Oh My Zsh!](https://github.com/ohmyzsh/ohmyzsh) | 9112b53fa8b5ab556c7c893aa8be8a247ac512a0 | /home/codespace/.oh-my-zsh |
| [nvm](https://github.com/nvm-sh/nvm.git) | f0b0c6bb0b281ceeb106c8cf9ab8fde141215092 | /usr/local/share/nvm |
| [ruby-build](https://github.com/rbenv/ruby-build.git) | a1c1a851371ba08a2dbfee83bee94a97e5e577ca | /usr/local/share/ruby-build |

**Pip / pipx installed tools and packages**

| Tool / package | Version |
|----------------|---------|
| requests | 2.34.2 |
| jupyterlab_git | 0.54.1 |
| certifi | 2026.7.22 |
| pylint | 4.0.8 |
| flake8 | 7.3.0 |
| autopep8 | 2.3.2 |
| black | 26.5.1 |
| yapf | 0.43.0 |
| mypy | 2.3.1 |
| pydocstyle | 6.3.0 |
| pycodestyle | 2.14.0 |
| bandit | 1.9.4 |
| virtualenv | 21.7.8 |
| pipx | 1.17.2 |

**Go tools and modules**

| Tool / module | Version |
|---------------|---------|
| golang.org/x/tools/gopls | 0.23.0 |
| honnef.co/go/tools | 0.8.0-rc.1 |
| golang.org/x/lint | 0.0.0-20241112194109-818c5a804067 |
| github.com/mgechev/revive | 1.16.0 |
| github.com/uudashr/gopkgs | latest |
| github.com/ramya-rao-a/go-outline | latest |
| github.com/go-delve/delve | 1.27.1 |
| github.com/golangci/golangci-lint | latest |

**Ruby gems and tools**

| Tool / gem | Version |
|------------|---------|
| rake | 13.4.2 |
| jekyll | 4.4.1 |

**Other tools and utilities**

| Tool | Version | Path |
|------|---------|------|
| [git](https://github.com/git/git) | 2.55.0 | 
| [Xdebug](https://xdebug.org/) | 3.5.3 | /usr/local/php/current |
| [Composer](https://getcomposer.org/) | 2.10.3 | /usr/local/php/current/bin |
| [kubectl](https://github.com/kubernetes/kubectl) | v1.37.0 | /usr/local/bin |
| [Helm](https://github.com/helm/helm) | 4.2.4 | /usr/local/bin |
| [Docker Compose](https://github.com/docker/compose) | 5.5.0 | /usr/local/bin |
| [GitHub CLI](https://github.com/cli/cli) | 2.99.0 | 
| [yarn](https://yarnpkg.com/) | 1.22.22 | /usr/bin |
| [Maven](https://maven.apache.org/) | 3.9.16 | /usr/local/sdkman/candidates/maven/current/bin |
| [Gradle](https://gradle.org/) | 9.7.1 | /usr/local/sdkman/candidates/gradle/current/bin |
| Docker (Moby) CLI &amp; Engine | 29.7.2 | 
| [conda](https://github.com/conda/conda) | 26.7.1 | /opt/conda/bin |

**Additional linux tools and packages**

| Tool / library | Version |
|----------------|---------|
| apt-transport-https | 2.8.3 |
| apt-utils | 2.8.3 |
| build-essential | 12.10ubuntu1 |
| ca-certificates | 20260601~24.04.1 |
| clang | 1:18.0-59~exp2 |
| cmake | 3.28.3-1build7 |
| cppcheck | 2.13.0-2ubuntu3 |
| curl | 8.5.0-2ubuntu10.13 |
| dialog | 1.3-20240101-1 |
| g++ | 4:13.2.0-7ubuntu1 |
| gcc | 4:13.2.0-7ubuntu1 |
| gdb | 15.1-1ubuntu1~24.04.1 |
| git | 1:2.43.0-1ubuntu7.3 |
| gnupg2 | 2.4.4-2ubuntu17.6 |
| htop | 3.3.0-4build1 |
| iproute2 | 6.1.0-1ubuntu6.4 |
| iptables | 1.8.10-3ubuntu2 |
| jq | 1.7.1-3ubuntu0.24.04.2 |
| less | 590-2ubuntu2.1 |
| libc6 | 2.39-0ubuntu8.8 |
| libc6-dev | 2.39-0ubuntu8.8 |
| libgssapi-krb5-2 | 1.20.1-6ubuntu2.8 |
| libicu74 | 74.2-1ubuntu3.1 |
| libkrb5-3 | 1.20.1-6ubuntu2.8 |
| libnspr4 | 2:4.35-1.1build1 |
| libnss3 | 2:3.98-1ubuntu0.2 |
| libpango-1.0-0 | 1.52.1+ds-1build1 |
| libpangocairo-1.0-0 | 1.52.1+ds-1build1 |
| libsecret-1-dev | 0.21.4-1build3 |
| libstdc++6 | 14.2.0-4ubuntu2~24.04.1 |
| libx11-6 | 2:1.8.7-1build1 |
| lldb | 1:18.0-59~exp2 |
| llvm | 1:18.0-59~exp2 |
| locales | 2.39-0ubuntu8.8 |
| lsb-release | 12.0-2 |
| lsof | 4.95.0-1build3 |
| make | 4.3-4.1build2 |
| man-db | 2.12.0-4build2 |
| manpages | 6.7-2 |
| manpages-dev | 6.7-2 |
| moby-cli (Docker CLI) | 29.7.2-ubuntu24.04u2 |
| moby-engine (Docker Engine) | 29.7.2-ubuntu24.04u2 |
| nano | 7.2-2ubuntu0.2 |
| ncdu | 1.19-0.1 |
| net-tools | 2.10-0.1ubuntu4.4 |
| openssh-client | 1:9.6p1-3ubuntu13.19 |
| openssh-server | 1:9.6p1-3ubuntu13.19 |
| pigz | 2.8-1 |
| pkg-config | 1.8.1-2build1 |
| procps | 2:4.0.4-4ubuntu3.3 |
| psmisc | 23.7-1build1 |
| python3-dev | 3.12.3-0ubuntu2.1 |
| python3-minimal | 3.12.3-0ubuntu2.1 |
| rsync | 3.2.7-1ubuntu1.5 |
| sed | 4.9-2ubuntu0.24.04.1 |
| software-properties-common | 0.99.49.4 |
| strace | 6.8-0ubuntu2 |
| sudo | 1.9.15p5-3ubuntu5.24.04.2 |
| tar | 1.35+dfsg-3ubuntu0.4 |
| unzip | 6.0-28ubuntu4.1 |
| valgrind | 1:3.22.0-0ubuntu3 |
| vim | 2:9.1.0016-1ubuntu7.20 |
| vim-doc | 2:9.1.0016-1ubuntu7.20 |
| vim-tiny | 2:9.1.0016-1ubuntu7.20 |
| wget | 1.21.4-1ubuntu4.5 |
| xtail | 2.1-9 |
| zip | 3.0-13ubuntu0.2 |
| zlib1g | 1:1.3.dfsg-3.1ubuntu2.2 |
| zsh | 5.9-6ubuntu2 |

