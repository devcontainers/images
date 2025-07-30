#/bin/bash
IMAGE="$1"
THRESHOLD_IN_GB="$2"

source $(pwd)/.github/actions/smoke-test/check-image-size.sh

export DOCKER_BUILDKIT=1
set -e

# Run actual test
echo "(*) Running test..."
id_label="test-container=${IMAGE}"
id_image="${IMAGE}-test-image"
devcontainer exec --workspace-folder $(pwd)/src/$IMAGE  --id-label ${id_label} /bin/sh -c 'set -e && if [ -f "test-project/test.sh" ]; then cd test-project && if [ "$(id -u)" = "0" ]; then chmod +x test.sh; else sudo chmod +x test.sh; fi && ./test.sh; else ls -a; fi'

echo "(*) Docker image details..."
docker images
# Checking size of universal image

if [ $IMAGE == "universal" ]; then
    check_image_size $IMAGE $THRESHOLD_IN_GB $id_image
fi

# Clean up
docker rm -f $(docker container ls -f "label=${id_label}" -q)
