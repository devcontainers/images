# This Dockerfile uses separate build arguments instead of VARIANT
ARG TARGET_JAVA_VERSION=25
ARG BASE_IMAGE_VERSION_CODENAME=43
FROM ghcr.io/sebst/devcontainers/base-fedora:${BASE_IMAGE_VERSION_CODENAME}

USER root
ARG TARGET_JAVA_VERSION
ENV JAVA_HOME /usr/lib/jvm/msopenjdk-current
ENV PATH "${JAVA_HOME}/bin:${PATH}"
# Default to UTF-8 file.encoding
ENV LANG en_US.UTF-8

# Install Microsoft OpenJDK
RUN arch="$(uname -m)" \
	&& case "$arch" in \
		"x86_64") \
			jdkUrl="https://aka.ms/download-jdk/microsoft-jdk-${TARGET_JAVA_VERSION}-linux-x64.tar.gz"; \
			;; \
		"aarch64") \
			jdkUrl="https://aka.ms/download-jdk/microsoft-jdk-${TARGET_JAVA_VERSION}-linux-aarch64.tar.gz"; \
			;; \
		*) echo >&2 "error: unsupported architecture: '$arch'"; exit 1 ;; \
	esac \
	\
	&& wget --progress=dot:giga -O msopenjdk.tar.gz "${jdkUrl}" \
	&& wget --progress=dot:giga -O sha256sum.txt "${jdkUrl}.sha256sum.txt" \
	\
	&& sha256sumText=$(cat sha256sum.txt) \
	&& sha256=$(expr substr "${sha256sumText}" 1 64) \
	&& echo "${sha256} msopenjdk.tar.gz" | sha256sum --strict --check - \
	&& rm sha256sum.txt* \
	\
	&& mkdir -p "$JAVA_HOME" \
	&& tar --extract \
		--file msopenjdk.tar.gz \
		--directory "$JAVA_HOME" \
		--strip-components 1 \
		--no-same-owner \
	&& rm msopenjdk.tar.gz* \
	\
	&& ln -s ${JAVA_HOME} /docker-java-home \
	&& ln -s ${JAVA_HOME} /usr/local/openjdk-${TARGET_JAVA_VERSION}

# [Optional] Uncomment this section to install additional OS packages.
# RUN dnf -y install <your-package-list-here> \
#     && dnf clean all
