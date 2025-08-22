ARG VARIANT=24-bookworm
FROM node:${VARIANT}

ARG USERNAME=node
ARG NPM_GLOBAL=/usr/local/share/npm-global

# Add NPM global to PATH.
ENV PATH=${NPM_GLOBAL}/bin:${PATH}

RUN \
    # Configure global npm install location, use group to adapt to UID/GID changes
    if ! cat /etc/group | grep -e "^npm:" > /dev/null 2>&1; then groupadd -r npm; fi \
    && usermod -a -G npm ${USERNAME} \
    && umask 0002 \
    && mkdir -p ${NPM_GLOBAL} \
    && touch /usr/local/etc/npmrc \
    && chown ${USERNAME}:npm ${NPM_GLOBAL} /usr/local/etc/npmrc \
    && chmod g+s ${NPM_GLOBAL} \
    && npm config -g set prefix ${NPM_GLOBAL} \
    && su ${USERNAME} -c "npm config -g set prefix ${NPM_GLOBAL}" \
    # Install eslint
    && su ${USERNAME} -c "umask 0002 && npm install -g eslint" \
    && npm cache clean --force > /dev/null 2>&1

# Fixing vulnerability issue by upgrading svn to 1.14.5. Ref https://subversion.apache.org/security/CVE-2024-46901-advisory.txt
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

# [Optional] Uncomment if you want to install an additional version of node using nvm
# ARG EXTRA_NODE_VERSION=10
# RUN su node -c "source /usr/local/share/nvm/nvm.sh && nvm install ${EXTRA_NODE_VERSION}"

# [Optional] Uncomment if you want to install more global node modules
# RUN su node -c "npm install -g <your-package-list-here>"
