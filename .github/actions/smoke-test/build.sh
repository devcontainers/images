#!/bin/bash
IMAGE="$1"

set -e

export DOCKER_BUILDKIT=1
echo "(*) Installing @devcontainer/cli"
npm install -g @devcontainers/cli

echo "(*) Building image - ${IMAGE}"
id_label="test-container=${IMAGE}"
devcontainer up --id-label ${id_label} --workspace-folder "src/${IMAGE}/"
