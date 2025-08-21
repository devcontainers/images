ARG VARIANT=3.3-bookworm
FROM mcr.microsoft.com/devcontainers/ruby:${VARIANT}

USER root

# ENV Variables required by Jekyll
ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    TZ=Etc/UTC \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US

# Install bundler, latest jekyll, and github-pages for older jekyll
RUN gem update --system

# https://github.com/ntkme/sass-embedded-host-ruby/issues/130
RUN gem install sass-embedded -v 1.62.1
RUN gem install jekyll-sass-converter -v 3.0.0
RUN gem install bundler jekyll github-pages

RUN chown -R "vscode:rvm" "/usr/local/rvm/" \
    && chmod -R g+r+w "/usr/local/rvm/" \
    && find "/usr/local/rvm/" -type d | xargs -n 1 chmod g+s

COPY post-create.sh /usr/local/post-create.sh

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

# [Optional] Uncomment this line to install global node packages.
# RUN su vscode -c "source /usr/local/share/nvm/nvm.sh && npm install -g <your-package-here>" 2>&1
