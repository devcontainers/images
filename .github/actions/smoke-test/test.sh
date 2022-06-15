#/bin/bash
DEFINITION="$1"
IMAGE="$2"
USERNAME="$3"

export DOCKER_BUILDKIT=1
set -e

docker images

# Start container
echo "(*) Starting container..."
container_name="vscdc-test-container-$DEFINITION"
docker run -d --name ${container_name} --rm --init --privileged -v "$(pwd)/src/${DEFINITION}:/workspace" ${IMAGE}-uid /bin/sh -c 'while sleep 1000; do :; done'

# Run actual test
echo "(*) Running test..."
docker exec -u "${USERNAME}" ${container_name} /bin/sh -c  '\
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