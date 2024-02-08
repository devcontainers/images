ARG VARIANT=8.0-bookworm-slim
FROM mcr.microsoft.com/dotnet/sdk:${VARIANT}
ENV PATH $PATH:/home/vscode/.dotnet:/home/vscode/.dotnet/tools

# clear this environment variable so xml docs from NuGet packages are unpackaged. The default dotnet/sdk image sets it to 'skip'.
# see https://github.com/dotnet/dotnet-docker/issues/2790
ENV NUGET_XMLDOC_MODE=

# Temporary: Upgrade packages due to mentioned CVEs
# They are installed by the base image (mcr.microsoft.com/dotnet/sdk) which does not have the patch.
# https://msrc.microsoft.com/update-guide/vulnerability/CVE-2024-0057
RUN apt-get update && \
    apt-get install -y wget && \
    ARCHITECTURE=$(dpkg --print-architecture) && \
    POWERSHELL_FILE_NAME="powershell_7.4.1-1.deb_${ARCHITECTURE}.deb" && \
    wget https://github.com/PowerShell/PowerShell/releases/download/v7.4.1/${POWERSHELL_FILE_NAME} && \
    dpkg -i ${POWERSHELL_FILE_NAME} && \
    apt-get install -f && \
    rm ${POWERSHELL_FILE_NAME}