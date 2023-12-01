#!/bin/bash

for dir in ./src/*/ ; do
    if [ -d "$dir" ]; then
        echo "Upgrading devcontainer lockfiles for '$dir'"
        devcontainer upgrade --workspace-folder "$dir"
    fi
done