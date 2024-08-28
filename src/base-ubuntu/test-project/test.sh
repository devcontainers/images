#!/bin/bash
cd $(dirname "$0")

source test-utils.sh vscode

# Run common tests
checkCommon

check "Oh My Zsh! theme" test -e $HOME/.oh-my-zsh/custom/themes/devcontainers.zsh-theme
check "zsh theme symlink" test -e $HOME/.oh-my-zsh/custom/themes/codespaces.zsh-theme

check "git" git --version

git_version=$(git --version)
check-version-ge "git-requirement" "${git_version}" "git version 2.40.1"

check "set-git-config-user-name" sh -c "sudo git config --system user.name devcontainers"
check "gitconfig-file-location" sh -c "ls /etc/gitconfig"
check "gitconfig-contains-name" sh -c "cat /etc/gitconfig | grep 'name = devcontainers'"
check "usr-local-etc-config-does-not-exist" test ! -f "/usr/local/etc/gitconfig"

os_release=$(cat /etc/os-release)
# Check if the output contains "NAME=Ubuntu" and "VERSION=24.04"
if echo "$os_release" | grep -q "NAME=\"Ubuntu\"" && echo "$os_release" | grep -q "VERSION=\"24.04"; then
    check "Find ubuntu User" bash -c "grep 'ubuntu' /etc/passwd || echo 'ubuntu user not found.'" 
    check "Find ubuntu Group" bash -c "grep 'ubuntu' /etc/group || echo 'ubuntu group not found.'" 
    check "Find vscode User" bash -c "grep 'vscode' /etc/passwd || echo 'vscode user not found.'" 
    check "Find vscode Group" bash -c "grep 'vscode' /etc/group || echo 'vscode group not found.'" 

    check "log file contents" bash -c "cat /tmp/logfile.txt"
    check "all users" bash -c "cat /etc/passwd"
    check "uid" bash -c "id -u vscode | grep 1000"
fi;

# Report result
reportResults
