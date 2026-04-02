ARG VARIANT=43
FROM ghcr.io/sebst/devcontainers/base-fedora:${VARIANT}
USER root

# Install needed packages. Use a separate RUN statement to add your own dependencies.
RUN dnf -y install gcc gcc-c++ make cmake cppcheck valgrind clang lldb llvm gdb \
    # [Optional] Additional packages required for using vcpkg package manager in manifest mode.
    # [Optional] Please uncommment if the below line in needed.
    # && dnf -y install autoconf automake libtool m4 autoconf-archive \
    && dnf clean all

# Setup ENV vars for vcpkg
ENV VCPKG_ROOT=/usr/local/vcpkg \
    VCPKG_DOWNLOADS=/usr/local/vcpkg-downloads
ENV PATH="${PATH}:${VCPKG_ROOT}"

ARG USERNAME=vscode

# Install vcpkg itself: https://github.com/microsoft/vcpkg/blob/master/README.md#quick-start-unix
COPY base-scripts/install-vcpkg.sh /tmp/
RUN chmod +x /tmp/install-vcpkg.sh \
    && ./tmp/install-vcpkg.sh ${USERNAME} \
    && rm -f /tmp/install-vcpkg.sh

# [Optional] Uncomment this section to install additional OS packages.
# RUN dnf -y install <your-package-list-here> \
#     && dnf clean all
