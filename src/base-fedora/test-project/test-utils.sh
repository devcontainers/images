#!/bin/bash

USERNAME=${1:-vscode}

if [ -z $HOME ]; then
    HOME="/root"
fi

FAILED=()

check() {
    LABEL=$1
    shift
    echo -e "\n🧪 Testing $LABEL"
    if "$@"; then 
        echo "✅  Passed!"
        return 0
    else
        echo "❌ $LABEL check failed."
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
        echo "❌ $LABEL check failed."
        FAILED+=("$LABEL")
        return 1
    fi
}

checkOSPackages() {
    LABEL=$1
    shift
    echo -e "\n🧪 Testing $LABEL"
    if rpm -q --queryformat '%{NAME}: %{VERSION}-%{RELEASE}\n' "$@"; then 
        echo "✅  Passed!"
        return 0
    else
        echo "❌ $LABEL check failed."
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
        echo -e "\n❌ Extension $EXTN_ID not found."
        FAILED+=("$LABEL")
        return 1
    fi
}

checkCommon()
{
    PACKAGE_LIST="openssh-clients \
        gnupg2 \
        iproute \
        procps-ng \
        lsof \
        htop \
        net-tools \
        psmisc \
        curl \
        wget \
        rsync \
        ca-certificates \
        unzip \
        zip \
        nano \
        vim-minimal \
        less \
        jq \
        strace \
        man-db \
        man-pages \
        sudo \
        ncdu \
        zsh"

    checkOSPackages "common-os-packages" ${PACKAGE_LIST}
    check "non-root-user" id ${USERNAME}
    check "locale" sh -c "cat /etc/locale.conf | grep 'LANG=C.UTF-8'"
    check "sudo" sudo echo "sudo works."
    check "zsh" zsh --version
    check "oh-my-zsh" test -d $HOME/.oh-my-zsh
}

reportResults()
{
    if [ ${#FAILED[@]} -ne 0 ]; then
        echo -e "\n💥 Failed tests: ${FAILED[@]}"
        exit 1
    else 
        echo -e "\n💯 All passed!"
        exit 0
    fi
}
