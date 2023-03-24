FROM continuumio/anaconda3 as upstream

# Verify OS version is expected one
RUN . /etc/os-release && if [ "${VERSION_CODENAME}" != "bullseye" ]; then exit 1; fi

# Update, change owner
RUN groupadd -r conda --gid 900 \
    && chown -R :conda /opt/conda \
    && chmod -R g+w /opt/conda \
    && find /opt -type d | xargs -n 1 chmod g+s

# Reset and copy updated files with updated privs to keep image size down
FROM mcr.microsoft.com/devcontainers/base:0-bullseye
COPY --from=upstream /opt /opt/
USER root

# Copy scripts to execute
COPY add-notice.sh /tmp/library-scripts/

# Setup conda to mirror contents from https://github.com/ContinuumIO/docker-images/blob/master/anaconda3/debian/Dockerfile
ENV LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    PATH=/opt/conda/bin:$PATH
ARG USERNAME=vscode
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get install -y --no-install-recommends \
        bzip2 \
        ca-certificates \
        libglib2.0-0 \
        libsm6 \
        libxcomposite1 \
        libxcursor1 \
        libxdamage1 \
        libxext6 \
        libxfixes3 \
        libxi6 \
        libxinerama1 \
        libxrandr2 \
        libxrender1 \
        mercurial \
        openssh-client \
        procps \
        subversion \
        wget \
    && apt-get upgrade -y \
    && bash /tmp/library-scripts/add-notice.sh \
    && ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh \
    && echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc \
    && echo "conda activate base" >> ~/.bashrc \
    && groupadd -r conda --gid 900 \
    && usermod -aG conda ${USERNAME} \
    && apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/library-scripts/add-notice.sh

# Temporary: Upgrade python packages due to mentioned CVEs
# They are installed by the base image (continuumio/anaconda3) which does not have the patch.
RUN python3 -m pip install \
    # https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2022-21797
    --upgrade joblib \
    # https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2022-24065
    cookiecutter \
    # https://github.com/advisories/GHSA-39hc-v87j-747x
    cryptography \
    # https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2022-34749
    mistune \
    # https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2021-34141
    numpy \
    # https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2022-23491
    certifi \
    # https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2022-40897
    setuptools \
    # https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2022-40899
    future \
    # https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2022-40898
    wheel \
    # https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2021-32862
    nbconvert \
    # https://github.com/devcontainers/images/issues/486
    pyOpenssl \
    # https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2023-25577
    werkzeug

# Copy environment.yml (if found) to a temp location so we can update the environment. Also
# copy "noop.txt" so the COPY instruction does not fail if no environment.yml exists.
# COPY environment.yml* .devcontainer/noop.txt /tmp/conda-tmp/
COPY environment.yml* noop.txt /tmp/conda-tmp/
RUN if [ -f "/tmp/conda-tmp/environment.yml" ]; then umask 0002 && /opt/conda/bin/conda env update -n base -f /tmp/conda-tmp/environment.yml; fi \
    && rm -rf /tmp/conda-tmp

# [Optional] Uncomment this section to install additional OS packages.
# RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
#     && apt-get -y install --no-install-recommends <your-package-list-here>
