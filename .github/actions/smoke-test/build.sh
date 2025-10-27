#!/bin/bash
IMAGE="$1"
VALIDATE_TAGS="${INPUT_VALIDATE_TAGS:-true}"

set -e

export DOCKER_BUILDKIT=1
echo "(*) Installing @devcontainer/cli"
npm install -g @devcontainers/cli

# Validate base image tags before building (if enabled)
if [[ "$VALIDATE_TAGS" == "true" ]]; then
    echo "(*) Validating base image tags for ${IMAGE}..."
    "$(dirname "$0")/validate-tags.sh" "$IMAGE"
else
    echo "(*) Skipping tag validation (validate-tags=false)"
fi

id_label="test-container=${IMAGE}"
id_image="${IMAGE}-test-image"
echo "(*) Building image - ${IMAGE}"
devcontainer build --image-name ${id_image} --workspace-folder "src/${IMAGE}/"
echo "(*) Starting container - ${IMAGE}"
devcontainer up --id-label ${id_label} --workspace-folder "src/${IMAGE}/"

