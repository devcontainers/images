#!/usr/bin/env bash
#-------------------------------------------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See https://go.microsoft.com/fwlink/?linkid=2090316 for license information.
#-------------------------------------------------------------------------------------------------------------

VERSION=${1:-"latest"}
USERNAME=${2:-"codespace"}

set -e

# Use sudo to run as non-root user is not already running
sudo_if() {
    COMMAND="$*"
    if [ "$(id -u)" -eq 0 ] && [ "$USERNAME" != "root" ]; then
        su - "$USERNAME" -c "$COMMAND"
    else
        "$COMMAND"
    fi
}

# If we don't yet have Ruby installed, exit.
if ! /usr/local/rvm/rubies/default/bin/ruby --version > /dev/null; then
  echo "You need to install Ruby before installing Jekyll."
  exit 1
fi

# If we don't already have Jekyll installed, install it now.
if ! jekyll --version > /dev/null; then
  echo "Installing Jekyll..."
  if [ "${VERSION}" = "latest" ]; then
    sudo_if gem install jekyll
  else
    sudo_if gem install jekyll -v "${VERSION}"
  fi
fi
