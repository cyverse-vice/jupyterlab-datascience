FROM jupyter/datascience-notebook:lab-3.6.1

USER root

# Install a few dependencies for goCommands, text editing, and monitoring instances
RUN apt update && \
    apt install -y lsb-release apt-transport-https curl libfreetype6-dev pkg-config libx11-dev gcc less software-properties-common apt-utils glances htop nano 

# Install Go
RUN wget -q -c https://dl.google.com/go/go1.18.4.linux-amd64.tar.gz -O - | sudo tar -xz -C /usr/local
ENV PATH=$PATH:/usr/local/go/bin 

# Install GoCommands
RUN mkdir /opt/gocommands/ && cd /opt/gocommands && curl -L -o gocmd.tar.gz https://github.com/cyverse/gocommands/releases/download/v0.4.3/gocmd-v0.4.3-linux-amd64.tar.gz && \
tar zxvf gocmd.tar.gz && rm gocmd.tar.gz
ENV PATH=$PATH:/opt/gocommands

# Install and configure jupyter lab.
COPY jupyter_notebook_config.json /opt/conda/etc/jupyter/jupyter_notebook_config.json

# Add sudo to jovyan user
RUN apt update && \
    apt install -y sudo && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*
    
ARG LOCAL_USER=jovyan
ARG PRIV_CMDS='/bin/ch*,/bin/cat,/bin/gunzip,/bin/tar,/bin/mkdir,/bin/ps,/bin/mv,/bin/cp,/usr/bin/apt*,/usr/bin/pip*,/bin/yum',/opt

RUN usermod -aG sudo jovyan && \
    echo "$LOCAL_USER ALL=NOPASSWD: $PRIV_CMDS" >> /etc/sudoers
RUN addgroup jovyan
RUN usermod -aG jovyan jovyan

# Install RStudio
RUN apt update && apt install --yes gdebi-core && \
    wget https://download2.rstudio.org/server/jammy/amd64/rstudio-server-2022.12.0-353-amd64.deb && \
    gdebi -n rstudio-server-2022.12.0-353-amd64.deb && \
    rm rstudio-server-2022.12.0-353-amd64.deb && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Shiny Server
RUN wget https://download3.rstudio.org/ubuntu-18.04/x86_64/shiny-server-1.5.20.1002-amd64.deb && \
    gdebi -n shiny-server-1.5.20.1002-amd64.deb && \
    rm shiny-server-1.5.20.1002-amd64.deb && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

USER jovyan
WORKDIR /home/jovyan

# Install Jupyter Lab Proxy extensions (cards in Launcher)
RUN mamba install --quiet --yes jupyter-rsession-proxy jupyter-server-proxy && \
    pip install jupyter-shiny-proxy
    
# Install and configure jupyter lab. 
COPY jupyter_notebook_config.json /opt/conda/etc/jupyter/jupyter_notebook_config.json

# Rebuild the Jupyter Lab with new tools
RUN jupyter lab build

EXPOSE 8888

COPY entry.sh /bin
RUN mkdir -p /home/jovyan/.irods

ENTRYPOINT ["bash", "/bin/entry.sh"]