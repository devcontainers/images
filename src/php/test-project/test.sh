#!/bin/bash
cd $(dirname "$0")

source test-utils.sh vscode

# Run common tests
checkCommon

# Actual tests
check "php" php --version
php_version=$(php -r 'echo PHP_VERSION;')
case "${php_version}" in
	8.4.*) check-version-ge "php-requirement" "${php_version}" "8.4.27" ;;
	8.5.*) check-version-ge "php-requirement" "${php_version}" "8.5.12" ;;
esac
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
check "apache2ctl" which apache2ctl

check "nvm" bash -c ". /usr/local/share/nvm/nvm.sh && nvm install 24"
check "corepack" bash -c ". /usr/local/share/nvm/nvm.sh && corepack enable"
check "nvm-node" bash -c ". /usr/local/share/nvm/nvm.sh && node --version"
check "yarn" bash -c ". /usr/local/share/nvm/nvm.sh && yarn --version"

check "Oh My Zsh! theme" test -e $HOME/.oh-my-zsh/custom/themes/devcontainers.zsh-theme
check "zsh theme symlink" test -e $HOME/.oh-my-zsh/custom/themes/codespaces.zsh-theme

check "git" git --version
check "git-location" sh -c "which git | grep /usr/local/bin/git"

git_version=$(git --version)
check-version-ge "git-requirement" "${git_version}" "git version 2.40.1"

check "set-git-config-user-name" sh -c "sudo git config --system user.name devcontainers"
check "gitconfig-file-location" sh -c "ls /etc/gitconfig"
check "gitconfig-contains-name" sh -c "cat /etc/gitconfig | grep 'name = devcontainers'"

check "usr-local-etc-config-does-not-exist" test ! -f "/usr/local/etc/gitconfig"

# Report result
reportResults
