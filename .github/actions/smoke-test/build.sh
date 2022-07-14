#!/bin/bash
IMAGE="$1"

set -e

export DOCKER_BUILDKIT=1
echo "(*) Pulling latest '@devcontainer/cli"
# npm install -g @devcontainers/cli

#Temporarily installing cli from source until https://github.com/devcontainers/cli/pull/6 is merged
cd build 
chmod +x devcontainers-cli-0.6.4.tgz

echo "(*) Building image - ${IMAGE}"
npx --yes devcontainers-cli-0.6.4.tgz up --workspace-folder ../src/${IMAGE}
# devcontainer build --workspace-folder "src/${IMAGE}/" --image-name vsc-${IMAGE}

