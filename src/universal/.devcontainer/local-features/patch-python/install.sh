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

update_package() {
    PYTHON_PATH=$1
    PACKAGE=$2
    VERSION=$3

    sudo_if "$PYTHON_PATH -m pip uninstall --yes $PACKAGE"
    sudo_if "$PYTHON_PATH -m pip install --upgrade --no-cache-dir $PACKAGE==$VERSION"
    sudo_if "$PYTHON_PATH -m pip show --no-python-version-warning $PACKAGE"
}

# Temporary: Upgrade python packages due to security vulnerabilities
# They are installed by the base image (python) which does not have the patch.

# https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2022-40897
update_package /usr/local/python/3.9.*/bin/python setuptools 65.5.1

# https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2023-45803
update_package /usr/local/python/3.10.*/bin/python urllib3 2.0.7
