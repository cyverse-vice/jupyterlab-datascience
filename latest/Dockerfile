# https://quay.io/repository/jupyter/datascience-notebook
# CyVerse Datascience Notebook with GitHub CLI, optimized for K8s deployment
FROM quay.io/jupyter/datascience-notebook:latest

LABEL org.label-schema.name="CyVerse VICE JupyterLab Datascience" \
      org.label-schema.description="JupyterLab data science environment with RStudio, VS Code, and AI tools for CyVerse VICE" \
      org.label-schema.url="https://cyverse.org" \
      org.label-schema.vendor="CyVerse" \
      org.label-schema.schema-version="1.0.0"

USER root

# Install system dependencies, GitHub CLI, and tools in a single layer
RUN apt-get update && \
    apt-get install -y \
        lsb-release \
        apt-transport-https \
        curl \
        wget \
        libfreetype6-dev \
        libssl-dev \
        pkg-config \
        psmisc \
        libx11-dev \
        gcc \
        gettext \
        libclang-dev \
        less \
        software-properties-common \
        apt-utils \
        glances \
        htop \
        nano \
        sudo \
        gdebi-core \
        gnupg2 && \
    # Install GitHub CLI
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg && \
    chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null && \
    apt-get update && \
    apt-get install -y gh && \
    # Clean up
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install GoCommands https://learning.cyverse.org/ds/gocommands/
RUN cd /usr/local/bin/ && \
    GOCMD_VER=$(curl -L -s https://raw.githubusercontent.com/cyverse/gocommands/main/VERSION.txt); \
    curl -L -s https://github.com/cyverse/gocommands/releases/download/${GOCMD_VER}/gocmd-${GOCMD_VER}-linux-amd64.tar.gz | tar zxvf -

ARG LOCAL_USER=jovyan

# all sudo powers
ARG PRIV_CMDS='ALL'

# Configure user permissions and group
RUN usermod -aG sudo jovyan && \
    echo "$LOCAL_USER ALL=NOPASSWD: $PRIV_CMDS" >> /etc/sudoers && \
    addgroup --gid 1000 jovyan 2>/dev/null || true && \
    usermod -aG jovyan jovyan

# Install RStudio Server, Shiny Server, and git-credential-manager
# Using RStudio Server 2024.12.1-563 (latest stable release)
RUN wget -q https://download2.rstudio.org/server/jammy/amd64/rstudio-server-2024.12.1-563-amd64.deb \
         -O /tmp/rstudio-server.deb && \
    wget -q https://download3.rstudio.org/ubuntu-20.04/x86_64/shiny-server-1.5.23.1030-amd64.deb \
         -O /tmp/shiny-server.deb && \
    wget -q https://github.com/git-ecosystem/git-credential-manager/releases/download/v2.6.1/gcm-linux_amd64.2.6.1.deb \
         -O /tmp/gcm.deb && \
    gdebi -n /tmp/rstudio-server.deb && \
    gdebi -n /tmp/shiny-server.deb && \
    dpkg -i /tmp/gcm.deb && \
    rm -f /tmp/*.deb

# Dependencies: NodeJS for Claude Code, OpenAI Codex, Gemini CLI
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get update && \
    apt-get install -y locales neofetch figlet w3m-img imagemagick s3fs fuse nodejs socat bubblewrap && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

USER jovyan
WORKDIR /home/jovyan

# Install Claude Code using official installer
RUN curl -fsSL https://claude.ai/install.sh | bash

# Install OpenAI Codex and Google Gemini CLI via npm
RUN npm config set prefix /home/jovyan/.npm-global && \
    export PATH=/home/jovyan/.npm-global/bin:$PATH && \
    npm install -g @google/gemini-cli @openai/codex && \
    npm cache clean --force
ENV PATH="/home/jovyan/.npm-global/bin:${PATH}"

# Install VS Code Server and Jupyter extensions
RUN curl -fsSL https://code-server.dev/install.sh | sh && \
    python3 -m pip install --no-cache-dir jupyter-vscode-proxy \
        git+https://github.com/jupyterhub/jupyter-rsession-proxy@216d9e5e65f0a16af34cf1bafc418c4daa1e08d6 \
        jupyter-shiny-proxy

# Install Jupyter Lab Proxy extensions (cards in Launcher)
RUN mamba install -y -c conda-forge jupyter-server-proxy && \
    mamba clean -afy

# Copy in configuration JSON for Jupyter Notebooks
COPY jupyter_notebook_config.json /opt/conda/etc/jupyter/jupyter_notebook_config.json

# Copy entry script
COPY entry.sh /bin
RUN sudo chmod +x /bin/entry.sh

EXPOSE 8888

WORKDIR /home/jovyan/data-store

ENTRYPOINT ["bash", "/bin/entry.sh"]
