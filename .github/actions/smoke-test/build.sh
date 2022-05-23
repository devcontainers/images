#!/bin/bash
DEFINITION="$1"

set -e

export DOCKER_BUILDKIT=1
echo "Building image - ${DEFINITION}"
chmod +x build/devcontainers-cli.tgz
cd build
npx --yes devcontainers-cli.tgz build --workspace-folder "../src/${DEFINITION}/" --image-name vsc-${DEFINITION}
