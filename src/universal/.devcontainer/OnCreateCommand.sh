#!/bin/bash

if ! command -v jq &> /dev/null; then 
    echo "jq not found. Attempting to install..."; 
    sudo apt-get update; 
    sudo apt-get install -y jq; 
fi; 

# Read JSON data from file and remove comments using sed
json=$(sed '/^\s*\/\//d' "./.devcontainer/devcontainer.json")

# Extract the value corresponding to "./local-features/machine-learning-packages"
machine_learning_packages_key_value=$(echo "$json" | jq -r '.features | to_entries[] | select(.key == "./local-features/machine-learning-packages") | .value')
# Check if the extracted value is not null
if [ ! -z "${machine_learning_packages_key_value}" ]; then
    # Extract the username value from the extracted JSON object
    username_value=$(echo "$json" | jq -r '.features."./local-features/machine-learning-packages" // empty | .username // empty')
    # Check if the username value is empty
    if [ ! -z "${username_value}" ]; then
        # Username value is not empty;
        use_username="${username_value}";
    else 
        use_username="codespace";
    fi

    sudo_if() {
        COMMAND="$*"
        if [ "$(id -u)" -eq 0 ] && [ "$use_username" != "root" ]; then
            su - "$use_username" -c "$COMMAND"
        else
            $COMMAND
        fi
    }

    export PATH="$PATH:/root/.local/bin"; 
    install_python_package() {
        PACKAGE=${1:-""}
        shift  # Remove the first argument (PACKAGE) from the list of arguments
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

    sudo mkdir -p /var/lib/apt/lists/partial
    sudo chown -R root:root /var/lib/apt/lists
    sudo chmod -R 755 /var/lib/apt/lists

    if ! command -v lspci &> /dev/null; then 
        echo "lspci not found. Attempting to install...";  
        sudo apt-get update;
        sudo apt-get install -y pciutils; 
    fi; 

    set +e; 
    GPU=$(lspci | grep -i NVIDIA); 
    set -e; 

    if [ -n "$GPU" ]; then 
        echo "GPU Detected. Installing Torch with GPU support."; 
        install_python_package torch
    else 
        echo "No GPU Detected. Installing Torch with CPU support.";  
        install_python_package torch -f https://download.pytorch.org/whl/cpu/torch_stable.html; 
    fi; 

fi;