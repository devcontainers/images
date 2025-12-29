#!/bin/bash
cd $(dirname "$0")

source test-utils.sh node
check "yarn_version" yarn --version
sudo corepack enable && corepack prepare yarn@4.9.4 --activate
check "yarn_version_new" yarn --version

# Run common tests
checkCommon

# Image specific tests
check "node" node --version
npm_version=$(npm --version)
check-version-ge "npm-requirement" "${npm_version}" "9.8.1"
sudo rm -f yarn.lock
sudo touch yarn.lock
sudo rm -rf .yarn/*
sudo chmod a+rw yarn.lock
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

# Testing vulnerability issue CVE-2024-46901 fix by upgrading svn to 1.14.5.
svn_version=$(svn --version --quiet)
check-version-ge "svn-requirement" "${svn_version}" "1.14.5"

check "Oh My Zsh! theme" test -e $HOME/.oh-my-zsh/custom/themes/devcontainers.zsh-theme
check "zsh theme symlink" test -e $HOME/.oh-my-zsh/custom/themes/codespaces.zsh-theme

# Report result
reportResults
