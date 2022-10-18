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
check "eslint" eslint --no-eslintrc -c .eslintrc.json src/server.ts
check "typescript" npm run compile
check "test-project" npm run test
npm config delete prefix
check "nvm" bash -c ". /usr/local/share/nvm/nvm.sh && nvm install 8"
check "nvm-node" bash -c ". /usr/local/share/nvm/nvm.sh && node --version"
sudo rm -rf node_modules out

check "git" git --version

git_version_satisfied=false
if (echo a version 2.38.1; git --version) | sort -Vk3 | tail -1 | grep -q git; then
    git_version_satisfied=true
fi

check "git version satisfies requirement" echo $git_version_satisfied | grep "true"

# Report result
reportResults
