#!/bin/bash
cd $(dirname "$0")

source test-utils.sh codespace
#Changing he ownership of dotnet path to ensure oryx-install-dotnet-2.1 test doesn't fail with permission issue 
sudo chown -R codespace:codespace /usr/share/dotnet

# Run common tests
checkCommon

check "git" git --version

git_version=$(git --version)
check-version-ge "git-requirement" "${git_version}" "git version 2.45.1"

check "set-git-config-user-name" sh -c "sudo git config --system user.name devcontainers"
check "gitconfig-file-location" sh -c "ls /etc/gitconfig"
check "gitconfig-contains-name" sh -c "cat /etc/gitconfig | grep 'name = devcontainers'"

check "usr-local-etc-config-does-not-exist" test ! -f "/usr/local/etc/gitconfig"

# Check .NET
check "dotnet" dotnet --list-sdks
check "dotnet-runtimes" bash -c "dotnet --list-runtimes"
# Runtimes are listed twice due to 'Microsoft.NETCore.App' and 'Microsoft.AspNetCore.App'
checkVersionCount "two versions of dotnet runtimes are present" $(dotnet --list-runtimes | wc -l) 4

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
check "requests" python -c "import requests; print(requests.__version__)"
check "jupyterlab-git" python -c "import jupyterlab_git; print(jupyterlab_git.__version__)"

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
check "ruby-build" ruby-build --version
check "gems" gem --version
check "rake" rake --version
check "jekyll" jekyll --version
count=$(ls /usr/local/rubies | wc -l)
expectedCount=3 # 2 version folders + 1 current folder which links to either one of the version
checkVersionCount "two versions of ruby are present" $count $expectedCount
echo $(echo "ruby versions" && ls -a /usr/local/rubies)
rubyGemsDir=$(ruby -e 'require "rubygems"; puts File.join(Gem.default_dir, "extensions")')
check "ruby extensions dir exists" test -d "$rubyGemsDir"
checkDirectoryOwnership "codespace user has ownership over extension directory" "$rubyGemsDir" "codespace" "ruby"

# Node.js
check "node" node --version
for node_path in /usr/local/share/nvm/versions/node/*/bin/node; do
	node_version=$("${node_path}" --version)
	case "${node_version}" in
		v22.*) check-version-ge "${node_path}-requirement" "${node_version}" "v22.23.4" ;;
		v24.*) check-version-ge "${node_path}-requirement" "${node_version}" "v24.22.1" ;;
		v26.*) check-version-ge "${node_path}-requirement" "${node_version}" "v26.12.1" ;;
		*) check-version-ge "${node_path}-requirement" "${node_version}" "v27.0.0" ;;
	esac
done
check "nvm" bash -c ". /usr/local/share/nvm/nvm.sh && nvm --version"
check "yarn" yarn --version
check "npm" npm --version
count=$(ls /usr/local/share/nvm/versions/node | wc -l)
expectedCount=2
checkVersionCount "two versions of node are present" $count $expectedCount
echo $(echo "node versions" && ls -a /usr/local/share/nvm/versions/node)
checkBundledNpmVersion "default" "9.8.0"
checkBundledNpmVersion "22" "9.8.1"

# PHP
check "php" php --version
for php_path in /usr/local/php/*/bin/php; do
	php_version=$("${php_path}" -r 'echo PHP_VERSION;')
	check "${php_path}-version" test -n "${php_version}"
	case "${php_version}" in
		8.4.*) check-version-ge "${php_path}-requirement" "${php_version}" "8.4.27" ;;
		8.5.*) check-version-ge "${php_path}-requirement" "${php_version}" "8.5.12" ;;
	esac
done
check "php composer" composer --version
composer_ca_bundle_version=$(php -r '
	$phar = new Phar(realpath($argv[1]));
	$installed = json_decode($phar["vendor/composer/installed.json"]->getContent(), true, 512, JSON_THROW_ON_ERROR);
	foreach ($installed["packages"] ?? $installed as $package) {
		if ($package["name"] === "composer/ca-bundle") {
			echo ltrim($package["version"], "v");
			exit(0);
		}
	}
	exit(1);
' "$(command -v composer)")
case "${composer_ca_bundle_version}" in
	1.4.*) check-version-ge "composer-ca-bundle-requirement" "${composer_ca_bundle_version}" "1.4.16" ;;
	*) check-version-ge "composer-ca-bundle-requirement" "${composer_ca_bundle_version}" "1.6.0" ;;
esac
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
go_version=$(go version | awk '{sub(/^go/, "", $3); print $3}')
case "${go_version}" in
	1.26.*) check-version-ge "go-requirement" "${go_version}" "1.26.10" ;;
	1.27.*) check-version-ge "go-requirement" "${go_version}" "1.27.3" ;;
	*) check-version-ge "go-requirement" "${go_version}" "1.28.0" ;;
esac

# Check utilities
checkOSPackages "additional-os-packages" vim xtail software-properties-common
checkOSPackages "base-build-and-debug-packages" build-essential cmake cppcheck valgrind clang lldb llvm gdb python3-dev
checkOSPackages "base-library-and-documentation-packages" vim-doc libsecret-1-dev
check "gh" gh --version
check-version-ge "gh-requirement" "$(gh --version | awk 'NR == 1 {print $3}')" "2.102.1"
check "copilot" copilot --version
check "git-lfs" git-lfs --version
check-version-ge "git-lfs-requirement" "$(git-lfs --version | awk '{sub(/^git-lfs\//, "", $1); print $1}')" "3.8.1"
check "docker" docker --version
check "kubectl" kubectl version --client
check "helm" helm version
checkCondaPackageVersion "certifi" "2026.10.19"
check "ca-certificates-requirement" dpkg --compare-versions "$(dpkg-query -W -f='${Version}' ca-certificates)" ge "20260816ubuntu0.24.04.1"
check "libcurl-requirement" dpkg --compare-versions "$(dpkg-query -W -f='${Version}' libcurl4t64)" ge "8.5.0-2ubuntu10.16"
check "openssl-system-requirement" dpkg --compare-versions "$(dpkg-query -W -f='${Version}' openssl)" ge "3.0.13-0ubuntu3.16"
check "libssl-system-requirement" dpkg --compare-versions "$(dpkg-query -W -f='${Version}' libssl3t64)" ge "3.0.13-0ubuntu3.16"
check-version-ge "openssl-runtime-requirement" "$(openssl version | awk '{print $2}')" "3.5.8"

# Check expected shells
check "bash" bash --version
check "fish" fish --version
check "zsh" zsh --version

# Check env variable
check "RAILS_DEVELOPMENT_HOSTS is set correctly" echo $RAILS_DEVELOPMENT_HOSTS | grep ".githubpreview.dev,.preview.app.github.dev,.app.github.dev"

# Check Oryx
check "oryx" oryx --version

# Ensures nvm works in a Node Project
check "default-node-version" bash -c "node --version | grep 24."
check "default-node-location" bash -c "which node | grep /home/codespace/nvm/current/bin"
check "oryx-build-node-project" bash -c "oryx build ./sample/node"
check "oryx-configured-current-node-version" bash -c "ls -la /home/codespace/nvm/current | grep /opt/nodejs"
check "nvm-switches-to-additional-node-version" bash -c ". /usr/local/share/nvm/nvm.sh && nvm use 22 && node --version | grep v22."
check "node-location-after-switching-to-22" bash -c "which node | grep /home/codespace/nvm/current/bin"
check "nvm-switches-back-to-default-node-version" bash -c ". /usr/local/share/nvm/nvm.sh && nvm use default && node --version | grep v24."
check "node-location-after-switching-back-to-default" bash -c "which node | grep /home/codespace/nvm/current/bin"

# Ensures sdkman works in a Java Project
check "default-java-version" bash -c "java --version"
check "default-java-location" bash -c "which java | grep /home/codespace/java/current/bin"
check "sdk-install-java" bash -c ". /usr/local/sdkman/bin/sdkman-init.sh && sdk install java 19.0.1-oracle < /dev/null"
check "sdkman-works-in-java-project" bash -c "java --version | grep 19.0.1"
check "default-java-location-remained-same" bash -c "which java | grep /home/codespace/java/current/bin"

# Make sure that Oryx builds Python projects correctly
pythonVersion=$(python -V 2>&1 | grep -Po '(?<=Python )(.+)')
pythonSite=`python -m site --user-site`
check "oryx-build-python" oryx build --property python_version="${pythonVersion}" --property packagedir="${pythonSite}" ./sample/python
check "oryx-build-python-installed" python3 -m pip list | grep mpmath
check "oryx-build-python-result" python3 ./sample/python/src/solve.py

# Install platforms with oryx build tool
check "oryx-install-dotnet-8.0" oryx prep --skip-detection --platforms-and-versions dotnet=8.0.23
check "dotnet-8-installed-by-oryx" ls /opt/dotnet/ | grep 8.0
check "dotnet-version-on-path-is-8.0.23" dotnet --version | grep 8.0

check "oryx-install-nodejs-20.11.0" oryx prep --skip-detection --platforms-and-versions nodejs=20.11.0
check "nodejs-20.11.0-installed-by-oryx" ls /opt/nodejs/ | grep 20.11.0
check "nodejs-version-on-path-is-20.11.0" node --version | grep v20.11.0

check "oryx-install-php-8.1.30" oryx prep --skip-detection --platforms-and-versions php=8.1.30
check "php-8.1.30-installed-by-oryx" ls /opt/php/ | grep 8.1.30
check "php-version-on-path-is-8.1.30" php --version | grep 8.1.30

# Test patches

ls -la /home/codespace
check "python-3.13.8-pip-version" checkPythonPipVersion "/usr/local/python/3.13.8/bin/python" "26.1.0"
check "conda-pip-version" checkPythonPipVersion "/opt/conda/bin/python3" "26.1.0"
check "no-vulnerable-pip-cache-in-conda-pkgs" checkNoVulnerablePipCache "/opt/conda/pkgs" "26.1"

## Python - current
checkPythonPackageVersion "python" "requests" "2.31.0"

## Conda Python
checkCondaPackageVersion "requests" "2.31.0"
checkCondaPackageVersion "cryptography" "50.0.0"
checkCondaPackageVersion "pyopenssl" "26.4.0"
checkCondaPackageVersion "openssl" "3.5.8"
checkCondaPackageVersion "urllib3" "2.6.3"
checkCondaPackageVersion "brotli" "1.2.0"
checkCondaPackageVersion "python-dotenv" "1.2.2"

## Test Conda
check "conda-update-conda" bash -c "conda update -c defaults -y conda"
check "conda-install-tensorflow" bash -c "conda create --name test-env -c conda-forge --yes tensorflow"
check "conda-install-pytorch" bash -c "conda create --name test-env -c conda-forge --yes pytorch"

# Report result
reportResults
