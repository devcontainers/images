#!/bin/bash
cd $(dirname "$0")

source test-utils.sh node

# Run common tests
checkCommon

decodeVersion=$(npm ls --global --depth 1 --json | jq -r '.dependencies."decode-uri-component".version')
check-version-ge "decode-uri-component" "${decodeVersion}" "0.2.1"

ansiRegexVersion=$(npm ls --global --depth 1 --json | jq -r '.dependencies."ansi-regex".version')
check-version-ge "ansi-regex" "${ansiRegexVersion}" "6.0.0"

minimatchVersion=$(npm ls --global --depth 1 --json | jq -r ".dependencies.minimatch.version")
check-version-ge "minimatch" "${minimatchVersion}" "3.0.5"


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
