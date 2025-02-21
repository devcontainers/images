#!/bin/bash

set -e

# Function to handle errors
handle_error() {
    local exit_code=$?
    local line_number=$1
    local command=$2
    echo "Error occurred at line $line_number with exit code $exit_code in command $command"
    exit $exit_code
}
trap 'handle_error $LINENO ${BASH_COMMAND%% *}' ERR

convert_gb_to_bytes() {
    local gb="$1"
    local bytes
    bytes=$(echo "scale=0; $gb * 1024^3" | bc)
    printf "%.0f\n" "$bytes"
}

# Check if bc is installed
install_bc() {
    if ! command -v bc &> /dev/null; then
        echo "bc is not installed. Installing..."
        # Install bc using apt-get (for Debian-based systems)
        sudo apt-get update
        sudo apt-get install -y bc
    fi
}

check_image_size() {
    IMAGE="$1"
    THRESHOLD_IN_GB="$2"
    id_image="$3"
    # call install_bc
    install_bc

    #Read the image id of the original image, not the modified image with uid and gid
    IMAGE_ID=$(docker images -q  --filter=reference="$id_image")   
    # Find the size of the image
    IMAGE_SIZE=$(docker image inspect --format='{{.Size}}' "$IMAGE_ID")
    # Output the size
    echo "Size of the image $IMAGE_ID: $IMAGE_SIZE bytes"
    threshold=$(convert_gb_to_bytes "$THRESHOLD_IN_GB")
    # Retrieve the Docker image size
    echo -e "\nThreshold is $threshold bytes ie $THRESHOLD_IN_GB GB"
    # Remove the 'MB' from the size string and convert to an integer
    image_size=${IMAGE_SIZE%bytes}
    image_size=${image_size//.}
    # Check if the image size is above the threshold
    echo -e "\n🧪 Checking image size of $IMAGE :"
    if [ -n $image_size  ] && [ $image_size -gt $threshold ]; then
        echo -e "\nImage size exceeds the threshold of $THRESHOLD_IN_GB gb"
        echo -e "\n❌ Image size check failed."
        exit 1;
    else
        echo -e "\n✅  Passed!"
    fi
}
