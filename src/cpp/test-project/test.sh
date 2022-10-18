#!/bin/bash
cd $(dirname "$0")

source test-utils.sh vscode

# Run common tests
checkCommon

# Help determine distro
. /etc/os-release 

checkOSPackages "command-line-tools" build-essential cmake cppcheck valgrind clang lldb llvm gdb
checkOSPackages "tools-for-vcpkg" tar curl zip unzip pkg-config bash-completion ninja-build
VCPKG_UNSUPPORTED_ARM64_VERSION_CODENAMES="stretch bionic"
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

git_version_satisfied=false
if (echo a version 2.38.1; git --version) | sort -Vk3 | tail -1 | grep -q git; then
    git_version_satisfied=true
fi

check "git version satisfies requirement" echo $git_version_satisfied | grep "true"

## Report result
reportResults
