#!/usr/bin/env bash

ARG USERNAME=vscode

apt-get -y install --no-install-recommends lynx
usermod -aG www-data ${USERNAME}
sed -i -e "s/Listen 80/Listen 80\\nListen 8080/g" /etc/apache2/ports.conf
apt-get clean -y && rm -rf /var/lib/apt/lists/*