FROM quay.io/jupyter/datascience-notebook:latest

LABEL org.label-schema.name="CyVerse VICE JupyterLab" \
      org.label-schema.description="JupyterLab data science environment for CyVerse VICE" \
      org.label-schema.url="https://cyverse.org" \
      org.label-schema.vendor="CyVerse" \
      org.label-schema.schema-version="1.0.0"

USER root

# Install system dependencies and GitHub CLI
RUN apt-get update && \
    apt-get install -y \
        lsb-release apt-transport-https curl wget \
        libfreetype6-dev libssl-dev pkg-config \
        less software-properties-common apt-utils \
        glances htop nano sudo gnupg2 gettext && \
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg && \
    chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null && \
    apt-get update && apt-get install -y gh && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install GoCommands
RUN cd /usr/local/bin && \
    GOCMD_VER=$(curl -L -s https://raw.githubusercontent.com/cyverse/gocommands/main/VERSION.txt); \
    curl -L -s https://github.com/cyverse/gocommands/releases/download/${GOCMD_VER}/gocmd-${GOCMD_VER}-linux-amd64.tar.gz | tar zxvf -

# Configure user
ARG LOCAL_USER=jovyan
RUN usermod -aG sudo jovyan && \
    echo "$LOCAL_USER ALL=NOPASSWD: ALL" >> /etc/sudoers && \
    addgroup --gid 1000 jovyan 2>/dev/null || true && \
    usermod -aG jovyan jovyan

# Install Node.js
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

USER jovyan
WORKDIR /home/jovyan

# Install Claude Code using official installer
RUN curl -fsSL https://claude.ai/install.sh | bash

# Install Gemini CLI and OpenAI Codex via npm
RUN npm config set prefix /home/jovyan/.npm-global && \
    export PATH=/home/jovyan/.npm-global/bin:$PATH && \
    npm install -g @google/gemini-cli @openai/codex && \
    npm cache clean --force
ENV PATH="/home/jovyan/.npm-global/bin:${PATH}"

# Install OpenCode (https://opencode.ai/)
RUN curl -fsSL https://opencode.ai/install | bash
ENV PATH="/home/jovyan/.opencode/bin:${PATH}"

# Copy entry script
COPY entry.sh /bin
RUN sudo chmod +x /bin/entry.sh

EXPOSE 8888

WORKDIR /home/jovyan/data-store

ENTRYPOINT ["bash", "/bin/entry.sh"]
