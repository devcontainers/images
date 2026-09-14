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

check "set-git-config-user-name" sh -c "sudo git config --system user.name devcontainers"
check "gitconfig-file-location" sh -c "ls /etc/gitconfig"
check "gitconfig-contains-name" sh -c "cat /etc/gitconfig | grep 'name = devcontainers'"

check "usr-local-etc-config-does-not-exist" test ! -f "/usr/local/etc/gitconfig"

# Testing vulnerability issue CVE-2024-46901 fix by upgrading svn to 1.14.5.
svn_version=$(svn --version --quiet)
check-version-ge "svn-requirement" "${svn_version}" "1.14.5"

check "post-create-exists" test -f /usr/local/post-create.sh

# Regression test for the non-root "bundle install" permission error: gem
# installs during the image build run as root and previously left
# subdirectories of GEM_HOME (/usr/local/bundle) non-writable by the
# "vscode" user, even though the top-level directory itself is 1777.
check "gem-home-subdirs-writable" bash -c '
  set -e
  for d in cache gems specifications bin extensions doc build_info plugins; do
    mkdir -p "$GEM_HOME/$d"
    touch "$GEM_HOME/$d/.write-test-$$"
    rm -f "$GEM_HOME/$d/.write-test-$$"
  done
'

# Report result
reportResults
