#!/bin/bash
cd $(dirname "$0")

source test-utils.sh node

# Run common tests
checkCommon

# Image specific tests
check "node" node --version
npm_version=$(npm --version)
check-version-ge "npm-requirement" "${npm_version}" "9.8.1"
sudo rm -f yarn.lock
check "yarn" yarn install
sudo rm -f package-lock.json
check "npm" npm install
check "eslint" eslint server.js
check "test-project" npm run test
npm config delete prefix
check "nvm" bash -c ". /usr/local/share/nvm/nvm.sh && nvm install 8"
check "nvm-node" bash -c ". /usr/local/share/nvm/nvm.sh && node --version"
sudo rm -rf node_modules

check "git" git --version
check "git-location" sh -c "which git | grep /usr/local/bin/git"

git_version=$(git --version)
check-version-ge "git-requirement" "${git_version}" "git version 2.40.1"

check "set-git-config-user-name" sh -c "sudo git config --system user.name devcontainers"
check "gitconfig-file-location" sh -c "ls /etc/gitconfig"
check "gitconfig-contains-name" sh -c "cat /etc/gitconfig | grep 'name = devcontainers'"

check "usr-local-etc-config-does-not-exist" test ! -f "/usr/local/etc/gitconfig"

check "Oh My Zsh! theme" test -e $HOME/.oh-my-zsh/custom/themes/devcontainers.zsh-theme
check "zsh theme symlink" test -e $HOME/.oh-my-zsh/custom/themes/codespaces.zsh-theme

# Report result
reportResults
