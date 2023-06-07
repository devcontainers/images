#!/usr/bin/env bash
#-------------------------------------------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See https://go.microsoft.com/fwlink/?linkid=2090316 for license information.
#-------------------------------------------------------------------------------------------------------------

USERNAME=${USERNAME:-"codespace"}

set -eux

if [ "$(id -u)" -ne 0 ]; then
    echo -e 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
    exit 1
fi

# Ensure that login shells get the correct path if the user updated the PATH using ENV.
rm -f /etc/profile.d/00-restore-env.sh
echo "export PATH=${PATH//$(sh -lc 'echo $PATH')/\$PATH}" > /etc/profile.d/00-restore-env.sh
chmod +x /etc/profile.d/00-restore-env.sh

export DEBIAN_FRONTEND=noninteractive

# Temporary: Due to https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2021-29425
MAVEN_PATH=$(cd /usr/local/sdkman/candidates/maven/3*/lib/ && pwd)
rm -f ${MAVEN_PATH}/commons-io-*
curl -sSL https://github.com/apache/commons-io/archive/refs/tags/commons-io-2.11.0-RC1.tar.gz | tar -xzC /tmp 2>&1
jar cf ${MAVEN_PATH}/commons-io-2.11.jar /tmp/commons-io-commons-io-2.11.0-RC1
rm -rf /tmp/commons-io-commons-io-2.11.0-RC1

# Temporary: Due to https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2022-0536 & https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2022-0155
rm -rf /usr/local/nvs/deps/node_modules/follow-redirects/*
curl -sSL https://github.com/follow-redirects/follow-redirects/archive/refs/tags/v1.15.2.tar.gz | tar -xzC /tmp 2>&1
mv /tmp/follow-redirects-1.15.2/*  /usr/local/nvs/deps/node_modules/follow-redirects/

sudo_if() {
    COMMAND="$*"
    if [ "$(id -u)" -eq 0 ] && [ "$USERNAME" != "root" ]; then
        su - "$USERNAME" -c "$COMMAND"
    else
        "$COMMAND"
    fi
}

# Temporary: Upgrade python packages due to https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2022-40897
# They are installed by the base image (python) which does not have the patch.
sudo_if /usr/local/python/current/bin/python -m pip uninstall --yes setuptools
sudo_if /usr/local/python/current/bin/python -m pip install --user --upgrade --no-cache-dir setuptools
sudo_if /usr/local/python/3.9.*/bin/python -m pip uninstall --yes setuptools
sudo_if /usr/local/python/3.9.*/bin/python -m pip install --user --upgrade --no-cache-dir setuptools

# Enables the oryx tool to generate manifest-dir which is needed for running the postcreate tool
DEBIAN_FLAVOR="focal-scm"
mkdir -p /opt/oryx && echo "vso-focal" > /opt/oryx/.imagetype
echo "DEBIAN|${DEBIAN_FLAVOR}" | tr '[a-z]' '[A-Z]' > /opt/oryx/.ostype

# Oryx expects the tool to be installed at `/opt/oryx` and looks for relevant files in there.
ln -snf /usr/local/oryx/* /opt/oryx

# For the universal image, oryx build tool installs the detected platforms in /home/codespace/*. Hence, linking current platforms to the /home/codespace/ path and adding it to the PATH.
# This ensures that whatever platfornm versions oryx detects and installs are set as root.
NODE_PATH="/home/codespace/nvm/current"
ln -snf /usr/local/share/nvm /home/codespace

PHP_PATH="/home/${USERNAME}/.php/current"
mkdir -p /home/${USERNAME}/.php
ln -snf /usr/local/php/current $PHP_PATH

PYTHON_PATH="/home/${USERNAME}/.python/current"
mkdir -p /home/${USERNAME}/.python
ln -snf /usr/local/python/current $PYTHON_PATH
ln -snf /usr/local/python /opt/python

JAVA_PATH="/home/codespace/java/current"
ln -snf /usr/local/sdkman/candidates/java /home/codespace

RUBY_PATH="/home/${USERNAME}/.ruby/current"
mkdir -p /home/${USERNAME}/.ruby
ln -snf /usr/local/rvm/rubies/default $RUBY_PATH

DOTNET_PATH="/home/${USERNAME}/.dotnet"
ln -snf /usr/local/dotnet/current $DOTNET_PATH
mkdir -p /opt/dotnet/lts
cp -R /usr/local/dotnet/current/dotnet /opt/dotnet/lts
cp -R /usr/local/dotnet/current/LICENSE.txt /opt/dotnet/lts
cp -R /usr/local/dotnet/current/ThirdPartyNotices.txt /opt/dotnet/lts

MAVEN_PATH="/home/${USERNAME}/.maven/current"
mkdir -p /home/${USERNAME}/.maven
ln -snf /usr/local/sdkman/candidates/maven/current $MAVEN_PATH

HUGO_ROOT="/home/${USERNAME}/.hugo/current"
mkdir -p /home/${USERNAME}/.hugo
ln -snf /usr/local/hugo $HUGO_ROOT

HOME_DIR="/home/${USERNAME}/"
chown -R ${USERNAME}:${USERNAME} ${HOME_DIR}
chmod -R g+r+w "${HOME_DIR}"
find "${HOME_DIR}" -type d | xargs -n 1 chmod g+s

OPT_DIR="/opt/"
chown -R ${USERNAME}:oryx ${OPT_DIR}
chmod -R g+r+w "${OPT_DIR}"
find "${OPT_DIR}" -type d | xargs -n 1 chmod g+s

echo "Defaults secure_path=\"${DOTNET_PATH}:${NODE_PATH}/bin:${PHP_PATH}/bin:${PYTHON_PATH}/bin:${JAVA_PATH}/bin:${RUBY_PATH}/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/bin:/usr/local/share:/home/${USERNAME}/.local/bin:${PATH}\"" >> /etc/sudoers.d/$USERNAME

echo "Done!"
