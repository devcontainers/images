#!/bin/bash
IMAGE="$1"

set -e

export DOCKER_BUILDKIT=1
echo "(*) Installing @devcontainer/cli@0.8.0"
# npm install -g @devcontainers/cli@0.8.0
cd build 
chmod +x devcontainers-cli-0.9.1-1.tgz

echo "(*) Building image - ${IMAGE}"
npx --yes devcontainers-cli-0.9.1-1.tgz up --workspace-folder ../src/${IMAGE}

# devcontainer up --workspace-folder "src/${IMAGE}/"
