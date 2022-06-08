#/bin/bash
DEFINITION="$1"
IMAGE="$2"
USERNAME="$3"

# Run test script for image if one exists

export DOCKER_BUILDKIT=1

if [ "${IMAGE}" = "none" ]; then
    echo "Image not specified. Aborting test."
    exit 0
fi

set -e

# Run actual test
echo "(*) Running test..."
cd build
chmod +x devcontainers-cli-0.3.0.tgz

npx --yes devcontainers-cli-0.3.0.tgz exec --workspace-folder $(pwd)/../src/$DEFINITION /bin/sh -c 'set -e && if [ -f "test-project/test.sh" ]; then cd test-project && if [ "$(id -u)" = "0" ]; then chmod +x test.sh; else sudo chmod +x test.sh; fi && ./test.sh; else ls -a; fi'

# Clean up
docker stop $(docker container ls -q)