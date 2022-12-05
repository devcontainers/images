#!/bin/bash
cd $(dirname "$0")

source test-utils.sh node

# Run common tests
checkCommon

decodeVersion=$(npm ls -g | grep 'decode-uri-component')
check-version-ge "decode-uri-component" "${decodeVersion}" "+-- decode-uri-component@0.2.1"

ansiRegexVersion=$(npm ls -g | grep 'ansi-regex')
check-version-ge "ansi-regex" "${ansiRegexVersion}" "+-- ansi-regex@6.0.0"

# Image specific tests
check "node" node --version
sudo rm -f yarn.lock
check "yarn" yarn install
sudo rm -f package-lock.json
check "npm" npm install
check "eslint" eslint server.js
check "test-project" npm run test
npm config delete prefix
check "nvm" bash -c ". /usr/local/share/nvm/nvm.sh && nvm install 8"
check "nvm-node" bash -c ". /usr/local/share/nvm/nvm.sh && node --version"
sudo rm -rf node_modules

git_version=$(git --version)
check-version-ge "git-requirement" "${git_version}" "git version 2.38.1"

# Report result
reportResults
