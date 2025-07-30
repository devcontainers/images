#!/bin/bash

# vulnerabilities:
# werkzeug - [GHSA-f9vj-2wh5-fj8j]

vulnerable_packages=( "mistune=3.0.1" "transformers=4.49.0" "cryptography=43.0.3" "jupyter-lsp=2.2.2" "scrapy=2.11.2" \ 
                      "zipp=3.19.1" "tornado=6.4.2")

# Define the number of rows (based on the length of vulnerable_packages)
rows=${#vulnerable_packages[@]}

# Define the number of columns
cols=2

# Define the 2D array
declare -A packages_array

# Fill the 2D array
for ((i=0; i<rows; i++)); do
    # Split each element of vulnerable_packages by the '=' sign
    IFS='=' read -ra parts <<< "${vulnerable_packages[$i]}"
    # Assign the parts to the 2D array
    packages_array[$i,0]=${parts[0]}
    packages_array[$i,1]=${parts[1]}
done

# Add an array for packages that should always pin to the provided version, 
# even if higher version is available in conda channel
pin_to_required_version=( "transformers" "cryptography" ) # Add package names as needed

# Function to check if a package is in the pin_to_required_version array
function is_pin_to_required_version() {
    local pkg="$1"
    for item in "${pin_to_required_version[@]}"; do
        if [[ "$item" == "$pkg" ]]; then
            return 0
        fi
    done
    return 1
}

for ((i=0; i<rows; i++)); do
    CURRENT_VERSION=$(pip show "${packages_array[$i,0]}" --disable-pip-version-check | grep '^Version:' | awk '{print $2}')
    REQUIRED_VERSION="${packages_array[$i,1]}"
    GREATER_VERSION_A=$((echo ${REQUIRED_VERSION}; echo ${CURRENT_VERSION}) | sort -V | tail -1)
    # Check if the required_version is greater than current_version
    if [[ $CURRENT_VERSION != $GREATER_VERSION_A ]]; then
        echo "${packages_array[$i,0]} version v${CURRENT_VERSION} installed by the base image is not greater or equal to the required: v${REQUIRED_VERSION}"
        # Check whether conda channel has a greater or equal version available, so install from conda, otherwise use pip package manager
        channel_name="anaconda"
        CONDA_VERSION=$(conda search "${packages_array[$i,0]}" -c "$channel_name" | \
            grep -E '^[[:alnum:]]' | \
            awk '{print $2}' | \
            sort -V | \
            uniq | \
            tail -n 2 | \
            head -n 1)
        if [[ -z "$CONDA_VERSION" ]]; then
            echo "No version for ${packages_array[$i,0]} found in conda channel."
            CONDA_VERSION="0"
        fi
        GREATER_VERSION_B=$((echo ${REQUIRED_VERSION}; echo ${CONDA_VERSION}) | sort -V | tail -1)
        if is_pin_to_required_version "${packages_array[$i,0]}"; then
            echo -e "Package ${packages_array[$i,0]} is set to always use the required version: v${REQUIRED_VERSION}.\n";
            echo "Installing ${packages_array[$i,0]} from pip for v${REQUIRED_VERSION}..."
            python3 -m pip install --upgrade --no-cache-dir "${packages_array[$i,0]}==${REQUIRED_VERSION}"
        elif [[ $CONDA_VERSION == $GREATER_VERSION_B ]]; then        
            echo -e "Found Version v${CONDA_VERSION} in the Conda channel which is greater than or equal to the required version: v${REQUIRED_VERSION}. \n";
            echo "Installing ${packages_array[$i,0]} from source from conda channel for v${REQUIRED_VERSION}..."
            conda install "${packages_array[$i,0]}==${CONDA_VERSION}"        
        elif [[ $REQUIRED_VERSION == $GREATER_VERSION_B ]]; then 
            echo -e "Required version: v${REQUIRED_VERSION} is greater than the version found in the Conda channel v${CONDA_VERSION}. \n";
            echo "Installing ${packages_array[$i,0]} from source from pip package manager for v${REQUIRED_VERSION}..."
            python3 -m pip install --upgrade --no-cache-dir "${packages_array[$i,0]}==${REQUIRED_VERSION}"
        fi
    fi
done
