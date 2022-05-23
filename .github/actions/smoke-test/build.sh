#!/bin/bash
DEFINITION="$1"

set -e

export DOCKER_BUILDKIT=1

# Build the image
chmod +x build/devcontainers-cli.tgz
npx --yes build/devcontainers-cli.tgz build --workspace-folder src/${DEFINITION} --image-name vsc-${DEFINITION}

docker images
