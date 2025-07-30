#!/bin/bash
cd $(dirname "$0")

source test-utils.sh vscode

# Run common tests
checkCommon

# Prep
echo -e "\nGetting Maven wrapper..."
curl -sSL https://github.com/takari/maven-wrapper/archive/maven-wrapper-0.5.5.tar.gz| tar -xzf -
mv maven-wrapper-maven-wrapper-0.5.5/mvnw mvnw
mv maven-wrapper-maven-wrapper-0.5.5/.mvn .mvn
rm -rf mv maven-wrapper-maven-wrapper-0.5.5

# Image specific tests
checkExtension "vscjava.vscode-java-pack"
check "java" java -version
check "build-and-test-jar" ./mvnw -q package
check "test-project" java -jar target/my-app-1.0-SNAPSHOT.jar

check "git" git --version
check "git-location" sh -c "which git | grep /usr/local/bin/git"

git_version=$(git --version)
check-version-ge "git-requirement" "${git_version}" "git version 2.40.1"

check "set-git-config-user-name" sh -c "sudo git config --system user.name devcontainers"
check "gitconfig-file-location" sh -c "ls /etc/gitconfig"
check "gitconfig-contains-name" sh -c "cat /etc/gitconfig | grep 'name = devcontainers'"

check "usr-local-etc-config-does-not-exist" test ! -f "/usr/local/etc/gitconfig"

# Clean up
rm -f mvnw
rm -rf .mvn

"checki path"
which java

# Report result
reportResults
