#!/bin/bash
cd $(dirname "$0")

source test-utils.sh vscode

# Run common tests
checkCommon

check "git" git --version

git_version_satisfied=false
if (echo a version 2.38.1; git --version) | sort -Vk3 | tail -1 | grep -q git; then
    git_version_satisfied=true
fi

check "git version satisfies requirement" echo $git_version_satisfied | grep "true"

cd /tmp && git clone https://github.com/devcontainers/feature-starter.git
cd feature-starter
check "perl" bash -c "git -c grep.patternType=perl grep -q 'a.+b'"

check "Oh My Zsh! theme" test -e $HOME/.oh-my-zsh/custom/themes/devcontainers.zsh-theme
check "zsh theme symlink" test -e $HOME/.oh-my-zsh/custom/themes/codespaces.zsh-theme

# Report result
reportResults
