#!/bin/bash

# Find and install packages, if required, using conda channel or using pip package manager
vulnerable_packages=( "pydantic=2.5.3" "joblib=1.3.1" "mistune=3.0.1" "werkzeug=3.0.3" "transformers=4.36.0" "pillow=10.3.0" "aiohttp=3.9.4" \
          "cryptography=42.0.4" "gitpython=3.1.41"  "jupyter-lsp=2.2.2" "idna=3.7" "jinja2=3.1.4" "scrapy=2.11.2" )

# Define the number of rows (based on the length of vulnerable_packages)
rows=${#vulnerable_packages[@]}

# Define the number of columns
cols=4

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

value=0
insert_in_2D_array() {
    local package_name=$1
    local channel_name="anaconda"

    echo "Running conda search for package '$package_name' in channel '$channel_name'..."
    
    # Capture the conda search output and process it
    latest_version=$(conda search "$package_name" -c "$channel_name" | \
        grep -E '^[[:alnum:]]' | \
        awk '{print $2}' | \
        sort -V | \
        uniq | \
        tail -n 2 | \
        head -n 1)

    found_version=$(pip show $package_name | grep '^Version:' | awk '{print $2}')
    if [[ -z "$latest_version" ]]; then
        echo "No version found in anaconda channel."
        latest_version="0"
    fi
    if [[ -z "$found_version" ]]; then 
        echo "No package version found in upstream."
        found_version="0"
    fi
    echo "Latest version of $package_name on Conda Channel: $latest_version"
    packages_array[$i,2]="$found_version"
    packages_array[$i,3]="$latest_version"
    ((value++))
}

# store found package versions in upstream as 3rd column element in 2D array
check_packages_anaconda_channel() {
    for ((i=0; i<rows; i++)); do
        PACKAGE_NAME=${packages_array[$i,0]}
        echo "Package Name $i: $PACKAGE_NAME"
        insert_in_2D_array $PACKAGE_NAME
    done
}

compare_and_install_packages() {
    check_packages_anaconda_channel
    printf "%-10s %-10s %-10s %-10s\n" "Package Name," "Version needed," "Version Present," "Conda channel version"
    echo "---------------------------------------------------------------------------------"
    for ((i=0; i<rows; i++)); do
        for ((j=0; j<cols; j++)); do
            echo -n "${packages_array[$i,$j]} "
        done
        echo
    done
    for ((i=0; i<rows; i++)); do
        echo -e "\nComparing semver versions between required and present currently for ${packages_array[$i,0]}"
        comparison_result=$(compare_semver "${packages_array[$i,1]}" "${packages_array[$i,2]}")
        if [[ $comparison_result == "greater" ]]; then
            echo -e "\n${packages_array[$i,0]} : ${packages_array[$i,1]} > ${packages_array[$i,2]}"
            echo -e "\nComparing semver versions between required and available through conda channel for ${packages_array[$i,0]}"
            comparison_result2=$(compare_semver "${packages_array[$i,1]}" "${packages_array[$i,3]}")
            if [[ $comparison_result2 == "greater" ]]; then
                echo -e "\n${packages_array[$i,0]} : ${packages_array[$i,1]} > ${packages_array[$i,3]}"
                echo -e "\nInstalling ${packages_array[$i,0]} using pip"
                python3 -m pip install --upgrade "${packages_array[$i,0]}==${packages_array[$i,1]}"
            else 
                echo -e "\n${packages_array[$i,0]} : ${packages_array[$i,1]} < ${packages_array[$i,3]}"
                echo -e "\nInstalling ${packages_array[$i,0]} using conda channel"
                conda install "${packages_array[$i,0]}==${packages_array[$i,3]}"
            fi
        else 
            echo -e "No need to update ${packages_array[$i,0]}";
        fi
    done
}

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

compare_and_install_packages
