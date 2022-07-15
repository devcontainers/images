#/bin/bash
IMAGE="$1"

export DOCKER_BUILDKIT=1
set -e

# Run actual test
echo "(*) Running test..."

devcontainer exec --workspace-folder $(pwd)/src/$IMAGE /bin/sh -c 'set -e && if [ -f "test-project/test.sh" ]; then cd test-project && if [ "$(id -u)" = "0" ]; then chmod +x test.sh; else sudo chmod +x test.sh; fi && ./test.sh; else ls -a; fi'

# Clean up
docker stop $(docker container ls -q)
