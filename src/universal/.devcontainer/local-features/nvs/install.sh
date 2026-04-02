#!/usr/bin/env bash
#-------------------------------------------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See https://go.microsoft.com/fwlink/?linkid=2090316 for license information.
#-------------------------------------------------------------------------------------------------------------

USERNAME=${USERNAME:-"codespace"}
NVS_HOME=${NVS_HOME:-"/usr/local/nvs"}

set -eux

if [ "$(id -u)" -ne 0 ]; then
    echo -e 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
    exit 1
fi

# Ensure that login shells get the correct path if the user updated the PATH using ENV.
rm -f /etc/profile.d/00-restore-env.sh
echo "export PATH=${PATH//$(sh -lc 'echo $PATH')/\$PATH}" > /etc/profile.d/00-restore-env.sh
chmod +x /etc/profile.d/00-restore-env.sh

# Function to install packages if needed
install_packages_if_needed()
{
    if command -v dnf > /dev/null 2>&1; then
        dnf -y install "$@"
    elif command -v apt-get > /dev/null 2>&1; then
        if [ ! -d "/var/lib/apt/lists" ] || [ "$(ls /var/lib/apt/lists/ | wc -l)" = "0" ]; then
            apt-get update
        fi
        apt-get -y install --no-install-recommends "$@"
    fi
}

# Checks if packages are installed and installs them if not
check_packages() {
    if command -v rpm > /dev/null 2>&1; then
        for pkg in "$@"; do
            if ! rpm -q "$pkg" > /dev/null 2>&1; then
                install_packages_if_needed "$pkg"
            fi
        done
    elif ! dpkg -s "$@" > /dev/null 2>&1; then
        install_packages_if_needed "$@"
    fi
}

updaterc() {
    echo "Updating /etc/bash.bashrc and /etc/zsh/zshrc..."
    if [[ "$(cat /etc/bash.bashrc)" != *"$1"* ]]; then
        echo -e "$1" >> /etc/bash.bashrc
    fi
    if [ -f "/etc/zsh/zshrc" ] && [[ "$(cat /etc/zsh/zshrc)" != *"$1"* ]]; then
        echo -e "$1" >> /etc/zsh/zshrc
    fi
}

if ! cat /etc/group | grep -e "^nvs:" > /dev/null 2>&1; then
    groupadd -r nvs
fi
usermod -a -G nvs "${USERNAME}"

git config --global --add safe.directory ${NVS_HOME}
mkdir -p ${NVS_HOME} 

git clone -c advice.detachedHead=false --depth 1 https://github.com/jasongin/nvs ${NVS_HOME} 2>&1
(cd ${NVS_HOME} && git remote get-url origin && echo $(git log -n 1 --pretty=format:%H -- .)) > ${NVS_HOME}/.git-remote-and-commit
bash ${NVS_HOME}/nvs.sh install
rm ${NVS_HOME}/cache/*

# Clean up
rm -rf ${NVS_HOME}/.git

updaterc "if [[ \"\${PATH}\" != *\"${NVS_HOME}\"* ]]; then export PATH=${NVS_HOME}:\${PATH}; fi"

chown -R "${USERNAME}:nvs" "${NVS_HOME}"
chmod -R g+r+w "${NVS_HOME}"
find "${NVS_HOME}" -type d | xargs -n 1 chmod g+s

NVS="/home/codespace/.nvs"
mkdir -p ${NVS}
ln -snf ${NVS_HOME}/* $NVS

echo "Done!"
