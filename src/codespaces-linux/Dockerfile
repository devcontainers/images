#-------------------------------------------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See https://go.microsoft.com/fwlink/?linkid=2090316 for license information.
#-------------------------------------------------------------------------------------------------------------
FROM mcr.microsoft.com/oryx/build:vso-focal-20220429.1 as kitchensink

ARG USERNAME=codespace
ARG USER_UID=1000
ARG USER_GID=$USER_UID
ARG HOMEDIR=/home/$USERNAME

# Default to bash shell (other shells available at /usr/bin/fish and /usr/bin/zsh)
ENV SHELL=/bin/bash \
    ORYX_ENV_TYPE=vsonline-present \
    DOTNET_ROOT="${HOMEDIR}/.dotnet" \
    JAVA_ROOT="${HOMEDIR}/.java" \
    NODE_ROOT="${HOMEDIR}/.nodejs" \
    PHP_ROOT="${HOMEDIR}/.php" \
    PYTHON_ROOT="${HOMEDIR}/.python" \
    RUBY_ROOT="${HOMEDIR}/.ruby" \
    MAVEN_ROOT="${HOMEDIR}/.maven" \
    HUGO_ROOT="${HOMEDIR}/.hugo" \
    NVM_SYMLINK_CURRENT=true \
    NVM_DIR="/home/${USERNAME}/.nvm" \
    NVS_HOME="/home/${USERNAME}/.nvs" \
    NPM_GLOBAL="/home/${USERNAME}/.npm-global" \
    PIPX_HOME="/usr/local/py-utils" \
    PIPX_BIN_DIR="/usr/local/py-utils/bin" \
    RVM_PATH="/usr/local/rvm" \
    RAILS_DEVELOPMENT_HOSTS=".githubpreview.dev" \ 
    GOROOT="/usr/local/go" \
    GOPATH="/go" \
    SDKMAN_DIR="/usr/local/sdkman" \
    JUPYTERLAB_PATH="${HOMEDIR}/.local/bin" \
    DOCKER_BUILDKIT=1

ENV PATH="${NVM_DIR}/current/bin:${NPM_GLOBAL}/bin:${PYTHON_ROOT}/current/bin:${ORIGINAL_PATH}:${DOTNET_ROOT}:${DOTNET_ROOT}/tools:${SDKMAN_DIR}/bin:${SDKMAN_DIR}/candidates/gradle/current/bin:${SDKMAN_DIR}/candidates/java/current/bin:/opt/maven/lts:${GOROOT}/bin:${GOPATH}/bin:${PIPX_BIN_DIR}:/opt/conda/condabin:${JAVA_ROOT}/current/bin:${NODE_ROOT}/current/bin:${PHP_ROOT}/current/bin:${RUBY_ROOT}/current/bin:${MAVEN_ROOT}/current/bin:${HUGO_ROOT}/current/bin:${JUPYTERLAB_PATH}:${ORYX_PATHS}"

# Install needed utilities and setup non-root user. Use a separate RUN statement to add your own dependencies.
COPY setup-python-tools.sh setup-user.sh first-run-notice.txt /tmp/scripts/

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    # Restore man command
    && yes | unminimize 2>&1 

# Run setup user script
RUN bash /tmp/scripts/setup-user.sh "${USERNAME}" "${PATH}" \
    # Change owner of opt contents since Oryx can dynamically install and will run as "codespace"
    && chown ${USERNAME} /opt/* \
    && chsh -s /bin/bash ${USERNAME} \
    # Verify expected build and debug tools are present
    && apt-get -y install build-essential cmake cppcheck valgrind clang lldb llvm gdb python3-dev \
    # Install tools and shells not in common script
    && apt-get install -yq vim vim-doc xtail software-properties-common libsecret-1-dev \
    # Install additional tools (useful for 'puppeteer' project)
    && apt-get install -y --no-install-recommends libnss3 libnspr4 libatk-bridge2.0-0 libatk1.0-0 libx11-6 libpangocairo-1.0-0 \
                                                  libx11-xcb1 libcups2 libxcomposite1 libxdamage1 libxfixes3 libpango-1.0-0 libgbm1 libgtk-3-0 \
    # Clean up
    && apt-get autoremove -y && apt-get clean -y \
    # Move first run notice to right spot
    && mkdir -p /usr/local/etc/vscode-dev-containers/ \
    && mv -f /tmp/scripts/first-run-notice.txt /usr/local/etc/vscode-dev-containers/

RUN bash /tmp/scripts/setup-python-tools.sh "${PYTHON_ROOT}/current/bin/python"

# Install nvs (alternate cross-platform Node.js version-management tool)
RUN git config --global --add safe.directory /home/codespace/.nvs \
    && mkdir -p ${NVS_HOME} \
    && chown -R ${USERNAME}: ${NVS_HOME} \
    && sudo -u ${USERNAME} git clone -c advice.detachedHead=false --depth 1 https://github.com/jasongin/nvs ${NVS_HOME} 2>&1 \
    && (cd ${NVS_HOME} && git remote get-url origin && echo $(git log -n 1 --pretty=format:%H -- .)) > ${NVS_HOME}/.git-remote-and-commit \
    && sudo -u ${USERNAME} bash ${NVS_HOME}/nvs.sh install \
    && rm ${NVS_HOME}/cache/* \
    # Clean up
    && rm -rf ${NVM_DIR}/.git ${NVS_HOME}/.git

# Link composer
RUN ln -s $(which composer.phar) /usr/local/bin/composer \
    && apt-get clean -y

# Remove scripts now that we're done with them
RUN apt-get clean -y && rm -rf /tmp/scripts

# Mount for docker-in-docker 
VOLUME [ "/var/lib/docker" ]

# Fire Docker/Moby script if needed along with Oryx's benv
ENTRYPOINT [ "/usr/local/share/docker-init.sh", "/usr/local/share/ssh-init.sh", "benv" ]
CMD [ "sleep", "infinity" ]

# [Optional] Install debugger for development of Codespaces - Not in resulting image by default
ARG DeveloperBuild
RUN if [ -z $DeveloperBuild ]; then \
        echo "not including debugger" ; \
    else \
        curl -sSL https://aka.ms/getvsdbgsh | bash /dev/stdin -v latest -l /vsdbg ; \
    fi

USER ${USERNAME}
