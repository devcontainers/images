# This Dockerfile uses separate build arguments instead of VARIANT
ARG TARGET_JAVA_VERSION=23
ARG BASE_IMAGE_VERSION_CODENAME=bookworm
FROM mcr.microsoft.com/devcontainers/base:${BASE_IMAGE_VERSION_CODENAME}

USER root
ARG TARGET_JAVA_VERSION
ENV JAVA_HOME /usr/lib/jvm/msopenjdk-current
ENV PATH "${JAVA_HOME}/bin:${PATH}"
# Default to UTF-8 file.encoding
ENV LANG en_US.UTF-8

# Install Microsoft OpenJDK
RUN arch="$(dpkg --print-architecture)" \
	&& case "$arch" in \
		"amd64") \
		if [ "$TARGET_JAVA_VERSION" -gt 21 ]; then \
			jdkUrl="https://download.oracle.com/java/${TARGET_JAVA_VERSION}/latest/jdk-${TARGET_JAVA_VERSION}_linux-x64_bin.tar.gz"; \
		else \
			jdkUrl="https://aka.ms/download-jdk/microsoft-jdk-${TARGET_JAVA_VERSION}-linux-x64.tar.gz"; \
		fi \
		;; \
	"arm64") \
		if [ "$TARGET_JAVA_VERSION" -gt 21 ]; then \
			jdkUrl="https://download.oracle.com/java/${TARGET_JAVA_VERSION}/latest/jdk-${TARGET_JAVA_VERSION}_linux-aarch64_bin.tar.gz"; \
		else \
			jdkUrl="https://aka.ms/download-jdk/microsoft-jdk-${TARGET_JAVA_VERSION}-linux-aarch64.tar.gz"; \
		fi \
		;; \
		*) echo >&2 "error: unsupported architecture: '$arch'"; exit 1 ;; \
	esac \
	\
    && wget --progress=dot:giga -O msopenjdk.tar.gz "${jdkUrl}" \
    && if [ "$TARGET_JAVA_VERSION" -gt 21 ]; then \
        wget --progress=dot:giga -O jdk-${TARGET_JAVA_VERSION}_linux-${arch}_sha256 "${jdkUrl}.sha256"; \
    else \
        wget --progress=dot:giga -O jdk-${TARGET_JAVA_VERSION}_linux-${arch}_sha256sum.txt "${jdkUrl}.sha256sum.txt"; \
    fi \
	\
	&& if [ "$TARGET_JAVA_VERSION" -gt 21 ]; then \
		sha256sumText=$(cat jdk-${TARGET_JAVA_VERSION}_linux-${arch}_sha256); \
	else \
		sha256sumText=$(cat jdk-${TARGET_JAVA_VERSION}_linux-${arch}_sha256sum.txt); \
	fi \
    && sha256=$(echo "${sha256sumText}" | awk '{print $1}') \
	&& echo "${sha256} msopenjdk.tar.gz" | sha256sum --strict --check - \
	&& rm jdk-${TARGET_JAVA_VERSION}_linux-${arch}_sha256* \
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
# RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
#     && apt-get -y install --no-install-recommends <your-package-list-here>
