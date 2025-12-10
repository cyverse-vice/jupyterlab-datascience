# https://quay.io/repository/jupyter/datascience-notebook
# CyVerse Datascience Notebook with GitHub CLI, optimized for K8s deployment
FROM quay.io/jupyter/datascience-notebook:latest
USER root

# Install system dependencies, GitHub CLI, and tools in a single layer
RUN apt update && \
    apt install -y \
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
    apt update && \
    apt install -y gh && \
    # Clean up
    apt clean && \
    rm -rf /var/lib/apt/lists/*

# Install GoCommands https://learning.cyverse.org/ds/gocommands/
RUN cd /usr/local/bin/ && \
    GOCMD_VER=$(curl -L -s https://raw.githubusercontent.com/cyverse/gocommands/main/VERSION.txt); \
    curl -L -s https://github.com/cyverse/gocommands/releases/download/${GOCMD_VER}/gocmd-${GOCMD_VER}-linux-amd64.tar.gz | tar zxvf -
    
ARG LOCAL_USER=jovyan

# all sudo powers
ARG PRIV_CMDS='ALL'
# uncomment to limited sudo powers
# ARG PRIV_CMDS='/bin/ch*,/bin/cat,/bin/gunzip,/bin/tar,/bin/mkdir,/bin/ps,/bin/mv,/bin/cp,/usr/bin/apt*,/usr/bin/pip*,/bin/yum,/bin/snap,/bin/curl,/bin/tee,/opt'
    
RUN usermod -aG sudo jovyan && \
    echo "$LOCAL_USER ALL=NOPASSWD: $PRIV_CMDS" >> /etc/sudoers
RUN addgroup jovyan
RUN usermod -aG jovyan jovyan

# Install RStudio (pinned version for reproducibility)
RUN wget https://download2.rstudio.org/server/jammy/amd64/rstudio-server-2025.09.2-418-amd64.deb && \
    gdebi -n rstudio-server-2025.09.2-418-amd64.deb && \
    rm rstudio-server-2025.09.2-418-amd64.deb

# Install Shiny Server (pinned version for reproducibility)
RUN wget https://download3.rstudio.org/ubuntu-20.04/x86_64/shiny-server-1.5.23.1030-amd64.deb && \
    gdebi -n shiny-server-1.5.23.1030-amd64.deb && \
    rm shiny-server-1.5.23.1030-amd64.deb

# Install git-credential-manager (pinned version for reproducibility)
RUN wget https://github.com/git-ecosystem/git-credential-manager/releases/download/v2.6.1/gcm-linux_amd64.2.6.1.deb && \
    dpkg -i gcm-linux_amd64.2.6.1.deb && \
    rm gcm-linux_amd64.2.6.1.deb

# Dependencies: NodeJS for Claude Code, OpenAI Codex, Gemini CLI
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt update && \
    apt-get install -y locales neofetch figlet w3m-img imagemagick s3fs fuse nodejs socat bubblewrap 

USER jovyan
WORKDIR /home/jovyan

# Install Claude Code, OpenAI Codex, and Google Gemini CLI
RUN npm config set prefix /home/jovyan/.npm-global && \
    export PATH=/home/jovyan/.npm-global/bin:$PATH && \
    npm install -g @anthropic-ai/claude-code @google/gemini-cli @openai/codex

# Install VS Code Server
RUN curl -fsSL https://code-server.dev/install.sh | sh && \
    python3 -m pip install jupyter-vscode-proxy

## Install Jupyter Lab RStudio extensions (cards in Launcher)
RUN python3 -m pip install git+https://github.com/jupyterhub/jupyter-rsession-proxy@216d9e5e65f0a16af34cf1bafc418c4daa1e08d6 jupyter-shiny-proxy

# Install Jupyter Lab Proxy extensions (cards in Launcher)
RUN mamba install -c conda-forge jupyter-server-proxy 
  
# Copy in configuration JSON for Jupyter Notebooks
COPY jupyter_notebook_config.json /opt/conda/etc/jupyter/jupyter_notebook_config.json

EXPOSE 8888

# Set the entrypoint script
COPY entry.sh /bin

ENTRYPOINT ["bash", "/bin/entry.sh"]


