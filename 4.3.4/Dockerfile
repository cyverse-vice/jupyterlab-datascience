# https://quay.io/repository/jupyter/datascience-notebook
FROM quay.io/jupyter/datascience-notebook:latest

USER root

# Install a few dependencies for goCommands, text editing, and monitoring instances
RUN apt update && \
    apt install -y lsb-release apt-transport-https curl libfreetype6-dev pkg-config libx11-dev gcc gettext less software-properties-common apt-utils glances htop nano 

# Install GoCommands https://learning.cyverse.org/ds/gocommands/ 
RUN cd /usr/local/bin/ && \
    GOCMD_VER=$(curl -L -s https://raw.githubusercontent.com/cyverse/gocommands/main/VERSION.txt); \
    curl -L -s https://github.com/cyverse/gocommands/releases/download/${GOCMD_VER}/gocmd-${GOCMD_VER}-linux-amd64.tar.gz | tar zxvf -

# Add sudo to jovyan user
RUN apt update && \
    apt install -y sudo && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*
    
ARG LOCAL_USER=jovyan

# all sudo powers
ARG PRIV_CMDS='ALL'
# uncomment to limited sudo powers
# ARG PRIV_CMDS='/bin/ch*,/bin/cat,/bin/gunzip,/bin/tar,/bin/mkdir,/bin/ps,/bin/mv,/bin/cp,/usr/bin/apt*,/usr/bin/pip*,/bin/yum,/bin/snap,/bin/curl,/bin/tee,/opt'
    
RUN usermod -aG sudo jovyan && \
    echo "$LOCAL_USER ALL=NOPASSWD: $PRIV_CMDS" >> /etc/sudoers
RUN addgroup jovyan
RUN usermod -aG jovyan jovyan

# install git-credential-manager 
RUN wget https://github.com/git-ecosystem/git-credential-manager/releases/download/v2.5.0/gcm-linux_amd64.2.5.0.deb
RUN dpkg -i gcm-linux_amd64.2.5.0.deb && \
    rm gcm-linux_amd64.2.5.0.deb

# set the ENV for the credential type
ENV GCM_CREDENTIAL_STORE=cache

USER jovyan
WORKDIR /home/jovyan

# Install Jupyter-AI https://jupyter-ai.readthedocs.io/en/latest/users/index.html#installation
RUN python3 -m pip install jupyter-ai && \ 
    python3 -m pip install langchain_anthropic langchain_openai langchain_nvidia_ai_endpoints langchain_google_genai

# Install Jupyter Lab Proxy extensions (cards in Launcher)
RUN mamba install -c conda-forge jupyter-server-proxy 
  
# Copy in configuration JSON for Jupyter Notebooks
COPY jupyter_notebook_config.json /opt/conda/etc/jupyter/jupyter_notebook_config.json

EXPOSE 8888

# Set the entrypoint script
COPY entry.sh /bin

ENTRYPOINT ["bash", "/bin/entry.sh"]


