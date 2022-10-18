#!/bin/bash
cd $(dirname "$0")

source test-utils.sh vscode

# Run common tests
checkCommon

# Image specific tests
check "rust" rustc --version
check "cargo" cargo --version

check "git" git --version

git_version_satisfied=false
if (echo a version 2.38.1; git --version) | sort -Vk3 | tail -1 | grep -q git; then
    git_version_satisfied=true
fi

check "git version satisfies requirement" echo $git_version_satisfied | grep "true"

# Report result
reportResults
