#!/bin/bash
cd $(dirname "$0")

source test-utils.sh vscode

# Run common tests
checkCommon

# Image specific tests
check "rust" rustc --version
check "cargo" cargo --version

# Report result
reportResults
