#!/bin/bash
cd $(dirname "$0")

source test-utils-alpine.sh vscode

# Run common tests
checkCommon

check "git" git --version

git_version_satisfied=false
if (echo a version 2.38.1; git --version) | sort -Vk3 | tail -1 | grep -q git; then
    git_version_satisfied=true
fi

check "gitVersionSatisifed" $git_version_satisfied

# Report result
reportResults
