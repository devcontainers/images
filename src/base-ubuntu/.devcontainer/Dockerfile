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
            #check if group 1000 and user 1000 is deleted
            echo "Checking user at 1000 uid" && getent passwd 1000 || echo "Failed to find user at uid 1000;" \
            echo "Checking group at 1000 gid" &&  getent group 1000 || echo "Failed to find group at gid 1000"; \
        else \
            echo "User ubuntu does not exist"; \
        fi; \
    else \
        echo "Variant does not contain noble"; \
    fi

# [Optional] Uncomment this section to install additional OS packages.
# RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
#     && apt-get -y install --no-install-recommends <your-package-list-here>
