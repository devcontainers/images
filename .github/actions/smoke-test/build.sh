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

squash_universal_image="$(node -p "require('./build/config.json').squashUniversalImage === true")"
if [[ -n "${SQUASH_UNIVERSAL_IMAGE+x}" ]]; then
    squash_universal_image="$(echo "${SQUASH_UNIVERSAL_IMAGE}" | tr '[:upper:]' '[:lower:]')"
fi

if [[ "${IMAGE}" == "universal" && "${squash_universal_image}" == "true" ]]; then
    squashed_image="${id_image}-squashed"
    echo "(*) Squashing image - ${IMAGE}"
    docker-squash --tag "${squashed_image}" "${id_image}"
    docker tag "${squashed_image}" "${id_image}"
    docker image rm "${squashed_image}"
fi

echo "(*) Starting container - ${IMAGE}"
devcontainer up --id-label ${id_label} --workspace-folder "src/${IMAGE}/"

