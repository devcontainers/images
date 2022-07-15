#!/bin/bash
IMAGE="$1"

set -e

export DOCKER_BUILDKIT=1
echo "(*) Installing @devcontainer/cli@0.8.0"
npm install -g @devcontainers/cli@0.8.0

echo "(*) Building image - ${IMAGE}"
devcontainer up --workspace-folder "src/${IMAGE}/"
