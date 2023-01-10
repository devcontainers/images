#!/bin/bash
cd $(dirname "$0")

source test-utils.sh vscode

# Run common tests
checkCommon

# Image specific tests
check "python" python --version
check "pipx" pipx --version
check "pylint" pylint --version
check "flake8" flake8 --version
check "autopep8" autopep8 --version
check "yapf" yapf --version
check "mypy" mypy --version
check "pydocstyle" pydocstyle --version
check "pycodestyle" pycodestyle --version
check "bandit" bandit --version
check "pipenv" pipenv --version
check "virtualenv" virtualenv --version

check "nvm" bash -c ". /usr/local/share/nvm/nvm.sh && nvm install 10"
check "nvm-node" bash -c ". /usr/local/share/nvm/nvm.sh && node --version"
check "yarn" bash -c ". /usr/local/share/nvm/nvm.sh && yarn --version"

check "Oh My Zsh! theme" test -e $HOME/.oh-my-zsh/custom/themes/devcontainers.zsh-theme
check "zsh theme symlink" test -e $HOME/.oh-my-zsh/custom/themes/codespaces.zsh-theme

check "git" git --version

git_version_satisfied=false
if (echo a version 2.38.1; git --version) | sort -Vk3 | tail -1 | grep -q git; then
    git_version_satisfied=true
fi

check "git version satisfies requirement" echo $git_version_satisfied | grep "true"

# Report result
reportResults
