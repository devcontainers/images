ARG VARIANT="resolute"
FROM buildpack-deps:${VARIANT}-curl

LABEL dev.containers.features="common"

ARG VARIANT
RUN if [ "$VARIANT" = "noble" ] || [ "$VARIANT" = "resolute" ]; then \
    if id "ubuntu" &>/dev/null; then \
        echo "Deleting user 'ubuntu'  for $VARIANT" && userdel -f -r ubuntu || echo "Failed to delete ubuntu user for $VARIANT"; \
    else \
         echo "User 'ubuntu' does not exist for $VARIANT"; \
    fi; \
    fi

# [Optional] Uncomment this section to install additional OS packages.
# RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
#     && apt-get -y install --no-install-recommends <your-package-list-here>

# Local fix for issue with timezone data at 'buildpack-deps'. Ref# https://github.com/devcontainers/images/issues/1709
RUN apt-get update \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y reinstall --no-install-recommends tzdata \
    && echo "Etc/UTC" > /etc/timezone \
    && rm -rf /var/lib/apt/lists/*
