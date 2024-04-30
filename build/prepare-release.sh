#!/bin/bash

# This script is used to prepare a release of the dev containers.
# It will bump the version of the manifest.json file and run the devcontainer upgrade command.
# It will only run on the images that have been modified since the last release.
# If no commit hash (of last release) is provided, it will run in monthly release mode and bump the version of all images.
# Example adhoc release: ./build/prepare-release.sh 1c6f558dc86aafd7749074ec44e238f331303517
# Example monthly release: ./build/prepare-release.sh


SCRIPT_SOURCE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
SRC_DIR=$(readlink -m $SCRIPT_SOURCE_DIR/../src)
MANIFEST_FILE="manifest.json"
COMMIT_HASH=$1

get_modified_images() {
	git diff --name-only --diff-filter=ACMRTUB ${COMMIT_HASH} HEAD ${SRC_DIR} | while read file; do
		if [ ! -z $file ]; then
			commitMessage=$(git log -1 $file)
			# omit auto commits from bot
			if [[ $commitMessage != *"Dev containers Bot"* ]]; then
				# only get the top level directory for the image
				if [ $(echo $file | tr "/" "\n" | wc -l) -eq 3 ]; then
					readlink -m $(dirname $file)
				fi
			fi
		fi
	done | sort | uniq
}

get_all_images() {
	find $SRC_DIR -maxdepth 1 -type d | tail -n +2 | sort | uniq
}

bump_version() {
	directory=$1
	manifestPath="$directory/$MANIFEST_FILE"
	version=$(grep -oP '(?<="version": ")[^"]*' $manifestPath)
	newVersion=$(echo $version | awk -F. -v OFS=. '{$NF += 1 ; print}')
	sed -i "s/\"version\": \"$version\"/\"version\": \"$newVersion\"/g" $manifestPath
}

release_image() {
	image=$1
	echo "-----------------------------------------------"
	echo "Releasing image $image"
	echo "-----------------------------------------------"

	bump_version $image

	rm "${image}/.devcontainer/devcontainer-lock.json"
	devcontainer upgrade --workspace-folder $image
}

adhoc_release() {
    for image in $(get_modified_images); do
        release_image $image
    done
}

monthly_release() {
    for image in $(get_all_images); do
        release_image $image
    done
}

main() {
	if [ "$COMMIT_HASH" == "" ]; then
		echo "No commit hash provided, running in monthly release mode"
		monthly_release
	else
		adhoc_release
	fi
}

main
