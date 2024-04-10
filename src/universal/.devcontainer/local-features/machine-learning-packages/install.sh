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

install_python_package() {
    PACKAGE=${1:-""}
    shift  # Remove the first argument (PACKAGE) from the list of arguments
    sudo_if /usr/local/python/current/bin/python -m pip uninstall --yes $PACKAGE
    # Install the package with any remaining arguments (if provided)
    if [ $# -gt 0 ]; then
        # Additional arguments are provided (e.g., -f URL)
        echo "Installing $PACKAGE with options: $@"
        sudo_if /usr/local/python/current/bin/python -m pip install --user --upgrade --no-cache-dir $PACKAGE "$@"
    else
        # No additional arguments provided
        echo "Installing $PACKAGE..."
        sudo_if /usr/local/python/current/bin/python -m pip install --user --upgrade --no-cache-dir $PACKAGE
    fi
}

if [[ "$(python --version)" != "" ]] && [[ "$(pip --version)" != "" ]]; then
    # install_python_package "numpy"
    # install_python_package "pandas"
    # install_python_package "scipy"
    # install_python_package "matplotlib"
    # install_python_package "seaborn"
    # install_python_package "scikit-learn"
    install_python_package "torch" -f https://download.pytorch.org/whl/cpu/torch_stable.html
    # install_python_package "requests"
    # install_python_package "plotly"
else
    "(*) Error: Need to install python and pip."
fi

INSTALL_TORCH_FOR_GPU="/usr/local/share/installTorchForGPU.sh"

# Save the script to INSTALL_TORCH_FOR_GPU
cat << 'EOF' > "$INSTALL_TORCH_FOR_GPU"
#!/bin/bash

echo -e "\nAttempting to install Torch with GPU Acceleration if NVIDIA GPU is available..\n"
USERNAME="codespace"

sudo_if() {
    COMMAND="$*"
    if [ "$(id -u)" -eq 0 ] && [ "$USERNAME" != "root" ]; then
        su - "$USERNAME" -c "$COMMAND"
    else
        "$COMMAND"
    fi
}

install_torch_package() {
    cd ..
    echo "Current working directory: $(pwd)"
    sudo_if /python/current/bin/python -m pip uninstall --yes torch
    echo "Installing $PACKAGE..."
    sudo_if /python/current/bin/python -m pip install --user --upgrade --no-cache-dir torch
}

# Check if lspci is available
if ! command -v lspci &> /dev/null; then
    echo -e "\nlspci not found. Attempting to install pciutils...\n"
    sudo apt-get update
    sudo apt-get install -y pciutils
fi

set +e
GPU=$(lspci | grep -i NVIDIA || true)  # Used `|| true` to prevent script from exiting on grep failure
set -e

install_torch_package

if [ -n "$GPU" ]; then
    echo "GPU Detected. Installing Torch with GPU support."
    install_torch_package
else 
    echo "GPU Not Detected. Torch without GPU Acceleration is already installed."
fi

EOF

chmod 755 "$INSTALL_TORCH_FOR_GPU"

set -x

# Get the container ID of the current running container
CONTAINER_ID=$(cat /proc/self/cgroup | grep "docker" | sed s/\\//\\n/g | tail -1)

IMAGE_NAME=$(docker inspect --format='{{.Config.Image}}' "$CONTAINER_ID")

echo $IMAGE_NAME

echo $CONTAINER_ID  

set +x

echo "Done!"