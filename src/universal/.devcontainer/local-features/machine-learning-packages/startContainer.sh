#!/bin/bash

# Define the image name prefix to filter (e.g., vsc-universal)
IMAGE_PREFIX="vsc-universal"

# Use docker ps to list running containers, filter by image name prefix,
# and extract container ID
CONTAINER_ID=$(docker ps --format "{{.ID}} {{.Image}}" | grep "$IMAGE_PREFIX" | awk '{print $1}')

if [ -z "$CONTAINER_ID" ]; then
    echo "No container found with image name starting with '$IMAGE_PREFIX'."
else
    echo "Container ID with image name starting with '$IMAGE_PREFIX': $CONTAINER_ID"
    docker start "$CONTAINER_ID"
    docker exec -it "$CONTAINER_ID" bash -c "/usr/local/share/installTorchForGPU.sh"
fi