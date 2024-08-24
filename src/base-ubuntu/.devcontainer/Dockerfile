ARG VARIANT="noble"
FROM buildpack-deps:${VARIANT}-curl

LABEL dev.containers.features="common"

ARG VARIANT
ENV VARIANT=${VARIANT}

RUN if [ "$VARIANT" = "noble" ]; then \
        echo "Variant contains noble"; \
        # Check if ubuntu user exists and delete it if it does
        if id "ubuntu" &>/dev/null; then \
            echo "Deleting user ubuntu" && userdel -f -r ubuntu || echo "Failed to delete ubuntu user"; \
            echo "Deleting group associated with ubuntu" && groupdel ubuntu || echo "Failed to delete group associated with ubuntu user"; \
        else \
            echo "User ubuntu does not exist"; \
        fi; \
    else \
        echo "Variant does not contain noble"; \
    fi > /tmp/logfile.txt 2>&1

# [Optional] Uncomment this section to install additional OS packages.
# RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
#     && apt-get -y install --no-install-recommends <your-package-list-here>
