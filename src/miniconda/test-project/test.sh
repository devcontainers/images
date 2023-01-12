#!/bin/bash
cd $(dirname "$0")

source test-utils.sh vscode

# Run common tests
checkCommon

check "git" git --version

git_version=$(git --version)
check-version-ge "git-requirement" "${git_version}" "git version 2.38.1"

cryptography_version=$(python -c "import cryptography; print(cryptography.__version__)")
check-version-ge "cryptography-requirement" "${cryptography_version}" "38.0.3"

# Report result
reportResults
