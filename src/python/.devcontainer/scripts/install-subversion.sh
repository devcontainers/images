#!/bin/bash
set -eux

REQUIRED="1.14.5"

# Determine current svn version if present
current=""
if command -v svn >/dev/null 2>&1; then
  current="$(svn --version --quiet 2>/dev/null || true)"
fi

# If current version is >= REQUIRED, skip building
if [ -n "${current}" ] && dpkg --compare-versions "${current}" ge "${REQUIRED}"; then
  echo "Subversion ${current} is >= ${REQUIRED}; skipping build."
  exit 0
fi

URL="https://archive.apache.org/dist/subversion/subversion-1.14.5.tar.gz"
TMP="/tmp"
TARBALL="subversion-1.14.5.tar.gz"
SRCDIR="subversion-1.14.5"

if wget -q -O "${TMP}/${TARBALL}" "${URL}"; then
  echo "Downloaded ${TARBALL} — building..."
  apt-get remove -y subversion libsvn1 || true
  cd "${TMP}"
  tar -xzf "${TARBALL}"
  cd "${SRCDIR}"
  apt-get update -y
  apt-get install -y --no-install-recommends build-essential autoconf libtool libsqlite3-dev pkg-config libapr1-dev libaprutil1-dev liblz4-dev libutf8proc-dev zlib1g-dev
  ./configure --with-lz4=internal --prefix=/usr
  make -j"$(nproc 2>/dev/null || getconf _NPROCESSORS_ONLN 2>/dev/null || echo 1)"
  make install
  cd /
  rm -rf "${TMP:?}/${SRCDIR}" "${TMP:?}/${TARBALL}"
  apt-get purge -y --auto-remove build-essential autoconf libtool pkg-config
  rm -rf /var/lib/apt/lists/*
  echo "Subversion built and installed (build deps removed)"
else
  echo "Downloading svn source failed, skipping Subversion build"
fi

