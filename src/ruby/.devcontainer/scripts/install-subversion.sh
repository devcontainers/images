#!/bin/bash
set -eux

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
  apt-get install -y --no-install-recommends build-essential autoconf libtool pkg-config libapr1-dev libaprutil1-dev liblz4-dev libutf8proc-dev
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
