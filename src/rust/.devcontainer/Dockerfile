# [Choice] Debian OS version (use bookworm, or bullseye on local arm64/Apple Silicon): bookworm, buster, bullseye
ARG VARIANT="trixie"
FROM rust:1-${VARIANT}

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    # Remove imagemagick due to https://security-tracker.debian.org/tracker/CVE-2019-10131
    && apt-get purge -y imagemagick imagemagick-6-common

# Fixing vulnerability issue by upgrading svn to 1.14.5. Ref https://subversion.apache.org/security/CVE-2024-46901-advisory.txt
COPY ./scripts/install-subversion.sh /tmp/install-subversion.sh
RUN chmod +x /tmp/install-subversion.sh
RUN /tmp/install-subversion.sh \
  && rm -f /tmp/install-subversion.sh

# [Optional] Uncomment this section to install additional OS packages.
# RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
#     && apt-get -y install --no-install-recommends <your-package-list-here>
