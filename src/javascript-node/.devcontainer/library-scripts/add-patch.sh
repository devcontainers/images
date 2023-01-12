#!/bin/bash

IMAGE_VARIANT=$1

# Temporary: These packages are installed by the base image (node) for `node:14` which does not have the patch.
# Upgrade 'decode-uri-component' due to https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2022-38900
# Upgrade 'ansi-regex ' due to https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2021-3807
# Upgrade 'minimatch' due to https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2022-3517
# Upgrade 'got' due to https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2022-33987
# Upgrade 'qs' due to https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2022-24999
if [[ "${IMAGE_VARIANT}" =~ "14" ]] ; then
    NPM_LIST="ansi-regex \
        decode-uri-component \
        got \
        minimatch \
        package-json \
        qs"

    cd /usr/local/lib/node_modules/npm
    npm install ${NPM_LIST} --save

    cd /usr/local/lib/node_modules/npm/node_modules/string-width
    npm install ansi-regex --save

    cd /usr/local/lib/node_modules/npm/node_modules/package-json
    npm install got registry-auth-token registry-url --save

    cd /usr/local/lib/node_modules/npm/node_modules/yargs
    npm install ansi-regex --save
fi
