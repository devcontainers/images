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
check "git" bash -c "echo ${git_version}" 
check-version-ge "git-requirement" "${git_version}" "git version 2.38.1"

joblib_version=$(python -c "import joblib; print(joblib.__version__)")
check "joblib" bash -c "echo ${joblib_version}" 
check-version-ge "joblib-requirement" "${joblib_version}" "1.2.0"

cookiecutter_version=$(python -c "import cookiecutter; print(cookiecutter.__version__)")
check "cookiecutter" bash -c "echo ${cookiecutter}" 
check-version-ge "cookiecutter-requirement" "${cookiecutter_version}" "2.1.1"

# Report result
reportResults
