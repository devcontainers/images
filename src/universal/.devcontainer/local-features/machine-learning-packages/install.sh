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

sudo_if() {
    COMMAND="$*"
    if [ "$(id -u)" -eq 0 ] && [ "$USERNAME" != "root" ]; then
        su - "$USERNAME" -c "$COMMAND"
    else
        "$COMMAND"
    fi
}

export DEBIAN_FRONTEND=noninteractive

install_torch_check_gpu() {
    if ! command -v lspci &> /dev/null; then
        echo "lspci not found. Attempting to install..."
        apt-get update && apt-get install -y pciutils
    fi
    # Detect GPU
    set +e
    GPU=$(lspci | grep -i NVIDIA)
    set -e
    if [ -n "$GPU" ]; then
        echo "GPU Detected. Installing Torch with GPU support."
        sudo_if /usr/local/python/current/bin/python -m pip install --user --upgrade --no-cache-dir torch
    else
        echo "No GPU Detected. Installing Torch with CPU support."
        sudo_if /usr/local/python/current/bin/python -m pip install --user --upgrade --no-cache-dir torch -f https://download.pytorch.org/whl/cpu/torch_stable.html
    fi
}

install_python_package() {
    PACKAGE=${1:-""}

    sudo_if /usr/local/python/current/bin/python -m pip uninstall --yes $PACKAGE
    echo "Installing $PACKAGE..."
    if [[ $PACKAGE == "torch" ]]; then
        install_torch_check_gpu
    else 
        sudo_if /usr/local/python/current/bin/python -m pip install --user --upgrade --no-cache-dir $PACKAGE
    fi
}

if [[ "$(python --version)" != "" ]] && [[ "$(pip --version)" != "" ]]; then
    install_python_package "numpy"
    install_python_package "pandas"
    install_python_package "scipy"
    install_python_package "matplotlib"
    install_python_package "seaborn"
    install_python_package "scikit-learn"
    install_python_package "torch"
    install_python_package "requests"
    install_python_package "plotly"
else
    "(*) Error: Need to install python and pip."
fi

echo "Done!"
