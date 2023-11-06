#!/usr/bin/env bash
#-------------------------------------------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See https://go.microsoft.com/fwlink/?linkid=2090316 for license information.
#-------------------------------------------------------------------------------------------------------------

USERNAME=${USERNAME:-"codespace"}

set -eux

if [ "$(id -u)" -ne 0 ]; then
    echo -e 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
    exit 1
fi

# Ensure that login shells get the correct path if the user updated the PATH using ENV.
rm -f /etc/profile.d/00-restore-env.sh
echo "export PATH=${PATH//$(sh -lc 'echo $PATH')/\$PATH}" > /etc/profile.d/00-restore-env.sh
chmod +x /etc/profile.d/00-restore-env.sh

export DEBIAN_FRONTEND=noninteractive

sudo_if() {
    COMMAND="$*"
    if [ "$(id -u)" -eq 0 ] && [ "$USERNAME" != "root" ]; then
        su - "$USERNAME" -c "$COMMAND"
    else
        "$COMMAND"
    fi
}

update_python_package() {
    PYTHON_PATH=$1
    PACKAGE=$2
    VERSION=$3

    sudo_if "$PYTHON_PATH -m pip uninstall --yes $PACKAGE"
    sudo_if "$PYTHON_PATH -m pip install --upgrade --no-cache-dir $PACKAGE==$VERSION"
    sudo_if "$PYTHON_PATH -m pip show --no-python-version-warning $PACKAGE"
}

update_conda_package() {
    PACKAGE=$1
    VERSION=$2

    sudo_if "conda install $PACKAGE=$VERSION"
}

sudo_if /opt/conda/bin/python3 -m pip install --upgrade pip

# Temporary: Upgrade python packages due to security vulnerabilities
# They are installed by the conda feature and Conda distribution does not have the patches.

# https://github.com/advisories/GHSA-v8gr-m533-ghj9
update_python_package /opt/conda/bin/python3 cryptography "41.0.4"

# https://github.com/advisories/GHSA-v845-jxx5-vc9f
update_conda_package urllib3 "1.26.18"
