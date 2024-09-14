ARG VARIANT=9.0-bookworm-slim
FROM mcr.microsoft.com/dotnet/sdk:${VARIANT}
ENV PATH $PATH:/home/vscode/.dotnet:/home/vscode/.dotnet/tools

ARG VARIANT
ENV VARIANT=${VARIANT}

RUN if [ "${VARIANT#*noble}" != "$VARIANT" ]; then \
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

# clear this environment variable so xml docs from NuGet packages are unpackaged. The default dotnet/sdk image sets it to 'skip'.
# see https://github.com/dotnet/dotnet-docker/issues/2790
ENV NUGET_XMLDOC_MODE=