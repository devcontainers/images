#-------------------------------------------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See https://go.microsoft.com/fwlink/?linkid=2090316 for license information.
#-------------------------------------------------------------------------------------------------------------

FROM ubuntu:noble

RUN if id "ubuntu" &>/dev/null; then \
            echo "Deleting user 'ubuntu' for noble" && userdel -f -r ubuntu || echo "Failed to delete ubuntu user for noble"; \  
        else \
            echo "User 'ubuntu' does not exist for noble"; \ 
    fi

COPY first-run-notice.txt /tmp/scripts/

ENV LANG="C.UTF-8"

ENV DEBIAN_FRONTEND=noninteractive

# Switch apt sources to HTTPS and add retry/timeout settings
# Bootstrap: install ca-certificates with temporary cert verification bypass,
# then switch to fully verified HTTPS for all subsequent apt operations
RUN printf 'Acquire::https::Verify-Peer "false";\nAcquire::Retries "5";\nAcquire::ForceIPv4 "true";\n' \
        > /etc/apt/apt.conf.d/99-bootstrap \
    && if [ -f /etc/apt/sources.list.d/ubuntu.sources ]; then \
        sed -i 's|http://archive.ubuntu.com|https://archive.ubuntu.com|g; s|http://security.ubuntu.com|https://security.ubuntu.com|g' \
            /etc/apt/sources.list.d/ubuntu.sources; \
    elif [ -f /etc/apt/sources.list ]; then \
        sed -i 's|http://archive.ubuntu.com|https://archive.ubuntu.com|g; s|http://security.ubuntu.com|https://security.ubuntu.com|g' \
            /etc/apt/sources.list; \
    fi \
    && apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates \
    && rm -f /etc/apt/apt.conf.d/99-bootstrap \
    && printf 'Acquire::Retries "5";\nAcquire::http::Timeout "30";\nAcquire::https::Timeout "30";\nAcquire::ForceIPv4 "true";\n' \
        > /etc/apt/apt.conf.d/80-network-retries \
    && rm -rf /var/lib/apt/lists/*

#Merging the mutiple layers to reduce the size of the image slightly
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    # Restore man command
    && yes | unminimize 2>&1 \ 
    # Install basic build tools
    && apt-get upgrade -y \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        make \
        unzip \
        # The tools in this package are used when installing packages for Python
        build-essential \
        swig3.0 \
        # Required for Microsoft SQL Server
        unixodbc-dev \
        # Required for PostgreSQL
        libpq-dev \
        # Required for mysqlclient
        default-libmysqlclient-dev \
        # Required for ts
        moreutils \
        rsync \
        zip \
        libgdiplus \
        jq \
        # By default pip is not available in the buildpacks image
        python3-pip \
        #.NET Core related pre-requisites
        libc6 \
        libgcc1 \
        libgssapi-krb5-2 \
        libncurses6 \
        liblttng-ust1 \
        libssl-dev \
        libstdc++6 \
        zlib1g \
        libuuid1 \
        libunwind8 \
        sqlite3 \
        libsqlite3-dev \
        software-properties-common \
        tk-dev \
        uuid-dev \
        curl \
        gettext \
        inotify-tools \
    # Add universe repo
    && add-apt-repository universe \
    && apt-get update \
    # Verify expected build and debug tools are present
    && apt-get -y install build-essential cmake cppcheck valgrind clang lldb llvm gdb python3-dev \
    # Install tools and shells not in common script
    && apt-get install -yq vim vim-doc xtail software-properties-common libsecret-1-dev \
    # Clean up
    && apt-get autoremove -y && apt-get clean -y \
    # Move first run notice to right spot
    && mkdir -p "/usr/local/etc/vscode-dev-containers/" \
    && mv -f /tmp/scripts/first-run-notice.txt /usr/local/etc/vscode-dev-containers/ \
    # Install and setup fish
    && apt-get install -yq fish \
    && FISH_PROMPT="function fish_prompt\n    set_color green\n    echo -n (whoami)\n    set_color normal\n    echo -n \":\"\n    set_color blue\n    echo -n (pwd)\n    set_color normal\n    echo -n \"> \"\nend\n" \
    && printf "$FISH_PROMPT" >> /etc/fish/functions/fish_prompt.fish \
    && printf "if type code-insiders > /dev/null 2>&1; and not type code > /dev/null 2>&1\n  alias code=code-insiders\nend" >> /etc/fish/conf.d/code_alias.fish \   
    # Remove scripts now that we're done with them
    && apt-get clean -y && rm -rf /tmp/scripts

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
