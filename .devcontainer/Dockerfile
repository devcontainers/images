FROM mcr.microsoft.com/devcontainers/base:noble

RUN if id "vscode" &>/dev/null; then \
            echo "Deleting user 'vscode' for noble" && userdel -f -r vscode || echo "Failed to delete vscode user for noble"; \  
        else \
            echo "User 'vscode' does not exist for noble"; \ 
    fi