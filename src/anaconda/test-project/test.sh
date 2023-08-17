#!/bin/bash
cd $(dirname "$0")

source test-utils.sh vscode

# Run common tests
checkCommon

# Image specific tests
check "conda" conda --version
check "python" python --version
check "pylint" pylint --version
check "flake8" flake8 --version
check "autopep8" autopep8 --version
check "yapf" yapf --version
check "pydocstyle" pydocstyle --version
check "pycodestyle" pycodestyle --version
check "nvm" bash -c ". /usr/local/share/nvm/nvm.sh && nvm --version"

check "git" git --version
check "git-location" sh -c "which git | grep /usr/local/bin/git"

git_version=$(git --version)
check-version-ge "git-requirement" "${git_version}" "git version 2.40.1"

check "set-git-config-user-name" sh -c "sudo git config --system user.name devcontainers"
check "gitconfig-file-location" sh -c "ls /etc/gitconfig"
check "gitconfig-contains-name" sh -c "cat /etc/gitconfig | grep 'name = devcontainers'"

check "usr-local-etc-config-does-not-exist" test ! -f "/usr/local/etc/gitconfig"

checkPythonPackageVersion "joblib" "1.2.0"
checkPythonPackageVersion "cookiecutter" "2.1.1"
checkPythonPackageVersion "cryptography" "38.0.3"
checkPythonPackageVersion "mistune" "2.0.3"
checkPythonPackageVersion "numpy" "1.22"
checkPythonPackageVersion "setuptools" "65.5.1"
checkPythonPackageVersion "future" "0.18.3"
checkPythonPackageVersion "wheel" "0.38.1"
checkPythonPackageVersion "nbconvert" "6.5.1"
checkPythonPackageVersion "werkzeug" "2.2.3"
checkPythonPackageVersion "certifi" "2022.12.07"
checkPythonPackageVersion "requests" "2.31.0"
checkPythonPackageVersion "cryptography" "41.0.2"
checkPythonPackageVersion "torch" "1.13.1"
checkPythonPackageVersion "transformers" "4.30.0"
checkPythonPackageVersion "mpmath" "1.3.0"
checkPythonPackageVersion "aiohttp" "3.8.5"

# The `tornado` package doesn't have the `__version__` attribute so we can use the `version` attribute.
tornado_version=$(python -c "import tornado; print(tornado.version)")
check-version-ge "tornado-requirement" "${tornado_version}" "6.3.2"

checkCondaPackageVersion "pyopenssl" "23.2.0"
checkCondaPackageVersion "cryptography" "41.0.2"
checkCondaPackageVersion "requests" "2.31.0"
checkCondaPackageVersion "pygments" "2.15.1"
checkCondaPackageVersion "mpmath" "1.3.0"
checkCondaPackageVersion "aiohttp" "3.8.5"

check "conda-update-conda" bash -c "conda update -y conda"
check "conda-install-tensorflow" bash -c "conda create --name test-env -c conda-forge --yes tensorflow"
check "conda-install-pytorch" bash -c "conda create --name test-env -c conda-forge --yes pytorch"

# Report result
reportResults
