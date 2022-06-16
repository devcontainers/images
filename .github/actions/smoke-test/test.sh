#/bin/bash
DEFINITION="$1"
IMAGE="$2"
USERNAME="$3"

export DOCKER_BUILDKIT=1
set -e

# List docker images
echo "(*) Listing docker images..."
docker images


# Update UID/GID for user in container - Actions uses different UID/GID than container
# which causes bind mounts to be read only and cause certain write tests to fail
# The dev container CLI handles this automatically but we're not using it.
local_uid=$(id -u)
local_gid=$(id -g)
if [ "${DEFINITION}" = "codespaces" ]; then
    local_uid=1000
    local_gid=1000
fi

echo "(*) Updating container user UID/GID..."
echo -e "FROM ${IMAGE}\n \
    RUN export sudo_cmd="" \
    && if [ "$(id -u)" != "0" ]; then export sudo_cmd=sudo; fi \
    && \${sudo_cmd} groupmod -g ${local_gid} ${USERNAME} \
    && \${sudo_cmd} usermod -u ${local_uid} -g ${local_gid} ${USERNAME}" > uid.Dockerfile
cat uid.Dockerfile
docker build -t ${IMAGE}-uid -f uid.Dockerfile .

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