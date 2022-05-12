#!/usr/bin/env bash

ARG USERNAME=codespace
bash /tmp/scripts/setup-user.sh "${USERNAME}" "${PATH}"

# Install common machine learning packages
PYTHON_BINARY="${PYTHON_ROOT}/current/bin/python"
bash /tmp/scripts/setup-python-tools.sh ${PYTHON_BINARY}

# Setup Node.js, install NVM and NVS
(cd ${NVM_DIR} git remote get-url origin echo $(git log -n 1 --pretty=format:%H -- .)) > ${NVM_DIR}/.git-remote-and-commit

# Install nvs (alternate cross-platform Node.js version-management tool)
git config --global --add safe.directory /home/codespace/.nvs
mkdir -p ${NVS_HOME}
chown -R ${USERNAME}: ${NVS_HOME}
sudo -u ${USERNAME} git clone -c advice.detachedHead=false --depth 1 https://github.com/jasongin/nvs ${NVS_HOME} 2>&1
(cd ${NVS_HOME} git remote get-url origin echo $(git log -n 1 --pretty=format:%H -- .)) > ${NVS_HOME}/.git-remote-and-commit
sudo -u ${USERNAME} bash ${NVS_HOME}/nvs.sh install
rm ${NVS_HOME}/cache/*
# Clean up
rm -rf ${NVM_DIR}/.git ${NVS_HOME}/.git

# Install SDKMAN, and OpenJDK8 (JDK 17 already present)
su ${USERNAME} -c ". ${SDKMAN_DIR}/bin/sdkman-init.sh
sdk install java 11-opt-java /opt/java/17.0
sdk install java lts-opt-java /opt/java/lts"

apt-get clean -y && rm -rf /tmp/scripts