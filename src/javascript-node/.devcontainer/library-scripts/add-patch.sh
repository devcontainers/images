#!/bin/bash

IMAGE_VARIANT=$1

# Temporary: Upgrade 'decode-uri-component' due to https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2022-38900
# 'decode-uri-component' is installed by the base image (node) for `node:14` which does not have the patch.
if [[ "${IMAGE_VARIANT}" =~ "14" ]] ; then
    cd /usr/local/lib/node_modules/npm
    npm update --save
fi
