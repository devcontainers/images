# [Choice] Go version (use -bookworm, or -bullseye variants on local arm64/Apple Silicon): 1, 1.21, 1.20, 1-bookworm, 1.21-bookworm, 1.20-bookworm, 1-bullseye, 1.21-bullseye, 1.20-bullseye
ARG VARIANT=1.21-bookworm
FROM golang:${VARIANT}

# [Optional] Uncomment the next line to use go get to install anything else you need
# RUN go get -x <your-dependency-or-tool>

# [Optional] Uncomment this section to install additional OS packages.
# RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
#     && apt-get -y install --no-install-recommends <your-package-list-here>

# [Optional] Uncomment this line to install global node packages.
# RUN su vscode -c "source /usr/local/share/nvm/nvm.sh && npm install -g <your-package-here>" 2>&1
