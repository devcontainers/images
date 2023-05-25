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

cryptography_version=$(python -c "import cryptography; print(cryptography.__version__)")
check-version-ge "cryptography-requirement" "${cryptography_version}" "38.0.3"

check "conda-update-conda" bash -c "conda update -y conda"
check "conda-install" bash -c "conda install -c conda-forge --yes tensorflow"
check "conda-install" bash -c "conda install -c conda-forge --yes pytorch"

setuptools_version=$(python -c "import setuptools; print(setuptools.__version__)")
check-version-ge "setuptools-requirement" "${setuptools_version}" "65.5.1"

wheel_version=$(python -c "import wheel; print(wheel.__version__)")
check-version-ge "wheel-requirement" "${wheel_version}" " 0.38.1"

# Report result
reportResults
