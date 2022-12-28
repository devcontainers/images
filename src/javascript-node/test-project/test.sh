#!/bin/bash
cd $(dirname "$0")

source test-utils.sh node

# Run common tests
checkCommon

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

cd /usr/local/lib/node_modules/npm/node_modules/string-width/

ansiVersion=$(npm ls --depth 1 --json | jq -r '.dependencies."ansi-regex".version')
check-version-ge "ansi-regex" "${ansiVersion}" "6.0.1"

# Report result
reportResults
