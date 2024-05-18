FROM continuumio/anaconda3 as upstream

# Verify OS version is expected one
RUN . /etc/os-release && if [ "${VERSION_CODENAME}" != "bullseye" ]; then exit 1; fi

# Temporary: Upgrade python packages due to mentioned CVEs
# They are installed by the base image (continuumio/anaconda3) which does not have the patch.
RUN conda install \
    # https://github.com/advisories/GHSA-v845-jxx5-vc9f
    urllib3==1.26.18 \
    # https://github.com/advisories/GHSA-mr82-8j83-vxmv
    pydantic==2.5.3

RUN python3 -m pip install --upgrade \
    # https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2022-21797
    joblib==1.3.1 \
    # https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2022-24065
    cookiecutter==2.2.3 \
    # https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2022-34749
    mistune==3.0.1 \
    # https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2021-34141
    numpy==1.25.2 \
    # https://github.com/advisories/GHSA-2g68-c3qc-8985
    werkzeug==3.0.3 \
    # https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2021-32862
    nbconvert==7.7.3 \
    # https://github.com/advisories/GHSA-qppv-j76h-2rpx
    tornado==6.3.3 \
    # https://github.com/advisories/GHSA-r726-vmfq-j9j3 
    jupyter_server==2.7.2 \
    # https://github.com/advisories/GHSA-5wvp-7f3h-6wmm
    pyarrow==14.0.1 \
    # https://github.com/advisories/GHSA-v68g-wm8c-6x7j
    transformers==4.36.0 \
    # https://github.com/advisories/GHSA-44wm-f244-xhp3
    pillow==10.3.0 \
    # https://github.com/advisories/GHSA-44cc-43rp-5947
    jupyterlab==4.0.11 \
    # https://github.com/advisories/GHSA-5h86-8mv2-jq9f
    aiohttp==3.9.4 \
    # https://github.com/advisories/GHSA-6vqw-3v5j-54x4
    cryptography==42.0.4 \
    # https://github.com/advisories/GHSA-2mqj-m65w-jghx
    gitpython==3.1.41 \
    # https://github.com/advisories/GHSA-4qhp-652w-c22x
    jupyter-lsp==2.2.2 \
    # https://github.com/advisories/GHSA-jjg7-2v4v-x38h
    idna==3.7 \ 
    # https://github.com/advisories/GHSA-h75v-3vvj-5mfj
    jinja2==3.1.4

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
