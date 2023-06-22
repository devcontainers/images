#/bin/bash
IMAGE="$1"

export DOCKER_BUILDKIT=1
set -e

# Run actual test
echo "(*) Running test..."
id_label="test-container=${IMAGE}"
devcontainer exec --workspace-folder $(pwd)/src/$IMAGE  --id-label ${id_label} /bin/sh -c 'set -e && if [ -f "test-project/test.sh" ]; then cd test-project && if [ "$(id -u)" = "0" ]; then chmod +x test.sh; else sudo chmod +x test.sh; fi && ./test.sh; else ls -a; fi'

echo "(*) Docker image details..."
docker images

# Clean up
docker rm -f $(docker container ls -f "label=${id_label}" -q)
