#!/bin/bash
IMAGE="$1"

set -e

export DOCKER_BUILDKIT=1
echo "(*) Installing @devcontainer/cli"
cd build 
chmod +x devcontainers-cli-0.9.1.tgz

# npm install -g @devcontainers/cli

echo "(*) Building image - ${IMAGE}"
npx --yes devcontainers-cli-0.9.1.tgz up --workspace-folder ../src/${IMAGE}  --id-label name="${IMAGE}"
# devcontainer up --workspace-folder "src/${IMAGE}/" --id-label name="${IMAGE}"
