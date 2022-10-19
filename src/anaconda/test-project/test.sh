#!/bin/bash
cd $(dirname "$0")

source test-utils.sh vscode

# Run common tests
checkCommon

# Image specific tests
check "conda" conda --version
check "python" python --version
check "pylint" pylint --version
check "flake8" flake8 --version
check "autopep8" autopep8 --version
check "yapf" yapf --version
check "pydocstyle" pydocstyle --version
check "pycodestyle" pycodestyle --version
check "nvm" bash -c ". /usr/local/share/nvm/nvm.sh && nvm --version"
check "git" git --version

git_version_satisfied=false
if (echo a version 2.38.1; git --version) | sort -Vk3 | tail -1 | grep -q git; then
    git_version_satisfied=true
fi

check "gitVersionSatisifed" $git_version_satisfied

# Report result
reportResults
