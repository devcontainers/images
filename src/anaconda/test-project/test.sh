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

joblib_version=$(python -c "import joblib; print(joblib.__version__)")
check-version-ge "joblib-requirement" "${joblib_version}" "1.2.0"

cookiecutter_version=$(python -c "import cookiecutter; print(cookiecutter.__version__)")
check-version-ge "cookiecutter-requirement" "${cookiecutter_version}" "2.1.1"

cryptography_version=$(python -c "import cryptography; print(cryptography.__version__)")
check-version-ge "cryptography-requirement" "${cryptography_version}" "38.0.3"

mistune_version=$(python -c "import mistune; print(mistune.__version__)")
check-version-ge "mistune-requirement" "${mistune_version}" "2.0.3"

numpy_version=$(python -c "import numpy; print(numpy.__version__)")
check-version-ge "numpy-requirement" "${numpy_version}" "1.22"

setuptools_version=$(python -c "import setuptools; print(setuptools.__version__)")
check-version-ge "setuptools-requirement" "${setuptools_version}" "65.5.1"

future_version=$(python -c "import future; print(future.__version__)")
check-version-ge "future-requirement" "${future_version}" "0.18.3"

wheel_version=$(python -c "import wheel; print(wheel.__version__)")
check-version-ge "wheel-requirement" "${wheel_version}" "0.38.1"

nbconvert_version=$(python -c "import nbconvert; print(nbconvert.__version__)")
check-version-ge "nbconvert-requirement" "${nbconvert_version}" "6.5.1"

check "conda-update-conda" bash -c "conda update -y conda"
check "conda-install" bash -c "conda install -c conda-forge --yes tensorflow"
check "conda-install" bash -c "conda install -c conda-forge --yes pytorch"

werkzeug_version=$(python -c "import werkzeug; print(werkzeug.__version__)")
check-version-ge "werkzeug-requirement" "${werkzeug_version}" "2.2.3"

# Report result
reportResults
