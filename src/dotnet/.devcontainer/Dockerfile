ARG VARIANT=8.0-noble
FROM mcr.microsoft.com/dotnet/sdk:${VARIANT}
ENV PATH $PATH:/home/vscode/.dotnet:/home/vscode/.dotnet/tools

ARG VARIANT
ENV VARIANT=${VARIANT}

RUN if [ "${VARIANT#*noble}" != "$VARIANT" ]; then \
        echo "Variant contains noble"; \
        # Check if ubuntu user exists and delete it if it does
        if id "ubuntu" &>/dev/null; then \
            echo "Deleting user ubuntu" && userdel -r ubuntu || echo "Failed to delete ubuntu user"; \
        else \
            echo "User ubuntu does not exist"; \
        fi; \
        # Check if vscode user exists, if not create it
        if ! id "vscode" &>/dev/null; then \
            echo "Creating user vscode" && useradd -m vscode || echo "Failed to create vscode user"; \
        fi; \
        # Modify vscode user and group only if they exist
        echo "Modifying user vscode UID" && usermod -u 1000 vscode || echo "Failed to modify vscode UID"; \
        echo "Modifying group vscode GID" && groupmod -g 1000 vscode || echo "Failed to modify vscode GID"; \
    else \
        echo "Variant does not contain noble"; \
    fi > /tmp/logfile.txt 2>&1

# clear this environment variable so xml docs from NuGet packages are unpackaged. The default dotnet/sdk image sets it to 'skip'.
# see https://github.com/dotnet/dotnet-docker/issues/2790
ENV NUGET_XMLDOC_MODE=