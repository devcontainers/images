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

check_ubuntu_user() {
    if ! id -u ubuntu > /dev/null 2>&1; then
        echo -e "✔️   User ubuntu does not exist."
    else
        echo -e "❌   User ubuntu exists."
        exit 1;
    fi
}

if grep -q 'VERSION_CODENAME=noble' /etc/os-release; then
    echo -e "\nThe base image is ubuntu:noble. Checking user Ubuntu.."
    check "uid" "check_ubuntu_user"
else
    echo -e "\nCannot check user Ubuntu. The base image is not ubuntu:noble."
fi

# Report result
reportResults
