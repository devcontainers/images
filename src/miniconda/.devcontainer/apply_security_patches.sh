#!/bin/bash

# vulnerablities 
# cryptography - [GHSA-h4gh-qq45-vh27]

# define array of packages for pinning to the patched versions
# vulnerable_packages=( "package1=version1" "package2=version2" "package3=version3" )
vulnerable_packages=()

# Define the number of rows (based on the length of vulnerable_packages)
rows=${#vulnerable_packages[@]}

if [ $rows -gt 0 ]; then
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
            if [[ $CONDA_VERSION == $GREATER_VERSION_B ]]; then
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
fi
