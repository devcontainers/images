ARG VARIANT=8.0-bookworm-slim
FROM mcr.microsoft.com/dotnet/sdk:${VARIANT}
ENV PATH $PATH:/home/vscode/.dotnet:/home/vscode/.dotnet/tools

# clear this environment variable so xml docs from NuGet packages are unpackaged. The default dotnet/sdk image sets it to 'skip'.
# see https://github.com/dotnet/dotnet-docker/issues/2790
ENV NUGET_XMLDOC_MODE=

# Temporary: Upgrade packages due to mentioned CVEs
# They are installed by the base image (mcr.microsoft.com/dotnet/sdk) which does not have the patch.
COPY ./apply_security_patches.sh /tmp/apply_security_patches.sh
RUN chmod +x /tmp/apply_security_patches.sh
RUN /tmp/apply_security_patches.sh