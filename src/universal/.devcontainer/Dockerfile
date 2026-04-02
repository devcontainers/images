#-------------------------------------------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See https://go.microsoft.com/fwlink/?linkid=2090316 for license information.
#-------------------------------------------------------------------------------------------------------------

FROM fedora:43

COPY first-run-notice.txt /tmp/scripts/

ENV LANG="C.UTF-8"

# Install packages in a single layer to reduce image size
RUN dnf -y update \
    && dnf -y install \
        make \
        unzip \
        # Build tools
        gcc \
        gcc-c++ \
        swig \
        # Required for Microsoft SQL Server
        unixODBC-devel \
        # Required for PostgreSQL
        libpq-devel \
        # Required for mysqlclient
        mariadb-connector-c-devel \
        # Required for ts
        moreutils \
        rsync \
        zip \
        jq \
        # Python
        python3-pip \
        python3-devel \
        # .NET Core related pre-requisites
        glibc \
        libgcc \
        krb5-libs \
        ncurses-libs \
        lttng-ust \
        openssl-devel \
        libstdc++ \
        zlib \
        libuuid \
        libunwind \
        sqlite \
        sqlite-devel \
        tk-devel \
        uuid-devel \
        curl \
        gettext \
        inotify-tools \
        # Build and debug tools
        cmake \
        cppcheck \
        valgrind \
        clang \
        lldb \
        llvm \
        gdb \
        # Tools and shells
        vim-enhanced \
        libsecret-devel \
        # Fish shell
        fish \
        # Networking and utilities
        openssh-server \
        pigz \
        iptables \
        tar \
        pkg-config \
        sed \
        python3 \
    && dnf clean all \
    # Move first run notice to right spot
    && mkdir -p "/usr/local/etc/vscode-dev-containers/" \
    && mv -f /tmp/scripts/first-run-notice.txt /usr/local/etc/vscode-dev-containers/ \
    # Setup fish prompt
    && mkdir -p /etc/fish/functions /etc/fish/conf.d \
    && FISH_PROMPT="function fish_prompt\n    set_color green\n    echo -n (whoami)\n    set_color normal\n    echo -n \":\"\n    set_color blue\n    echo -n (pwd)\n    set_color normal\n    echo -n \"> \"\nend\n" \
    && printf "$FISH_PROMPT" >> /etc/fish/functions/fish_prompt.fish \
    && printf "if type code-insiders > /dev/null 2>&1; and not type code > /dev/null 2>&1\n  alias code=code-insiders\nend" >> /etc/fish/conf.d/code_alias.fish \
    # Remove scripts now that we're done with them
    && rm -rf /tmp/scripts

# Default to bash shell (other shells available at /usr/bin/fish and /usr/bin/zsh)
ENV SHELL=/bin/bash \
    DOCKER_BUILDKIT=1

# Mount for docker-in-docker 
VOLUME [ "/var/lib/docker" ]

CMD [ "sleep", "infinity" ]

# [Optional] Install debugger for development of Codespaces - Not in resulting image by default
ARG DeveloperBuild
RUN if [ -z $DeveloperBuild ]; then \
        echo "not including debugger" ; \
    else \
        curl -sSL https://aka.ms/getvsdbgsh | bash /dev/stdin -v latest -l /vsdbg ; \
    fi
