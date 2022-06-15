#!/bin/bash
DEFINITION="$1"

set -e

export DOCKER_BUILDKIT=1
echo "(*) Pulling latest '@devcontainer/cli"

docker ps -a
docker images
docker system prune --force
docker ps -a
docker images
# npm install -g @devcontainers/cli

#Temporarily installing cli from source until https://github.com/devcontainers/cli/pull/6 is merged
cd build 
chmod +x devcontainers-cli-0.3.0-1.tgz

echo "(*) Building image - ${DEFINITION}"
npx --yes devcontainers-cli-0.3.0-1.tgz up --workspace-folder ../src/${DEFINITION}
# devcontainer build --workspace-folder "src/${DEFINITION}/" --image-name vsc-${DEFINITION}
