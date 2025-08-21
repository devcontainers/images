#!/bin/bash
cd $(dirname "$0")

source test-utils.sh vscode

# Run common tests
checkCommon

# Image specific tests
check "jekyll" jekyll --version
check "gem" gem --version
check "ruby" ruby --version
check "bundler" bundler --version
check "github-pages" github-pages --version
check "nvm" bash -c ". /usr/local/share/nvm/nvm.sh && nvm install 10"
check "nvm-node" bash -c ". /usr/local/share/nvm/nvm.sh && node --version"

check "git" git --version
check "git-location" sh -c "which git | grep /usr/local/bin/git"

git_version=$(git --version)
check-version-ge "git-requirement" "${git_version}" "git version 2.40.1"

# Testing vulnerability issue CVE-2024-46901 fix by upgrading svn to 1.14.5.
svn_version=$(svn --version --quiet)
check-version-ge "svn-requirement" "${svn_version}" "1.14.5"

check "set-git-config-user-name" sh -c "sudo git config --system user.name devcontainers"
check "gitconfig-file-location" sh -c "ls /etc/gitconfig"
check "gitconfig-contains-name" sh -c "cat /etc/gitconfig | grep 'name = devcontainers'"

check "usr-local-etc-config-does-not-exist" test ! -f "/usr/local/etc/gitconfig"

check "post-create-exists" test -f /usr/local/post-create.sh

# Report result
reportResults
