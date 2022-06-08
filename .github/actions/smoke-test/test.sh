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

# Start container
echo "(*) Starting container..."
container_name="vscdc-test-container-$DEFINITION"
docker run -it -d --name ${container_name} --rm --init --privileged -v "$(pwd)/src/${DEFINITION}:/workspace" ${IMAGE} bash

# Run actual test
echo "(*) Running test..."
docker exec -u "${USERNAME}" ${container_name} /bin/sh -c '\
    set -e \
    && cd /workspace \
    && if [ -f "test-project/test.sh" ]; then \
    cd test-project \
    && if [ "$(id -u)" = "0" ]; then \
        chmod +x test.sh; \
    else \
        sudo chmod +x test.sh; \
    fi \
    && ./test.sh; \
    else \
    ls -a; 
    fi'

# Clean up
docker rm -f ${container_name}