#!/bin/bash
cd $(dirname "$0")

source test-utils.sh codespace

# Run common tests
checkCommon

# Check .NET
check "dotnet" dotnet --list-sdks
count=$(ls /usr/local/dotnet | wc -l)
expectedCount=3 # 2 version folders + 1 current folder which links to either one of the version
checkVersionCount "two versions of dotnet are present" $count $expectedCount
echo $(echo "list of installed dotnet versions" && ls -a /usr/local/dotnet)

# Check Python
check "python" python --version
check "python3" python3 --version
check "pip" pip --version
check "pip3" pip3 --version
check "pipx" pipx --version
check "pylint" pylint --version
check "flake8" flake8 --version
check "autopep8" autopep8 --version
check "yapf" yapf --version
check "mypy" mypy --version
check "pydocstyle" pydocstyle --version
check "bandit" bandit --version
check "virtualenv" virtualenv --version
count=$(ls /usr/local/python | wc -l)
expectedCount=3 # 2 version folders + 1 current folder which links to either one of the version
checkVersionCount "two versions of python are present" $count $expectedCount
echo $(echo "python versions" && ls -a /usr/local/python)
echo $(echo "pip list" pip list)

# Check Python packages
check "numpy" python -c "import numpy; print(numpy.__version__)"
check "pandas" python -c "import pandas; print(pandas.__version__)"
check "scipy" python -c "import scipy; print(scipy.__version__)"
check "matplotlib" python -c "import matplotlib; print(matplotlib.__version__)"
check "seaborn" python -c "import seaborn; print(seaborn.__version__)"
check "scikit-learn" python -c "import sklearn; print(sklearn.__version__)"
check "tensorflow" python -c "import tensorflow; print(tensorflow.__version__)"
check "keras" python -c "import keras; print(keras.__version__)"
check "torch" python -c "import torch; print(torch.__version__)"
check "requests" python -c "import requests; print(requests.__version__)"

# Check JupyterLab
check "jupyter-lab" jupyter-lab --version
check "jupyter-lab config" grep ".*.allow_origin = '*'" /home/codespace/.jupyter/jupyter_server_config.py
check "jupyter-lab kernel" test -d "/home/codespace/.python/current/bin"

# Check Java tools
check "java" java -version
check "sdkman" bash -c ". /usr/local/sdkman/bin/sdkman-init.sh && sdk version"
check "gradle" gradle -g /tmp --version
check "maven" mvn --version
count=$(ls /usr/local/sdkman/candidates/java | wc -l)
expectedCount=3 # 2 version folders + 1 current folder which links to either one of the version
checkVersionCount "two versions of java are present" $count $expectedCount
echo $(echo "java versions" && ls -a /usr/local/sdkman/candidates/java)

# Check Ruby tools
check "ruby" ruby --version
check "rvm" bash -c ". /usr/local/rvm/scripts/rvm && rvm --version"
check "rbenv" bash -c 'eval "$(rbenv init -)" && rbenv --version'
check "gems" gem --version
check "rake" rake --version
check "jekyll" jekyll --version
count=$(ls /usr/local/rvm/gems | wc -l)
expectedCount=6 # 2 version folders + 2 global folders for each version + 1 default folder which links to either one of the version + 1 cache folder
checkVersionCount "two versions of ruby are present" $count $expectedCount
echo $(echo "ruby versions" && ls -a /usr/local/rvm/rubies)

# Node.js
check "node" node --version
check "nvm" bash -c ". /usr/local/share/nvm/nvm.sh && nvm --version"
check "nvs" bash -c ". /usr/local/nvs/nvs.sh && nvs --version"
check "yarn" yarn --version
check "npm" npm --version
count=$(ls /usr/local/share/nvm/versions/node | wc -l)
expectedCount=2
checkVersionCount "two versions of node are present" $count $expectedCount
echo $(echo "node versions" && ls -a /usr/local/share/nvm/versions/node)

# PHP
check "php" php --version
check "php composer" composer --version
check "pecl" pecl version
check "Xdebug" php --version | grep 'Xdebug'
count=$(ls /usr/local/php | wc -l)
expectedCount=3 # 2 version folders + 1 current folder which links to either one of the version
checkVersionCount "two versions of php are present" $count $expectedCount
echo $(echo "php versions" && ls -a /usr/local/php)

# Hugo
check "hugo" hugo version

# conda
check "conda" conda --version

# Go
check "go" go version

# Check utilities
checkOSPackages "additional-os-packages" vim xtail software-properties-common
check "gh" gh --version
check "git-lfs" git-lfs --version
check "docker" docker --version
check "kubectl" kubectl version --client
check "helm" helm version

# Check expected shells
check "bash" bash --version
check "fish" fish --version
check "zsh" zsh --version

# Check env variable
check "RAILS_DEVELOPMENT_HOSTS is set correctly" echo $RAILS_DEVELOPMENT_HOSTS | grep ".githubpreview.dev,.app.github.dev"

# Check that we can run a puppeteer node app.
yarn
check "run-puppeteer" node puppeteer.js

# Check Oryx
check "oryx" oryx --version

# Install platforms with oryx build tool
check "oryx-install-dotnet-2.1" oryx prep --skip-detection --platforms-and-versions dotnet=2.1.30
check "dotnet-2-installed-by-oryx" ls /opt/dotnet/ | grep 2.1
check "dotnet-version-on-path-is-2.1.12" dotnet --version | grep 2.1

check "oryx-install-nodejs-12.22.11" oryx prep --skip-detection --platforms-and-versions nodejs=12.22.11
check "nodejs-12.22.11-installed-by-oryx" ls /opt/nodejs/ | grep 12.22.11
check "nodejs-version-on-path-is-2.1.12" node --version | grep v12.22.11

check "oryx-install-php-7.3.25" oryx prep --skip-detection --platforms-and-versions php=7.3.25
check "php-7.3.25-installed-by-oryx" ls /opt/php/ | grep 7.3.25
check "php-version-on-path-is-2.1.12" php --version | grep 7.3.25

check "oryx-install-java-12.0.2" oryx prep --skip-detection --platforms-and-versions java=12.0.2
check "java-12.0.2-installed-by-oryx" ls /opt/java/ | grep 12.0.2
check "java-version-on-path-is-12.0.2" java --version | grep 12.0.2

ls -la /home/codespace

# Report result
reportResults
