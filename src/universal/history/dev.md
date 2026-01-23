# [universal](https://github.com/devcontainers/images/tree/main/src/universal)
This document describes the base contents of the Universal image. Note that this image also includes detection logic to dynamically install additional language / runtime versions based on your repository's contents. Dynamically installed content can be found in sub-folders under `/opt`.

**Image version:** dev

**Source release/branch:** [main](https://github.com/devcontainers/images/tree/main/src/universal)

**Digest:** sha256:839d67ad15091db5455b0ff14d7199cba1f82f9ed86651e16329c26f19b9a476

**Tags:**
```
mcr.microsoft.com/devcontainers/universal:dev-noble
mcr.microsoft.com/devcontainers/universal:dev-linux
mcr.microsoft.com/devcontainers/universal:dev
```
> *To keep up to date, we recommend using partial version numbers. Use the major version number to get all non-breaking changes (e.g. `0-`) or major and minor to only get fixes (e.g. `0.200-`).*

**Linux distribution:** Ubuntu 24.04.3 LTS (debian-like distro)

**Architectures:** linux/amd64

**Available (non-root) user:** codespace

### Contents
**Languages and runtimes**

| Language / runtime | Version | Path |
|--------------------|---------|------|
| [Node.js](https://nodejs.org/en/) | 22.22.0<br />24.13.0 | /usr/local/share/nvm/versions/node/&lt;version&gt; |
| [Python](https://www.python.org/) | 3.11.9<br />3.12.1 | /usr/local/python/&lt;version&gt; |
| [Java](https://adoptopenjdk.net/) | 21.0.9<br />25.0.1 | /usr/local/sdkman/candidates/java/&lt;version&gt; |
| [.NET](https://dotnet.microsoft.com/) | 10.0.102 | /usr/share/dotnet/dotnet |
| [Ruby](https://www.ruby-lang.org/en/) | 3.3.10<br />3.4.7 | /usr/local/rvm/rubies/&lt;version&gt; |
| [PHP](https://xdebug.org/) | 8.4.15<br />8.5.0 | /usr/local/php/&lt;version&gt; |
| GCC | 13.3.0-6ubuntu2~24.04 | 
| Clang | 18.1.3 (1ubuntu1) | 
| [Go](https://golang.org/dl) | 1.25.6 | /usr/local/go |
| [Jekyll](https://jekyllrb.com/) | 4.4.1 | 
| [Jupyter Lab](https://jupyter.org/) | 4.5.2 | /home/codespace/.local/bin/jupyter-lab |

**Tools installed using git**

| Tool | Commit | Path |
|------|--------|------|
| [Oh My Zsh!](https://github.com/ohmyzsh/ohmyzsh) | e0766905519fbc7982a590a195ee7c3e8bb594e8 | /home/codespace/.oh-my-zsh |
| [nvm](https://github.com/nvm-sh/nvm.git) | 977563e97ddc66facf3a8e31c6cff01d236f09bd | /usr/local/share/nvm |
| [nvs](https://github.com/jasongin/nvs) | 6b20e9f750ea371bd347e5dbac8406d677292b60 | /usr/local/nvs |
| [rbenv](https://github.com/rbenv/rbenv.git) | ba96d7e3583e6e47ebb2f416ff2cf164e8a94f3f | /usr/local/share/rbenv |
| [ruby-build](https://github.com/rbenv/ruby-build.git) | 10ea7672be0f7396137f81d0880b087c6f6f332a | /usr/local/share/ruby-build |

**Pip / pipx installed tools and packages**

| Tool / package | Version |
|----------------|---------|
| requests | 2.32.5 |
| jupyterlab_git | 0.51.4 |
| certifi | 2026.1.4 |
| setuptools | 80.10.1 |
| pylint | 4.0.4 |
| flake8 | 7.3.0 |
| autopep8 | 2.3.2 |
| black | 26.1.0 |
| yapf | 0.43.0 |
| mypy | 1.19.1 |
| pydocstyle | 6.3.0 |
| pycodestyle | 2.14.0 |
| bandit | 1.9.3 |
| virtualenv | 20.36.1 |
| pipx | 1.8.0 |

**Go tools and modules**

| Tool / module | Version |
|---------------|---------|
| golang.org/x/tools/gopls | 0.21.0 |
| honnef.co/go/tools | 0.7.0-0.dev.0.20251022135355-8273271481d0 |
| golang.org/x/lint | 0.0.0-20241112194109-818c5a804067 |
| github.com/mgechev/revive | 1.13.0 |
| github.com/uudashr/gopkgs | latest |
| github.com/ramya-rao-a/go-outline | latest |
| github.com/go-delve/delve | 1.26.0 |
| github.com/golangci/golangci-lint | latest |

**Ruby gems and tools**

| Tool / gem | Version |
|------------|---------|
| rake | 13.3.1 |
| jekyll | 4.4.1 |

**Other tools and utilities**

| Tool | Version | Path |
|------|---------|------|
| [git](https://github.com/git/git) | 2.52.0 | 
| [Xdebug](https://xdebug.org/) | 3.5.0 | /usr/local/php/current |
| [Composer](https://getcomposer.org/) | 2.9.3 | /usr/local/php/current/bin |
| [kubectl](https://github.com/kubernetes/kubectl) | v1.35.0 | /usr/local/bin |
| [Helm](https://github.com/helm/helm) | 4.0.5 | /usr/local/bin |
| [Docker Compose](https://github.com/docker/compose) | 2.40.3 | /usr/local/bin |
| [rvm](https://github.com/rvm/rvm) | 1.29.12 | /usr/local/rvm |
| [GitHub CLI](https://github.com/cli/cli) | 2.85.0 | 
| [yarn](https://yarnpkg.com/) | 1.22.22 | /usr/bin |
| [Maven](https://maven.apache.org/) | 3.9.12 | /usr/local/sdkman/candidates/maven/current/bin |
| [Gradle](https://gradle.org/) | 9.3.0 | /usr/local/sdkman/candidates/gradle/current/bin |
| Docker (Moby) CLI &amp; Engine | 29.1.4 | 
| [conda](https://github.com/conda/conda) | 25.11.1 | /opt/conda/bin |

**Additional linux tools and packages**

| Tool / library | Version |
|----------------|---------|
| apt-transport-https | 2.8.3 |
| apt-utils | 2.8.3 |
| build-essential | 12.10ubuntu1 |
| ca-certificates | 20240203 |
| clang | 1:18.0-59~exp2 |
| cmake | 3.28.3-1build7 |
| cppcheck | 2.13.0-2ubuntu3 |
| curl | 8.5.0-2ubuntu10.6 |
| dialog | 1.3-20240101-1 |
| g++ | 4:13.2.0-7ubuntu1 |
| gcc | 4:13.2.0-7ubuntu1 |
| gdb | 15.0.50.20240403-0ubuntu1 |
| git | 1:2.43.0-1ubuntu7.3 |
| gnupg2 | 2.4.4-2ubuntu17.4 |
| htop | 3.3.0-4build1 |
| iproute2 | 6.1.0-1ubuntu6.2 |
| iptables | 1.8.10-3ubuntu2 |
| jq | 1.7.1-3ubuntu0.24.04.1 |
| less | 590-2ubuntu2.1 |
| libc6 | 2.39-0ubuntu8.6 |
| libc6-dev | 2.39-0ubuntu8.6 |
| libgssapi-krb5-2 | 1.20.1-6ubuntu2.6 |
| libicu74 | 74.2-1ubuntu3.1 |
| libkrb5-3 | 1.20.1-6ubuntu2.6 |
| libnspr4 | 2:4.35-1.1build1 |
| libnss3 | 2:3.98-1build1 |
| libpango-1.0-0 | 1.52.1+ds-1build1 |
| libpangocairo-1.0-0 | 1.52.1+ds-1build1 |
| libsecret-1-dev | 0.21.4-1build3 |
| libssl1.1 | 1.1.0g-2ubuntu4 |
| libstdc++6 | 14.2.0-4ubuntu2~24.04 |
| libx11-6 | 2:1.8.7-1build1 |
| lldb | 1:18.0-59~exp2 |
| llvm | 1:18.0-59~exp2 |
| locales | 2.39-0ubuntu8.6 |
| lsb-release | 12.0-2 |
| lsof | 4.95.0-1build3 |
| make | 4.3-4.1build2 |
| man-db | 2.12.0-4build2 |
| manpages | 6.7-2 |
| manpages-dev | 6.7-2 |
| moby-cli (Docker CLI) | 29.1.4-ubuntu24.04u1 |
| moby-engine (Docker Engine) | 29.1.4-ubuntu24.04u2 |
| nano | 7.2-2ubuntu0.1 |
| ncdu | 1.19-0.1 |
| net-tools | 2.10-0.1ubuntu4.4 |
| openssh-client | 1:9.6p1-3ubuntu13.14 |
| openssh-server | 1:9.6p1-3ubuntu13.14 |
| pigz | 2.8-1 |
| pkg-config | 1.8.1-2build1 |
| procps | 2:4.0.4-4ubuntu3.2 |
| psmisc | 23.7-1build1 |
| python3-dev | 3.12.3-0ubuntu2.1 |
| python3-minimal | 3.12.3-0ubuntu2.1 |
| rsync | 3.2.7-1ubuntu1.2 |
| sed | 4.9-2build1 |
| software-properties-common | 0.99.49.3 |
| strace | 6.8-0ubuntu2 |
| sudo | 1.9.15p5-3ubuntu5.24.04.1 |
| tar | 1.35+dfsg-3build1 |
| unzip | 6.0-28ubuntu4.1 |
| valgrind | 1:3.22.0-0ubuntu3 |
| vim | 2:9.1.0016-1ubuntu7.9 |
| vim-doc | 2:9.1.0016-1ubuntu7.9 |
| vim-tiny | 2:9.1.0016-1ubuntu7.9 |
| wget | 1.21.4-1ubuntu4.1 |
| xtail | 2.1-9 |
| zip | 3.0-13ubuntu0.2 |
| zlib1g | 1:1.3.dfsg-3.1ubuntu2.1 |
| zsh | 5.9-6ubuntu2 |

