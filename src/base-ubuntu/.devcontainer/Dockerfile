ARG VARIANT="noble"
FROM buildpack-deps:${VARIANT}-curl

LABEL dev.containers.features="common"

ARG VARIANT
ENV VARIANT=${VARIANT}

RUN if [ "$VARIANT" = "noble" ]; then \
        # Check if ubuntu user exists and delete it if it does
        if id "ubuntu" &>/dev/null; then \
            echo "Deleting user ubuntu" && userdel -r ubuntu || echo "Failed to delete ubuntu user"; \
        else \
            echo "User ubuntu does not exist"; \
        fi; \
        # Ensure UID 1000 is not in use by another user
        if id -u 1000 &>/dev/null; then \
            echo "UID 1000 is already taken by another user. Exiting."; \
        else \
            # Check if vscode user exists, if not create it
            if ! id "vscode" &>/dev/null; then \
                echo "Creating user vscode" && useradd -m vscode || echo "Failed to create vscode user"; \
            fi; \
            # Modify vscode user and group only if they exist
            echo "Modifying user vscode UID" && usermod -u 1000 vscode || echo "Failed to modify vscode UID"; \
            echo "Modifying group vscode GID" && groupmod -g 1000 vscode || echo "Failed to modify vscode GID"; \
        fi; \
    fi > /tmp/logfile.txt 2>&1


# [Optional] Uncomment this section to install additional OS packages.
# RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
#     && apt-get -y install --no-install-recommends <your-package-list-here>
