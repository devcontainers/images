# [Choice] Fedora version: 43, 42
ARG VARIANT="43"
FROM fedora:${VARIANT}

# [Optional] Uncomment this section to install additional OS packages.
# RUN dnf -y install <your-package-list-here> \
#     && dnf clean all

# Upgrade packages to avoid security issues
RUN dnf -y update \
    && dnf clean all
