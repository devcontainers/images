#!/bin/bash

vulnerable_packages=( "pydantic=2.5.3" "joblib=1.3.1" "mistune=3.0.1" "werkzeug=3.0.3" "transformers=4.36.0" "pillow=10.3.0" "aiohttp=3.9.4" \
          "cryptography=42.0.4" "gitpython=3.1.41"  "jupyter-lsp=2.2.2" "idna=3.7" "jinja2=3.1.4" "scrapy=2.11.2" )

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

# Function to compare semver versions
compare_semver() {
    # Split versions into arrays
    IFS='.' read -r -a version1 <<< "$1"
    IFS='.' read -r -a version2 <<< "$2"

    comparison=""
    # Compare MAJOR version
    if (( ${version1[0]} > ${version2[0]} )); then
        comparison="greater"
    elif (( ${version1[0]} < ${version2[0]} )); then
        comparison="lesser"
    else
        # Compare MINOR version
        if (( ${version1[1]} > ${version2[1]} )); then
            comparison="greater"
        elif (( ${version1[1]} < ${version2[1]} )); then
            comparison="lesser"
        else
            # Compare PATCH version
            if (( ${version1[2]} > ${version2[2]} )); then
                comparison="greater"
            elif (( ${version1[2]} < ${version2[2]} )); then
                comparison="lesser"
            else
                comparison="equal"
            fi
        fi
    fi

    echo $comparison
}

for ((i=0; i<rows; i++)); do
    CURRENT_VERSION=$(pip show "${packages_array[$i,0]}" | grep '^Version:' | awk '{print $2}')
    if [[ -z "$CURRENT_VERSION" ]]; then
        echo "No version for ${packages_array[$i,0]} found in upstream i.e. base image."
        CURRENT_VERSION="0"
    fi
    REQUIRED_VERSION="${packages_array[$i,1]}"
    comparison_result=$(compare_semver "${REQUIRED_VERSION}" "${CURRENT_VERSION}")
    # Check if the current version installed is greater or equal to the required version
    if [[ $comparison_result == "greater" ]]; then
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
        comparison_result2=$(compare_semver "${REQUIRED_VERSION}" "${CONDA_VERSION}")
        if [[ $comparison_result2 == "lesser" ]] || [[ $comparison_result2 == "equal" ]]; then
            echo -e "Greater version between required version: v${REQUIRED_VERSION} and conda version: v${CONDA_VERSION} is conda version: v${CONDA_VERSION}\n";
            echo "Installing ${packages_array[$i,0]} from source from conda channel for ${REQUIRED_VERSION}..."
            conda install "${packages_array[$i,0]}==${CONDA_VERSION}"
        else 
            echo -e "Greater version between required version: v${REQUIRED_VERSION} and conda version: v${CONDA_VERSION} is the required version: v${REQUIRED_VERSION}\n";
            echo "Installing ${packages_array[$i,0]} from source from pip package manager for ${REQUIRED_VERSION}..."
            python3 -m pip install --upgrade "${packages_array[$i,0]}==${REQUIRED_VERSION}"
        fi
    fi
done