#!/bin/bash
DEFINITION="$1"

set -e

export DOCKER_BUILDKIT=1

# Symlink build scripts from main to improve security when testing PRs
if [ -d "$GITHUB_WORKSPACE/__build/build" ]; then
    cp -r "$GITHUB_WORKSPACE/__build/build" "$GITHUB_WORKSPACE/"
else
    echo "WARNING: Using build/vscdc from $GITHUB_REF instead of main."
fi

# Build the image
chmod +x build/devcontainers-cli.tgz
npx --yes build/devcontainers-cli.tgz build --workspace-folder src/${DEFINITION} --image-name vsc-${DEFINITION}

docker images
