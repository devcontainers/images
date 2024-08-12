#!/bin/bash

install_packages() {
    for package_name in "$@"; do
        local search_result=$(apt-cache search $package_name)
        if [[ -z $search_result ]]; then
            echo "Package $package_name not found."
        else
            echo "Found the following packages for $package_name:"
            echo "$search_result"
            local package=$(echo "$search_result" | head -n 1 | awk '{print $1}')
            echo "Installing $package..."
            apt-get install -y --no-install-recommends $package
        fi
    done
}

install_libicu_versions() {
    for version in "$@"; do
        package="libicu$version"
        echo "Attempting to install $package..."
        apt-get install -y --no-install-recommends $package
    done
}

. /etc/os-release
if [ "${ID}" = "ubuntu" ] && [ "${VERSION_CODENAME}" = "noble" ]; then
    set -x
    apt-get update
    install_libicu_versions 72 71 70 69 68 67 66 65 63 60 57 55 52
    install_packages "libcurl4" "libgcc1" "libssl3" "libunwind"
    set +x
fi


# https://msrc.microsoft.com/update-guide/vulnerability/CVE-2024-38095
if [ "$(dpkg --print-architecture)" = "amd64" ]; then
    apt-get update
    apt-get install -y wget
    POWERSHELL_FILE_NAME="powershell_7.4.4-1.deb_amd64.deb"
    wget https://github.com/PowerShell/PowerShell/releases/download/v7.4.4/${POWERSHELL_FILE_NAME}
    dpkg -i ${POWERSHELL_FILE_NAME}
    apt-get install -f
    rm ${POWERSHELL_FILE_NAME}
fi

if [ "$(dpkg --print-architecture)" = "arm64" ]; then
    apt-get update
    apt-get install -y curl tar
    POWERSHELL_FILE_PATH="/opt/microsoft/powershell/7"
    curl -L -o /tmp/powershell.tar.gz https://github.com/PowerShell/PowerShell/releases/download/v7.4.4/powershell-7.4.4-linux-arm64.tar.gz
    mkdir -p ${POWERSHELL_FILE_PATH}
    tar zxf /tmp/powershell.tar.gz -C ${POWERSHELL_FILE_PATH}
    chmod +x ${POWERSHELL_FILE_PATH}/pwsh
    ln -snf ${POWERSHELL_FILE_PATH}/pwsh /usr/bin/pwsh
    rm /tmp/powershell.tar.gz ; 
fi