#!/bin/bash
DEFINITION="$1"

set -e

export DOCKER_BUILDKIT=1
echo "(*) Pulling latest '@devcontainer/cli"
# npm install -g @devcontainers/cli

#Temporarily installing cli from source until https://github.com/devcontainers/cli/pull/6 is merged 
chmod +x build/devcontainers-cli-0.3.0.tgz

echo "(*) Building image - ${DEFINITION}"
npx --yes build/devcontainers-cli-0.3.0.tgz build --workspace-folder src/${DEFINITION} --image-name vsc-${DEFINITION}
# devcontainer build --workspace-folder "src/${DEFINITION}/" --image-name vsc-${DEFINITION}
