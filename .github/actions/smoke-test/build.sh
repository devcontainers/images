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

    override_config="${RUNNER_TEMP}/universal-squashed.devcontainer.json"
    printf '{ "image": "%s" }\n' "${id_image}" > "${override_config}"

    echo "(*) Squashed image launch configuration"
    cat "${override_config}"
    docker image inspect --format 'ID={{.Id}} Layers={{len .RootFS.Layers}} Config={{json .Config}}' "${id_image}"

    echo "(*) Starting container from squashed image - ${IMAGE}"
    echo "(*) Using override configuration: ${override_config}"
    devcontainer up \
        --id-label "${id_label}" \
        --workspace-folder "src/${IMAGE}/" \
        --override-config "${override_config}"

    container_id="$(docker container ls -q --filter "label=${id_label}")"
    if [[ -z "${container_id}" ]]; then
        echo "Could not find the universal test container."
        exit 1
    fi

    expected_image_id="$(docker image inspect --format '{{.Id}}' "${id_image}")"
    actual_image_id="$(docker container inspect --format '{{.Image}}' "${container_id}")"
    configured_image="$(docker container inspect --format '{{.Config.Image}}' "${container_id}")"

    echo "(*) Universal test container details"
    echo "Container ID: ${container_id}"
    echo "Configured image: ${configured_image}"
    echo "Expected image ID: ${expected_image_id}"
    echo "Actual image ID: ${actual_image_id}"
    docker container inspect --format 'Config={{json .Config}}' "${container_id}"
    docker image inspect --format 'ID={{.Id}} Layers={{len .RootFS.Layers}} Config={{json .Config}}' "${actual_image_id}"
    devcontainer exec --id-label "${id_label}" --workspace-folder "src/${IMAGE}/" /bin/sh -c 'echo "Remote user: $(id -un) ($(id -u):$(id -g))"' || true

    #if [[ "${actual_image_id}" != "${expected_image_id}" ]]; then
    #    echo "Test container is not using the squashed ${id_image} image."
    #    exit 1
    #fi
else
    echo "(*) Starting container - ${IMAGE}"
    devcontainer up --id-label "${id_label}" --workspace-folder "src/${IMAGE}/"
fi

