#!/bin/bash
cd $(dirname "$0")

source test-utils.sh vscode

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

checkPythonPackageVersion "cryptography" "43.0.1"
checkPythonPackageVersion "setuptools" "65.5.1"
checkPythonPackageVersion "wheel" "0.38.1"
checkPythonPackageVersion "urllib3" "2.2.2"

checkCondaPackageVersion "cryptography" "43.0.1"
checkCondaPackageVersion "setuptools" "65.5.1"
checkCondaPackageVersion "wheel" "0.38.1"
checkCondaPackageVersion "requests" "2.32.0"
checkCondaPackageVersion "urllib3" "1.26.17"
checkCondaPackageVersion "idna" "3.7"
checkCondaPackageVersion "tqdm" "4.66.4"
checkCondaPackageVersion "certifi" "2024.7.4"

check "conda-update-conda" bash -c "conda update -y conda"
check "conda-install-tensorflow" bash -c "conda create --name test-env -c conda-forge --yes tensorflow"
check "conda-install-pytorch" bash -c "conda create --name test-env -c conda-forge --yes pytorch"

checkPipWorkingCorrectly

# Report result
reportResults
