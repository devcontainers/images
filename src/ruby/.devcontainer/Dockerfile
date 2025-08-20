# [Choice] Ruby version (use -bullseye variants on local arm64/Apple Silicon): 3, 3.4, 3.3, 3.2, 3-bookworm, 3.4-bookworm, 3.3-bookworm, 3.2-bookworm, 3-bullseye, 3.4-bullseye, 3.3-bullseye, 3.2-bullseye, 3-buster, 3.2-buster
ARG VARIANT=3-bookworm
FROM ruby:${VARIANT}

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    # Remove imagemagick due to https://security-tracker.debian.org/tracker/CVE-2019-10131
    && apt-get purge -y imagemagick imagemagick-6-common 

# Fixing vulnerability issue CVE-2024-46901 by upgrading svn to 1.14.5. Ref https://subversion.apache.org/security/CVE-2024-46901-advisory.txt
RUN set -eux; \
    URL="https://archive.apache.org/dist/subversion/subversion-1.14.5.tar.gz"; \
    TMP="/tmp"; \
    TARBALL="subversion-1.14.5.tar.gz"; \
    SRCDIR="subversion-1.14.5"; \
    if wget -q -O "${TMP}/${TARBALL}" "${URL}"; then \
      echo "Downloaded ${TARBALL} — building..."; \
      apt-get remove -y subversion libsvn1 || true; \
      cd "${TMP}"; \
      tar -xzf "${TARBALL}"; \
      cd "${SRCDIR}"; \
      apt-get update -y; \
      apt-get install -y --no-install-recommends build-essential autoconf libtool pkg-config libapr1-dev libaprutil1-dev liblz4-dev libutf8proc-dev; \
      ./configure --with-lz4=internal --prefix=/usr; \
      make -j"$(nproc 2>/dev/null || getconf _NPROCESSORS_ONLN 2>/dev/null || echo 1)"; \
      make install; \
      cd /; \
      rm -rf "${TMP:?}/${SRCDIR}" "${TMP:?}/${TARBALL}"; \
      apt-get purge -y --auto-remove build-essential autoconf libtool pkg-config; \
      rm -rf /var/lib/apt/lists/*; \
      echo "Subversion built and installed (build deps removed)"; \
    else \
      echo "Downloading svn source failed, skipping Subversion build"; \
    fi    

# [Optional] Uncomment this section to install additional OS packages.
# RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
#     && apt-get -y install --no-install-recommends <your-package-list-here>

# [Optional] Uncomment this line to install additional gems.
# RUN gem install <your-gem-names-here>

# [Optional] Uncomment this line to install global node packages.
# RUN su vscode -c "source /usr/local/share/nvm/nvm.sh && npm install -g <your-package-here>" 2>&1
