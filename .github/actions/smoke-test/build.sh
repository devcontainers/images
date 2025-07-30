#!/bin/bash
IMAGE="$1"

set -e

export DOCKER_BUILDKIT=1
echo "(*) Installing @devcontainer/cli"
npm install -g @devcontainers/cli

id_label="test-container=${IMAGE}"
id_image="${IMAGE}-test-image"
echo "(*) Building image - ${IMAGE}"
devcontainer build --image-name ${id_image} --workspace-folder "src/${IMAGE}/"
echo "(*) Starting container - ${IMAGE}"
devcontainer up --id-label ${id_label} --workspace-folder "src/${IMAGE}/"

