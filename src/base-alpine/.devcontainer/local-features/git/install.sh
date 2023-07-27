#!/bin/ash
#-------------------------------------------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See https://go.microsoft.com/fwlink/?linkid=2090316 for license information.
#-------------------------------------------------------------------------------------------------------------

set -e

apk update
apk add --no-cache \
    --upgrade \
    curl \
    grep \
    make \
    zlib-dev \
    --no-cache \
    openssl-dev \
    curl-dev \
    expat-dev \
    asciidoc \
    xmlto \
    perl-error \
    perl-dev \
    tcl \
    tk \
    gcc \
    g++ \
    python3-dev \
    pcre2-dev

GIT_VERSION_LIST="$(curl -sSL -H "Accept: application/vnd.github.v3+json" "https://api.github.com/repos/git/git/tags" | grep -oP '"name":\s*"v\K[0-9]+\.[0-9]+\.[0-9]+"' | tr -d '"' | sort -rV )"
GIT_VERSION="$(echo "${GIT_VERSION_LIST}" | head -n 1)"

echo "Installing git v${GIT_VERSION}"
curl -sL https://github.com/git/git/archive/v${GIT_VERSION}.tar.gz | tar -xzC /tmp 2>&1

cd /tmp/git-${GIT_VERSION}

make -s prefix=/usr/local sysconfdir=/etc all NO_REGEX=YesPlease NO_GETTEXT=YesPlease \
    && make -s prefix=/usr/local sysconfdir=/etc NO_REGEX=YesPlease NO_GETTEXT=YesPlease install 2>&1

rm -rf /tmp/git-${GIT_VERSION}
