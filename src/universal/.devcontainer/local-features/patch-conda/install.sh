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

    sudo_if "conda install -y -c defaults $PACKAGE=$VERSION"
}

sudo_if /opt/conda/bin/python3 -m pip install --upgrade pip

# Remove any cached pip packages under /opt/conda/pkgs vulnerable to GHSA-jp4c-xjxw-mgf9
# (pip < 26.1). Only pip cache entries older than 26.1 are removed; this does not touch
# the active pip install in site-packages (upgraded above via pip).
for pkg_path in /opt/conda/pkgs/pip-[0-9]*; do
    [ -e "$pkg_path" ] || continue
    pkg_name="$(basename "$pkg_path")"
    pkg_version="${pkg_name#pip-}"
    pkg_version="${pkg_version%%-*}"
    greater_version="$(printf '%s\n%s\n' "$pkg_version" "26.1" | sort -V | tail -1)"
    if [ "$pkg_version" != "$greater_version" ]; then
        sudo_if "rm -rf $pkg_path"
    fi
done

# Temporary: Upgrade python packages due to security vulnerabilities
# They are installed by the conda feature and Conda distribution does not have the patches

# https://github.com/advisories/GHSA-r6ph-v2qm-q3c2
update_conda_package pyopenssl "26.0.0"

# https://github.com/advisories/GHSA-p423-j2cm-9vmq
update_conda_package cryptography "46.0.7"

# https://nvd.nist.gov/vuln/detail/CVE-2025-6176
update_conda_package brotli "1.2.0"

# https://github.com/advisories/GHSA-mf9w-mj56-hr94
update_python_package /opt/conda/bin/python3 python-dotenv "1.2.2"

