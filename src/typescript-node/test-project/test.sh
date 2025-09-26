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
sudo rm -f yarn.lock
sudo rm -rf .yarn/*
sudo touch yarn.lock
sudo chmod a+rw yarn.lock
check "yarn" yarn install
sudo rm -f package-lock.json
check "eslint" eslint --no-warn-ignored src/server.ts
check "typescript" npm run compile
check "test-project" npm run test
npm config delete prefix
check "nvm" bash -c ". /usr/local/share/nvm/nvm.sh && nvm install 8"
check "nvm-node" bash -c ". /usr/local/share/nvm/nvm.sh && node --version"
sudo rm -rf node_modules out

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

# Report result
reportResults
