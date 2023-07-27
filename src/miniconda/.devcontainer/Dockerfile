FROM continuumio/miniconda3 as upstream

# Reset and copy updated files with updated privs to keep image size down
FROM mcr.microsoft.com/devcontainers/base:0-bullseye
USER root
COPY --from=upstream /opt /opt/

COPY add-notice.sh /tmp/library-scripts/

# Setup conda to mirror contents from https://github.com/ContinuumIO/docker-images/blob/master/miniconda3/debian/Dockerfile
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
        libxext6 \
        libxrender1 \
        mercurial \
        openssh-client \
        procps \
        subversion \
        wget \    
    && apt-get upgrade -y \
    && bash /tmp/library-scripts/add-notice.sh \
    # && mv -f "/tmp/library-scripts/meta.env" /usr/local/etc/vscode-dev-containers/meta.env \
    && ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh \
    && echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc \
    && echo "conda activate base" >> ~/.bashrc \
    && apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/library-scripts/add-notice.sh

# Copy environment.yml (if found) to a temp locaition so we update the environment. Also
# copy "noop.txt" so the COPY instruction does not fail if no environment.yml exists.
COPY environment.yml* noop.txt /tmp/conda-tmp/
RUN if [ -f "/tmp/conda-tmp/environment.yml" ]; then umask 0002 && /opt/conda/bin/conda env update -n base -f /tmp/conda-tmp/environment.yml; fi \
    && rm -rf /tmp/conda-tmp

# Temporary: Upgrade python packages due to mentioned CVEs
# They are installed by the base image (continuumio/miniconda3) which does not have the patch.
RUN conda install \ 
    # https://github.com/pyca/cryptography/security/advisories/GHSA-5cpq-8wj7-hf2v
    pyopenssl=23.2.0 \ 
    cryptography=41.0.2 \
    # https://github.com/advisories/GHSA-j8r2-6x86-q33q
    requests=2.31.0

# [Optional] Uncomment this section to install additional OS packages.
# RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
#     && apt-get -y install --no-install-recommends <your-package-list-here>

# Create conda group, update conda directory permissions, 
# add user to conda group
# Note: We need to execute these commands after pip install / conda update 
# since pip doesn't preserve directory permissions
RUN groupadd -r conda --gid 900 \
    && chown -R :conda /opt/conda \
    && chmod -R g+w /opt/conda \
    && find /opt -type d | xargs -n 1 chmod g+s \
    && usermod -aG conda ${USERNAME}
