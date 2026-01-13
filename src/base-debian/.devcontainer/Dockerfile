# [Choice] Debian version (use bullseye on local arm64/Apple Silicon): trixie, bookworm, bullseye, buster
ARG VARIANT="trixie"
FROM buildpack-deps:${VARIANT}-curl

# [Optional] Uncomment this section to install additional OS packages.
# RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
#     && apt-get -y install --no-install-recommends <your-package-list-here>

# Mainly done to upgrade packages to avoid security issues
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get upgrade -y \
    && rm -rf /var/lib/apt/lists/*

