# [Choice] Python version (use -bookworm variants on local arm64/Apple Silicon): 3, 3.14, 3.13, 3.12, 3.11, 3.10, 3-bookworm, 3.14-bookworm, 3.13-bookworm, 3.12-bookworm, 3.11-bookworm, 3.10-bookworm
ARG VARIANT=3-trixie
FROM python:${VARIANT}

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    # Remove imagemagick due to https://security-tracker.debian.org/tracker/CVE-2019-10131
    && apt-get purge -y imagemagick imagemagick-6-common 

# Temporary: Upgrade python packages due to https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2022-40897 and https://github.com/advisories/GHSA-2mqj-m65w-jghx
# They are installed by the base image (python) which does not have the patch.
RUN python3 -m pip install --upgrade \
    gitpython==3.1.50 \
    setuptools==82.0.1 \
    wheel==0.46.3

# Fixing vulnerability issue by upgrading svn to 1.14.5. Ref https://subversion.apache.org/security/CVE-2024-46901-advisory.txt
COPY ./scripts/install-subversion.sh /tmp/install-subversion.sh
RUN chmod +x /tmp/install-subversion.sh
RUN /tmp/install-subversion.sh \
  && rm -f /tmp/install-subversion.sh

# [Optional] If your pip requirements rarely change, uncomment this section to add them to the image.
# COPY requirements.txt /tmp/pip-tmp/
# RUN pip3 --disable-pip-version-check --no-cache-dir install -r /tmp/pip-tmp/requirements.txt \
#    && rm -rf /tmp/pip-tmp

# [Optional] Uncomment this section to install additional OS packages.
# RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
#     && apt-get -y install --no-install-recommends <your-package-list-here>

# [Optional] Uncomment this line to install global node packages.
# RUN su vscode -c "source /usr/local/share/nvm/nvm.sh && npm install -g <your-package-here>" 2>&1
