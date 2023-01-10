#!/bin/bash
cd $(dirname "$0")

source test-utils.sh vscode

# Run common tests
checkCommon

check "Oh My Zsh! theme" test -e $HOME/.oh-my-zsh/custom/themes/devcontainers.zsh-theme
check "zsh theme symlink" test -e $HOME/.oh-my-zsh/custom/themes/codespaces.zsh-theme

# Report result
reportResults
