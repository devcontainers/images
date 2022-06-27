#!/usr/bin/env bash
#-------------------------------------------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See https://go.microsoft.com/fwlink/?linkid=2090316 for license information.
#-------------------------------------------------------------------------------------------------------------
#
# Docs: https://github.com/microsoft/vscode-dev-containers/blob/main/script-library/docs/hugo.md
# Maintainer: The VS Code and Codespaces Teams
#
# Syntax: ./jekyll-debian.sh [Jekyll version] [Non-root user] [Add rc files flag]

VERSION=${1:-"latest"}
USERNAME=${2:-"codespace"}

set -e

# If in automatic mode, determine if a user already exists, if not use codespace
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
        USERNAME=codespace
    fi
elif [ "${USERNAME}" = "none" ]; then
    USERNAME=root
    USER_UID=0
    USER_GID=0
fi

# Use sudo to run as non-root user is not already running
sudo_if() {
    COMMAND="$*"
    if [ "$(id -u)" -eq 0 ] && [ "$USERNAME" != "root" ]; then
        su - "$USERNAME" -c "$COMMAND"
    else
        "$COMMAND"
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

# If we don't yet have Ruby installed, exit.
if ! /usr/local/rvm/rubies/default/bin/ruby --version > /dev/null ; then
    echo "You need to install Ruby before installing Jekyll."
    exit 1
fi

# If we don't already have Jekyll installed, install it now.
if ! jekyll --version > /dev/null ; then
    echo "Installing Jekyll..."
    
    GEMS_DIR=/usr/local/rvm/rubies/default/bin/gem
    PATH=$GEMS_DIR:$PATH
    if [ "${VERSION}" = "latest" ]; then
        gem install jekyll
    else
        gem install jekyll -v "${VERSION}"
    fi

    chown -R "${USERNAME}:rvm" "${GEMS_DIR}/"
    chmod -R g+r+w "${GEMS_DIR}/"
    find "${GEMS_DIR}" -type d | xargs -n 1 chmod g+s
fi
