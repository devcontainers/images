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
	
	# Also update version references in README.md
	update_readme_version $directory $version $newVersion
}

update_readme_version() {
	directory=$1
	oldVersion=$2
	newVersion=$3
	readmePath="$directory/README.md"
	
	if [ ! -f "$readmePath" ]; then
		echo "No README.md found at $readmePath, skipping README update"
		return
	fi
	
	# Extract major.minor from the version
	majorMinor=$(echo "$oldVersion" | cut -d. -f1,2)
	
	# Check if major.minor version pattern exists in README
	# Match :major.minor.patch followed by either - or ` (backtick) or end of word
	if ! grep -qE ":${majorMinor}\.[0-9]+[-\`]" "$readmePath"; then
		echo "ERROR: Version pattern ${majorMinor}.x not found in $readmePath"
		exit 1
	fi
	
	# Update full version references (e.g., 1.3.x-variant -> 1.3.3-variant, or 1.3.x` -> 1.3.3`)
	# The pattern matches major.minor.any_patch followed by - (variant) or ` (backtick)
	# We match after : (full image reference) or after ` (shortened tag examples)
	sed -i "s/:${majorMinor}\.[0-9]*-/:${newVersion}-/g" $readmePath
	sed -i "s/:${majorMinor}\.[0-9]*\`/:${newVersion}\`/g" $readmePath
	sed -i "s/\`${majorMinor}\.[0-9]*-/\`${newVersion}-/g" $readmePath
	
	echo "Updated README.md version references from ${majorMinor}.x to $newVersion"
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
