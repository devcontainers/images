#!/usr/bin/env bash
#-------------------------------------------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See https://go.microsoft.com/fwlink/?linkid=2090316 for license information.
#-------------------------------------------------------------------------------------------------------------
#
# Maintainer: The VS Code and Codespaces Teams
USERNAME=${USERNAME:-"automatic"}
PYTHON_INSTALL_PATH=${PYTHON_INSTALL_PATH:-"/usr/local/python/current/bin"}
PIPX_BIN_DIR=${PIPX_BIN_DIR:-"/usr/local/py-utils/bin"}

set -eux

if [ "$(id -u)" -ne 0 ]; then
    echo -e 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
    exit 1
fi

# Ensure that login shells get the correct path if the user updated the PATH using ENV.
rm -f /etc/profile.d/00-restore-env.sh
echo "export PATH=${PATH//$(sh -lc 'echo $PATH')/\$PATH}" > /etc/profile.d/00-restore-env.sh
chmod +x /etc/profile.d/00-restore-env.sh

# Determine the appropriate non-root user
if [ "${USERNAME}" = "auto" ] || [ "${USERNAME}" = "automatic" ]; then
    USERNAME=""
    POSSIBLE_USERS=("vscode" "node" "codespace" "$(awk -v val=1000 -F ":" '$3==val{print $1}' /etc/passwd)")
    for CURRENT_USER in ${POSSIBLE_USERS[@]}; do
        if id -u ${CURRENT_USER} > /dev/null 2>&1; then
            USERNAME=${CURRENT_USER}
            break
        fi
    done
    if [ "${USERNAME}" = "" ]; then
        USERNAME=root
    fi
elif [ "${USERNAME}" = "none" ] || ! id -u ${USERNAME} > /dev/null 2>&1; then
    USERNAME=root
fi

sudo_if() {
    COMMAND="$*"
    if [ "$(id -u)" -eq 0 ] && [ "$USERNAME" != "root" ]; then
        su - "$USERNAME" -c "$COMMAND"
    else
        "$COMMAND"
    fi
}

export DEBIAN_FRONTEND=noninteractive

PACKAGES="keras matplotlib numpy pandas plotly requests scikit-learn scipy seaborn tensorflow torch"

if [[ -d "${PYTHON_INSTALL_PATH}" ]] && [[ -d "${PIPX_BIN_DIR}" ]]; then
    PATH="$PATH:$PYTHON_INSTALL_PATH:$PIPX_BIN_DIR"
    sudo_if "${PYTHON_INSTALL_PATH}/python3" -m pip install --user --upgrade --no-cache-dir $PACKAGES
else
    "(*) Error: Need to install python."
fi

echo "Done!"