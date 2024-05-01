#!/bin/bash
cd $(dirname "$0")

source test-utils.sh vscode

# Run common tests
checkCommon

# Help determine distro
. /etc/os-release

checkOSPackages "command-line-tools" build-essential cmake cppcheck valgrind clang lldb llvm gdb
checkOSPackages "tools-for-vcpkg" tar curl zip unzip pkg-config bash-completion ninja-build
VCPKG_UNSUPPORTED_ARM64_VERSION_CODENAMES="buster"
if [ "$(dpkg --print-architecture)" = "amd64" ] || [[ ! "${VCPKG_UNSUPPORTED_ARM64_VERSION_CODENAMES}" = *"${VERSION_CODENAME}"* ]]; then
    check "VCPKG_ROOT" [ -d "${VCPKG_ROOT}" ]
    check "VCPKG_DOWNLOAD" [ -d "${VCPKG_DOWNLOADS}" ]
    VCPKG_FORCE_SYSTEM_BINARIES=1 check "vcpkg-from-root" ${VCPKG_ROOT}/vcpkg --version
    VCPKG_FORCE_SYSTEM_BINARIES=1 check "vcpkg-from-bin" vcpkg --version
fi
check "g++"  g++ -g main.cpp -o main.out
rm main.out
mkdir -p build
cd build
check "cmake" cmake ..
cd ..
rm -rf build

check "git" git --version
check "git-location" sh -c "which git | grep /usr/local/bin/git"

git_version=$(git --version)
check-version-ge "git-requirement" "${git_version}" "git version 2.40.1"

check "set-git-config-user-name" sh -c "sudo git config --system user.name devcontainers"
check "gitconfig-file-location" sh -c "ls /etc/gitconfig"
check "gitconfig-contains-name" sh -c "cat /etc/gitconfig | grep 'name = devcontainers'"

check "usr-local-etc-config-does-not-exist" test ! -f "/usr/local/etc/gitconfig"

## Report result
reportResults
