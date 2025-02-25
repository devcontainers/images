#!/bin/bash

# Pass image name to upgrade only a single image, else it upgrades all the images
IMAGE_NAME=$1
workspaceFolder="/workspaces/images/src"

if [ ! -z "$IMAGE_NAME" ]; then
  echo "-----------------------------------------------"
	echo "Upgrading image $IMAGE_NAME"
	echo "-----------------------------------------------"
  devcontainer upgrade --workspace-folder "${workspaceFolder}/${IMAGE_NAME}/"
  exit 0
fi

for dir in /workspaces/images/src/*/
do
  cd "${dir}"
  image=$(basename $dir)
  echo "-----------------------------------------------"
  echo "Upgrading image $image"
  echo "-----------------------------------------------"
  devcontainer upgrade --workspace-folder .
  cd ..
done