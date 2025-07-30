#!/bin/bash
cd $(dirname "$0")

source test-utils-alpine.sh vscode

# Run common tests
checkCommon

check "git" git --version
check "git-location" sh -c "which git | grep /usr/local/bin/git"

git_version=$(git --version)
check-version-ge "git-requirement" "${git_version}" "git version 2.40.1"

check "set-git-config-user-name" sh -c "sudo git config --system user.name devcontainers"
check "gitconfig-file-location" sh -c "ls /etc/gitconfig"
check "gitconfig-contains-name" sh -c "cat /etc/gitconfig | grep 'name = devcontainers'"

check "usr-local-etc-config-does-not-exist" test ! -f "/usr/local/etc/gitconfig"

sudo_version=$(apk info sudo | head -1 | grep -Po  "sudo-\K(.*)(?=\s)")
check-version-ge "sudo-requirement" "${sudo_version}" "1.9.12_p2-r1"

# Report result
reportResults
