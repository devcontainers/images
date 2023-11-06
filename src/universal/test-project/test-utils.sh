#!/bin/bash
SCRIPT_FOLDER="$(cd "$(dirname $0)" && pwd)"
USERNAME=${1:-vscode}

if [ -z $HOME ]; then
    HOME="/root"
fi

FAILED=()

echoStderr()
{
    echo "$@" 1>&2
}

check() {
    LABEL=$1
    shift
    echo -e "\n🧪 Testing $LABEL"
    if "$@"; then 
        echo "✅  Passed!"
        return 0
    else
        echoStderr "❌ $LABEL check failed."
        FAILED+=("$LABEL")
        return 1
    fi
}

check-version-ge() {
    LABEL=$1
    CURRENT_VERSION=$2
    REQUIRED_VERSION=$3
    shift
    echo -e "\n🧪 Testing $LABEL: '$CURRENT_VERSION' is >= '$REQUIRED_VERSION'"
    local GREATER_VERSION=$((echo ${CURRENT_VERSION}; echo ${REQUIRED_VERSION}) | sort -V | tail -1)
    if [ "${CURRENT_VERSION}" == "${GREATER_VERSION}" ]; then
        echo "✅  Passed!"
        return 0
    else
        echoStderr "❌ $LABEL check failed."
        FAILED+=("$LABEL")
        return 1
    fi
}

checkMultiple() {
    PASSED=0
    LABEL="$1"
    echo -e "\n🧪 Testing $LABEL."
    shift; MINIMUMPASSED=$1
    shift; EXPRESSION="$1"
    while [ "$EXPRESSION" != "" ]; do
        if $EXPRESSION; then ((PASSED++)); fi
        shift; EXPRESSION=$1
    done
    if [ $PASSED -ge $MINIMUMPASSED ]; then
        echo "✅ Passed!"
        return 0
    else
        echoStderr "❌ $LABEL check failed."
        FAILED+=("$LABEL")
        return 1
    fi
}

checkOSPackages() {
    LABEL=$1
    shift
    echo -e "\n🧪 Testing $LABEL"
    if dpkg-query --show -f='${Package}: ${Version}\n' "$@"; then 
        echo "✅  Passed!"
        return 0
    else
        echoStderr "❌ $LABEL check failed."
        FAILED+=("$LABEL")
        return 1
    fi
}

checkExtension() {
    # Happens asynchronusly, so keep retrying 10 times with an increasing delay
    EXTN_ID="$1"
    TIMEOUT_SECONDS="${2:-10}"
    RETRY_COUNT=0
    echo -e -n "\n🧪 Looking for extension $1 for maximum of ${TIMEOUT_SECONDS}s"
    until [ "${RETRY_COUNT}" -eq "${TIMEOUT_SECONDS}" ] || \
        [ ! -e $HOME/.vscode-server/extensions/${EXTN_ID}* ] || \
        [ ! -e $HOME/.vscode-server-insiders/extensions/${EXTN_ID}* ] || \
        [ ! -e $HOME/.vscode-test-server/extensions/${EXTN_ID}* ] || \
        [ ! -e $HOME/.vscode-remote/extensions/${EXTN_ID}* ]
    do
        sleep 1s
        (( RETRY_COUNT++ ))
        echo -n "."
    done

    if [ ${RETRY_COUNT} -lt ${TIMEOUT_SECONDS} ]; then
        echo -e "\n✅ Passed!"
        return 0
    else
        echoStderr -e "\n❌ Extension $EXTN_ID not found."
        FAILED+=("$LABEL")
        return 1
    fi
}

checkCommon()
{
    PACKAGE_LIST="apt-utils \
        openssh-client \
        less \
        iproute2 \
        procps \
        curl \
        wget \
        unzip \
        nano \
        jq \
        lsb-release \
        ca-certificates \
        apt-transport-https \
        dialog \
        gnupg2 \
        libc6 \
        libgcc1 \
        libgssapi-krb5-2 \
        liblttng-ust0 \
        libstdc++6 \
        zlib1g \
        locales \
        gettext \
        sudo"

    # Actual tests
    checkOSPackages "common-os-packages" ${PACKAGE_LIST}
    check "non-root-user" id ${USERNAME}
    check "locale" [ $(locale -a | grep en_US.utf8) ]
    check "sudo" sudo echo "sudo works."
    check "zsh" zsh --version
    check "oh-my-zsh" [ -d "$HOME/.oh-my-zsh" ]
    check "login-shell-path" [ -f "/etc/profile.d/00-restore-env.sh" ]
    check "code" which code
}

reportResults() {
    if [ ${#FAILED[@]} -ne 0 ]; then
        echoStderr -e "\n💥  Failed tests: ${FAILED[@]}"
        exit 1
    else 
        echo -e "\n💯  All passed!"
        exit 0
    fi
}

fixTestProjectFolderPrivs() {
    if [ "${USERNAME}" != "root" ]; then
        TEST_PROJECT_FOLDER="${1:-$SCRIPT_FOLDER}"
        FOLDER_USER="$(stat -c '%U' "${TEST_PROJECT_FOLDER}")"
        if [ "${FOLDER_USER}" != "${USERNAME}" ]; then
            echoStderr "WARNING: Test project folder is owned by ${FOLDER_USER}. Updating to ${USERNAME}."
            sudo chown -R ${USERNAME} "${TEST_PROJECT_FOLDER}"
        fi
    fi
}

checkVersionCount() {
    LABEL=$1
    count=$2
    expectedCount=$3
    echo -e "\n🧪 Testing $LABEL"

    if [ "$count" == "$expectedCount" ]; then
        echo "✅  Passed!"
        return 0
    else
        echoStderr "❌ $LABEL check failed."
        FAILED+=("$LABEL")
        return 1
    fi
}

checkDirectoryOwnership() {
    LABEL=$1
    targetDirectory=$2
    expectedUser=$3
    expectedGroup=$4

    echo -e "\n🧪 Testing $LABEL"

    # Get group metadata
    groupMetadata=$(getent group ${expectedGroup})
    
    # Extract group id and group members
    targetGroupId=$(echo $groupMetadata | cut -d: -f3)
    targetGroupMembers=$(echo $groupMetadata | cut -d: -f4)

    # Get directory ownership metadata
    # Note: "stat" returns the string "UNKNOWN" for %U and %G if it's not defined in the system files. 
    # So it's better to work with UID (%u) and GID (%g) numbers from "stat".
    directoryOwnershipGroupId=$(stat -c "%g" ${targetDirectory})
    
    # Check that group has ownership over directory and user belong to the group
    if [ "$targetGroupId" == "$directoryOwnershipGroupId" ] && [[ "$targetGroupMembers" == *"$expectedUser"* ]]; then
        echo "✅  Passed!"
        return 0
    else
        expected="Expected: Group - $expectedGroup ($targetGroupId), User - $expectedUser"
        got="Got: $(stat -c "Group - %G (%g), User - %U (%u)" ${targetDirectory})"
        echoStderr "❌ $LABEL check failed. $expected $got"
        
        # Provide more context on test failure
        stat ${targetDirectory}
        
        FAILED+=("$LABEL")
        
        return 1
    fi
}

checkPythonPackageVersion()
{
    PYTHON_PATH=$1
    PACKAGE=$2
    REQUIRED_VERSION=$3

    current_version=$(${PYTHON_PATH} -c "import importlib.metadata; print(importlib.metadata.version('${PACKAGE}'))")
    check-version-ge "${PACKAGE}-requirement" "${current_version}" "${REQUIRED_VERSION}"
}

checkCondaPackageVersion()
{
    PACKAGE=$1
    REQUIRED_VERSION=$2
    current_version=$(conda list "${PACKAGE}" | grep -E "^${PACKAGE}\s" | awk '{print $2}')
    check-version-ge "conda-${PACKAGE}-requirement" "${current_version}" "${REQUIRED_VERSION}"
}

checkBundledNpmVersion()
{
    NODE_VERSION=$1
    REQUIRED_NPM_VERSION=$2
    bash -c ". /usr/local/share/nvm/nvm.sh && nvm use ${NODE_VERSION}"

    current_npm_version=$(npm --version)

    if [[ "$NODE_VERSION" != "default" ]]; then
      bash -c ". /usr/local/share/nvm/nvm.sh && nvm use default"
    fi
    
    check-version-ge "node-${NODE_VERSION}-requirement" "${current_npm_version}" "${REQUIRED_NPM_VERSION}"
}
