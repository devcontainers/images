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

git_version=$(git --version)
check-version-ge "git-requirement" "${git_version}" "git version 2.38.1"

joblib_version=$(python -c "import joblib; print(joblib.__version__)")
check-version-ge "joblib-requirement" "${joblib_version}" "1.2.0"

cookiecutter_version=$(python -c "import cookiecutter; print(cookiecutter.__version__)")
check-version-ge "cookiecutter-requirement" "${cookiecutter_version}" "2.1.1"

cryptography_version=$(python -c "import cryptography; print(cryptography.__version__)")
check-version-ge "cryptography-requirement" "${cryptography_version}" "38.0.3"

mistune_version=$(python -c "import mistune; print(mistune.__version__)")
check-version-ge "mistune-requirement" "${mistune_version}" "2.0.3"

# Report result
reportResults
