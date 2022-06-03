#-------------------------------------------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See https://go.microsoft.com/fwlink/?linkid=2090316 for license information.
#-------------------------------------------------------------------------------------------------------------
FROM ubuntu:focal

ARG USERNAME=codespace
ARG USER_UID=1000
ARG USER_GID=$USER_UID
ARG HOMEDIR=/home/$USERNAME

COPY setup-user.sh first-run-notice.txt /tmp/scripts/

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    # Restore man command
    && yes | unminimize 2>&1 

# Install basic build tools
RUN LANG="C.UTF-8" \
    && apt-get update \
    && apt-get upgrade -y \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        git \
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
        python-pip-whl \
        python3-pip \
        #.NET Core related pre-requisites
        libc6 \
        libgcc1 \
        libgssapi-krb5-2 \
        libncurses5 \
        liblttng-ust0 \
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
    && rm -rf /var/lib/apt/lists/* \
    # This is the folder containing 'links' to benv and build script generator
    && apt-get update \
    && apt-get upgrade -y \
    && add-apt-repository universe \
    && apt-get install -y --no-install-recommends python2 \
    && rm -rf /var/lib/apt/lists/* \
    # 'get-pip.py' has been moved to ' https://bootstrap.pypa.io/pip/2.7/get-pip.py' from 'https://bootstrap.pypa.io/2.7/get-pip.py'
    && curl  https://bootstrap.pypa.io/pip/2.7/get-pip.py --output get-pip.py \
    && python2 get-pip.py \
    && pip install pip --upgrade \
    && pip3 install pip --upgrade

RUN groupadd -g 1000 ${USERNAME}
RUN useradd -u 1000 -g ${USERNAME} ${USERNAME}
RUN chown -R ${USERNAME}:${USERNAME} /usr/local/
RUN mkdir -p ${HOMEDIR} && chown -R ${USERNAME}:${USERNAME} ${HOMEDIR}/

# Change owner of opt contents since Oryx can dynamically install and will run as "codespace"
RUN chsh -s /bin/bash ${USERNAME} \
    # Verify expected build and debug tools are present
    && apt-get update \
    && apt-get -y install build-essential cmake cppcheck valgrind clang lldb llvm gdb python3-dev \
    # Install tools and shells not in common script
    && apt-get install -yq vim vim-doc xtail software-properties-common libsecret-1-dev \
    # Install additional tools (useful for 'puppeteer' project)
    && apt-get install -y --no-install-recommends libnss3 libnspr4 libatk-bridge2.0-0 libatk1.0-0 libx11-6 libpangocairo-1.0-0 \
                                                  libx11-xcb1 libcups2 libxcomposite1 libxdamage1 libxfixes3 libpango-1.0-0 libgbm1 libgtk-3-0 \
    # Clean up
    && apt-get autoremove -y && apt-get clean -y \
    # Move first run notice to right spot
    && mkdir -p "/usr/local/etc/vscode-dev-containers/" \
    && mv -f /tmp/scripts/first-run-notice.txt /usr/local/etc/vscode-dev-containers/

# Default to bash shell (other shells available at /usr/bin/fish and /usr/bin/zsh)
ENV SHELL=/bin/bash \
    ORYX_ENV_TYPE=vsonline-present \
    PHP_ROOT="/usr/local/php" \
    PYTHON_ROOT="/usr/local/python" \
    HUGO_ROOT="/usr/local/hugo" \
    NVM_SYMLINK_CURRENT=true \
    NVM_DIR="/usr/local/share/nvm" \
    NVS_HOME="/home/${USERNAME}/.nvs" \
    PIPX_BIN_DIR="/usr/local/py-utils/bin" \
    RVM_PATH="/usr/local/rvm" \
    RAILS_DEVELOPMENT_HOSTS=".githubpreview.dev" \ 
    GOROOT="/usr/local/go" \
    GOPATH="/go" \
    SDKMAN_DIR="/usr/local/sdkman" \
    ANACONDA="/usr/local/anaconda" \
    ORYX="/usr/local/oryx" \
    DOCKER_BUILDKIT=1 \
    ORYX_SDK_STORAGE_BASE_URL="https://oryx-cdn.microsoft.io" \
    ENABLE_DYNAMIC_INSTALL="true"

ENV PATH="${PATH}:${NVM_DIR}/current/bin:${PYTHON_ROOT}/current/bin:${SDKMAN_DIR}/bin:${SDKMAN_DIR}/candidates/gradle/current/bin:${SDKMAN_DIR}/candidates/java/current/bin:${SDKMAN_DIR}/candidates/maven/current/bin:${GOROOT}/bin:${GOPATH}/bin:${PIPX_BIN_DIR}:${ANACONDA}/bin:${PHP_ROOT}/current/bin:${PHP_ROOT}/current:${HUGO_ROOT}/bin:${ORYX}:${RVM_PATH}/gems/default/bin:${RVM_PATH}/gems/default@global/bin:/${RVM_PATH}/rubies/default/bin:${NVS_HOME}"

# Run setup user script
RUN bash /tmp/scripts/setup-user.sh "${USERNAME}" "${PATH}" 

# Install nvs (alternate cross-platform Node.js version-management tool)
RUN git config --global --add safe.directory ${NVS_HOME} \
    && sudo mkdir -p ${NVS_HOME} \
    && chown -R ${USERNAME}:${USERNAME} ${NVS_HOME} \
    && sudo -u ${USERNAME} git clone -c advice.detachedHead=false --depth 1 https://github.com/jasongin/nvs ${NVS_HOME} 2>&1 \
    && (cd ${NVS_HOME} && git remote get-url origin && echo $(git log -n 1 --pretty=format:%H -- .)) > ${NVS_HOME}/.git-remote-and-commit \
    && sudo -u ${USERNAME} bash ${NVS_HOME}/nvs.sh install \
    && rm ${NVS_HOME}/cache/* \
    # Clean up
    && rm -rf ${NVM_DIR}/.git ${NVS_HOME}/.git

# This enabled the oryx tool to generate manifest-dir which is needed for running the postcreate tool
RUN mkdir -p /usr/local/oryx\
    && echo "vso-focal" > /usr/local/oryx/.imagetype

# Remove scripts now that we're done with them
RUN apt-get clean -y && rm -rf /tmp/scripts

# Mount for docker-in-docker 
VOLUME [ "/var/lib/docker" ]

# Fire Docker/Moby script if needed
ENTRYPOINT [ "/usr/local/share/docker-init.sh", "/usr/local/share/ssh-init.sh"]
CMD [ "sleep", "infinity" ]

# [Optional] Install debugger for development of Codespaces - Not in resulting image by default
ARG DeveloperBuild
RUN if [ -z $DeveloperBuild ]; then \
        echo "not including debugger" ; \
    else \
        curl -sSL https://aka.ms/getvsdbgsh | bash /dev/stdin -v latest -l /vsdbg ; \
    fi

USER ${USERNAME}
