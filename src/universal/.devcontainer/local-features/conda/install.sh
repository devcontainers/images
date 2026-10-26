#!/usr/bin/env bash
#-------------------------------------------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See https://go.microsoft.com/fwlink/?linkid=2090316 for license information.
#-------------------------------------------------------------------------------------------------------------

VERSION=${VERSION:-"latest"}
ADD_CONDA_FORGE=${ADDCONDAFORGE:-"false"}

USERNAME="${USERNAME:-"${_REMOTE_USER:-"automatic"}"}"
UPDATE_RC="true"
CONDA_DIR="/opt/conda"

set -eux
export DEBIAN_FRONTEND=noninteractive

# Clean up
rm -rf /var/lib/apt/lists/*

if [ "$(id -u)" -ne 0 ]; then
    echo -e 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
    exit 1
fi

# Ensure that login shells get the correct path if the user updated the PATH using ENV.
rm -f /etc/profile.d/00-restore-env.sh
echo "export PATH=${PATH//$(sh -lc 'echo $PATH')/\$PATH}" > /etc/profile.d/00-restore-env.sh
chmod +x /etc/profile.d/00-restore-env.sh

# Determine the appropriate non-root user
if [ "${USERNAME}" = "auto" ] || [ "${USERNAME}" = "automatic" ]; then
    USERNAME=""
    POSSIBLE_USERS=("vscode" "node" "codespace" "$(awk -v val=1000 -F ":" '$3==val{print $1}' /etc/passwd)")
    for CURRENT_USER in "${POSSIBLE_USERS[@]}"; do
        if id -u "${CURRENT_USER}" > /dev/null 2>&1; then
            USERNAME="${CURRENT_USER}"
            break
        fi
    done
    if [ "${USERNAME}" = "" ]; then
        USERNAME=root
    fi
elif [ "${USERNAME}" = "none" ] || ! id -u ${USERNAME} > /dev/null 2>&1; then
    USERNAME=root
fi

architecture="$(uname -m)"
case "${architecture}" in
    x86_64) MINICONDA_ARCH="x86_64" ;;
    aarch64|arm64) MINICONDA_ARCH="aarch64" ;;
    *)
        echo "(!) Architecture $architecture unsupported"
        exit 1
    ;;
esac

# Checks if packages are installed and installs them if not
check_packages() {
    if ! dpkg -s "$@" > /dev/null 2>&1; then
        if [ "$(find /var/lib/apt/lists/* | wc -l)" = "0" ]; then
            echo "Running apt-get update..."
            apt-get update -y
        fi
        apt-get -y install --no-install-recommends "$@"
    fi
}

sudo_if() {
    COMMAND="$*"
    if [ "$(id -u)" -eq 0 ] && [ "$USERNAME" != "root" ]; then
        su - "$USERNAME" -c "$COMMAND"
    else
        "$@"
    fi
}

accept_anaconda_tos_if_needed() {
    if ! "${CONDA_DIR}/bin/conda" tos --help > /dev/null 2>&1; then
        return 0
    fi

    for channel in "https://repo.anaconda.com/pkgs/main" "https://repo.anaconda.com/pkgs/r"; do
        echo "Accepting Conda Terms of Service for ${channel}..."
        # Accept as root (for install-time commands)
        "${CONDA_DIR}/bin/conda" tos accept --override-channels --channel "${channel}"
        # Accept as the target user (for runtime usage)
        sudo_if "${CONDA_DIR}/bin/conda" tos accept --override-channels --channel "${channel}"
    done
}

clean_conda_cache() {
    "${CONDA_DIR}/bin/conda" clean --all --yes

    # pip upgrades can leave older, extracted Conda packages behind.
    for pkg_path in "${CONDA_DIR}"/pkgs/pip-[0-9]*; do
        [ -e "${pkg_path}" ] || continue
        pkg_name="$(basename "${pkg_path}")"
        pkg_version="${pkg_name#pip-}"
        pkg_version="${pkg_version%%-*}"
        greater_version="$(printf '%s\n%s\n' "${pkg_version}" "26.1" | sort -V | tail -1)"
        if [ "${pkg_version}" != "${greater_version}" ]; then
            rm -rf "${pkg_path}"
        fi
    done

    find "${CONDA_DIR}" -type f -name '*.pyc' -delete
    find "${CONDA_DIR}" -type d -name '__pycache__' -prune -exec rm -rf {} +
    rm -rf "${CONDA_DIR}/pkgs/cache" /root/.cache/pip
    if [ "${USERNAME}" != "root" ]; then
        rm -rf "/home/${USERNAME}/.cache/pip"
    fi
}

# Install Conda if it's missing
if ! conda --version &> /dev/null ; then
    if ! cat /etc/group | grep -e "^conda:" > /dev/null 2>&1; then
        groupadd -r conda
    fi
    usermod -a -G conda "${USERNAME}"

    # Install dependencies
    check_packages curl ca-certificates

    echo "Installing Conda via Miniconda installer..."

    # Download and run the official Miniconda installer
    MINICONDA_INSTALLER="$(mktemp -t miniconda_XXXXXX.sh)"
    MINICONDA_URL="https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-${MINICONDA_ARCH}.sh"

    echo "Downloading Miniconda installer from ${MINICONDA_URL}..."
    if ! curl -fsSL --connect-timeout 10 --max-time 120 "${MINICONDA_URL}" -o "${MINICONDA_INSTALLER}"; then
        echo "ERROR: Failed to download Miniconda installer from ${MINICONDA_URL}"
        rm -f "${MINICONDA_INSTALLER}"
        exit 1
    fi

    # Run installer in batch mode (no prompts) and install to CONDA_DIR
    bash "${MINICONDA_INSTALLER}" -b -p "${CONDA_DIR}"
    rm -f "${MINICONDA_INSTALLER}"

    # Conda defaults channels now require a non-interactive ToS acknowledgement.
    accept_anaconda_tos_if_needed

    # Install specific conda version if requested (latest Miniconda already bundles a recent conda)
    if [ "${VERSION}" != "latest" ]; then
        echo "Installing conda version ${VERSION}..."
        if ! "${CONDA_DIR}/bin/conda" install -y "conda=${VERSION}"; then
            echo "ERROR: Failed to install conda version ${VERSION}. Please verify the version is valid and available."
            exit 1
        fi
    fi

    CONDA_SCRIPT="${CONDA_DIR}/etc/profile.d/conda.sh"
    . $CONDA_SCRIPT

    if [ "${ADD_CONDA_FORGE}" = "true" ]; then
        conda config --add channels conda-forge
    fi

    conda config --set channel_priority strict
    conda config --set env_prompt '({name})'
    echo "source ${CONDA_SCRIPT}" >> ~/.bashrc

    chown -R "${USERNAME}:conda" "${CONDA_DIR}"
    chmod -R g+r+w "${CONDA_DIR}"

    find "${CONDA_DIR}" -type d -print0 | xargs -n 1 -0 chmod g+s
fi

# Apply Universal's security patches before committing the Conda installation layer.
# https://github.com/advisories/GHSA-537c-gmf6-5ccf
# https://nvd.nist.gov/vuln/detail/CVE-2025-6176
sudo_if "${CONDA_DIR}/bin/conda" install -y -c defaults \
    cryptography=50.0.0 \
    pyopenssl=26.4.0 \
    openssl=3.5.8 \
    brotli=1.2.0

# Upgrade pip after Conda so the solver cannot downgrade the patched pip version.
# https://github.com/advisories/GHSA-jp4c-xjxw-mgf9
# https://github.com/advisories/GHSA-mf9w-mj56-hr94
sudo_if "${CONDA_DIR}/bin/python3" -m pip install --upgrade --no-cache-dir pip
sudo_if "${CONDA_DIR}/bin/python3" -m pip install --upgrade --no-cache-dir python-dotenv==1.2.2

clean_conda_cache

# Display a notice on conda when not running in GitHub Codespaces
mkdir -p /usr/local/etc/vscode-dev-containers
cat << 'EOF' > /usr/local/etc/vscode-dev-containers/conda-notice.txt
When using "conda" from outside of GitHub Codespaces, note the Anaconda repository contains
restrictions on commercial use that may impact certain organizations. See https://aka.ms/ghcs-conda

EOF

notice_script="$(cat << 'EOF'
if [ -t 1 ] && [ "${IGNORE_NOTICE}" != "true" ] && [ "${TERM_PROGRAM}" = "vscode" ] && [ "${CODESPACES}" != "true" ] && [ ! -f "$HOME/.config/vscode-dev-containers/conda-notice-already-displayed" ]; then
    cat "/usr/local/etc/vscode-dev-containers/conda-notice.txt"
    mkdir -p "$HOME/.config/vscode-dev-containers"
    ((sleep 10s; touch "$HOME/.config/vscode-dev-containers/conda-notice-already-displayed") &)
fi
EOF
)"

if [ -f "/etc/zsh/zshrc" ]; then
    echo "${notice_script}" | tee -a /etc/zsh/zshrc
fi

if [ -f "/etc/bash.bashrc" ]; then
    echo "${notice_script}" | tee -a /etc/bash.bashrc
fi

# Clean up
rm -rf /var/lib/apt/lists/*

echo "Done!"
