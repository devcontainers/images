#!/bin/bash
DEFINITION="$1"

set -e

export DOCKER_BUILDKIT=1
echo "(*) Pulling latest '@devcontainer/cli"
npm install -g @devcontainers/cli

echo "(*) Building image - ${DEFINITION}"
devcontainer build --workspace-folder "src/${DEFINITION}/" --image-name vsc-${DEFINITION}
