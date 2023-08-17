FROM continuumio/anaconda3 as upstream

# Verify OS version is expected one
RUN . /etc/os-release && if [ "${VERSION_CODENAME}" != "bullseye" ]; then exit 1; fi

# Temporary: Upgrade python packages due to mentioned CVEs
# They are installed by the base image (continuumio/anaconda3) which does not have the patch.
RUN conda install \ 
    # https://github.com/advisories/GHSA-5cpq-8wj7-hf2v
    pyopenssl=23.2.0 \ 
    cryptography=41.0.2 \
    # https://github.com/advisories/GHSA-j8r2-6x86-q33q
    requests=2.31.0 \
    # https://github.com/advisories/GHSA-f865-m6cq-j9vx
    mpmath==1.3.0

RUN python3 -m pip install --upgrade \
    # https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2022-21797
    joblib==1.3.1 \
    # https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2022-24065
    cookiecutter==2.2.3 \
    # https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2022-34749
    mistune==3.0.1 \
    # https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2021-34141
    numpy==1.25.2 \
    # https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2023-25577
    werkzeug==2.3.6 \
    # https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2021-32862
    nbconvert==7.7.3 \
    # https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2023-28370
    tornado==6.3.2 \
    # https://github.com/advisories/GHSA-282v-666c-3fvg
    transformers==4.30.0 \
    # https://github.com/advisories/GHSA-45c4-8wx5-qw6w
    aiohttp==3.8.5

# Reset and copy updated files with updated privs to keep image size down
FROM mcr.microsoft.com/devcontainers/base:1-bullseye

ARG USERNAME=vscode

# Create the conda group and add remote user to the group
RUN groupadd -r conda --gid 900 \ 
    && usermod -aG conda ${USERNAME}

# Copy opt folder, set ownership and group permissions
COPY --chown=:conda --chmod=775 --from=upstream /opt/conda /opt/conda
RUN chmod =2775 /opt/conda

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
    && apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/library-scripts/add-notice.sh

# Copy environment.yml (if found) to a temp location so we can update the environment. Also
# copy "noop.txt" so the COPY instruction does not fail if no environment.yml exists.
# COPY environment.yml* .devcontainer/noop.txt /tmp/conda-tmp/
COPY environment.yml* noop.txt /tmp/conda-tmp/
RUN if [ -f "/tmp/conda-tmp/environment.yml" ]; then umask 0002 && /opt/conda/bin/conda env update -n base -f /tmp/conda-tmp/environment.yml; fi \
    && rm -rf /tmp/conda-tmp

# [Optional] Uncomment this section to install additional OS packages.
# RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
#     && apt-get -y install --no-install-recommends <your-package-list-here>
