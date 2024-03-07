FROM quay.io/jupyter/datascience-notebook:latest

USER root

# Install a few dependencies for goCommands, text editing, and monitoring instances
RUN apt update && \
    apt install -y lsb-release apt-transport-https curl libfreetype6-dev pkg-config libx11-dev gcc less software-properties-common apt-utils glances htop nano gnupg openjdk-8-jdk

# import the MongoDB public GPG key
RUN curl -fsSL https://www.mongodb.org/static/pgp/server-7.0.asc | \
    sudo gpg -o /usr/share/keyrings/mongodb-server-7.0.gpg \
    --dearmor

# Create list file for MongoDB
RUN echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list && \
    sudo apt-get update

# Install MongoDB packages
RUN sudo apt-get install -y mongodb-org

# Create a directory for MongoDB data
RUN mkdir -p /data/db && chown -R mongodb:mongodb /data/db

# Install Cassandra 4.0
RUN echo "deb https://debian.cassandra.apache.org 41x main" | sudo tee -a /etc/apt/sources.list.d/cassandra.sources.list && \
    curl https://downloads.apache.org/cassandra/KEYS | sudo apt-key add - && \
    sudo apt-get update && \
    sudo apt-get install cassandra && \
    pip install cqlsh

# Permissions for cassandra
RUN sudo chmod -R 777 /var/lib/cassandra/

# Install Go
RUN wget -q -c https://dl.google.com/go/go1.21.5.linux-amd64.tar.gz -O - | tar -xz -C /usr/local
ENV PATH=$PATH:/usr/local/go/bin 

# Install GoCommands
RUN cd /usr/local/bin/ && \
    GOCMD_VER=$(curl -L -s https://raw.githubusercontent.com/cyverse/gocommands/main/VERSION.txt); \
    curl -L -s https://github.com/cyverse/gocommands/releases/download/${GOCMD_VER}/gocmd-${GOCMD_VER}-linux-amd64.tar.gz | tar zxvf -

# Install and configure jupyter lab.
COPY jupyter_notebook_config.json /opt/conda/etc/jupyter/jupyter_notebook_config.json

# Add sudo to jovyan user
RUN apt update && \
    apt install -y sudo && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*
    
ARG LOCAL_USER=jovyan
ARG PRIV_CMDS='/bin/ch*,/bin/cat,/bin/gunzip,/bin/tar,/bin/mkdir,/bin/ps,/bin/mv,/bin/cp,/usr/bin/apt*,/usr/bin/pip*,/bin/yum,/bin/snap,/bin/curl,/bin/tee,/opt'

RUN usermod -aG sudo jovyan && \
    echo "$LOCAL_USER ALL=NOPASSWD: $PRIV_CMDS" >> /etc/sudoers
RUN addgroup jovyan
RUN usermod -aG jovyan jovyan

# Install RStudio
RUN apt update && apt install --yes gdebi-core && \
    wget https://download2.rstudio.org/server/jammy/amd64/rstudio-server-2023.12.0-369-amd64.deb && \
    gdebi -n rstudio-server-2023.12.0-369-amd64.deb && \
    rm rstudio-server-2023.12.0-369-amd64.deb && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Shiny Server
RUN wget https://download3.rstudio.org/ubuntu-18.04/x86_64/shiny-server-1.5.21.1012-amd64.deb && \
    gdebi -n shiny-server-1.5.21.1012-amd64.deb && \
    rm shiny-server-1.5.21.1012-amd64.deb && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Trying a fix for RStudio proxy URI problem in VICE
COPY jupyter_notebook_config.py /etc/jupyter/

USER jovyan
WORKDIR /home/jovyan

# Install Jupyter Lab Proxy extensions (cards in Launcher)
RUN mamba install --quiet --yes jupyter-rsession-proxy jupyter-server-proxy gh && \
    pip install jupyter-shiny-proxy

# Install pymongo
RUN mamba install -c conda-forge pymongo -y
    
# Install and configure jupyter lab. 
COPY jupyter_notebook_config.json /opt/conda/etc/jupyter/jupyter_notebook_config.json

# Rebuild the Jupyter Lab with new tools
RUN jupyter lab build

# Jupyter port
EXPOSE 8888

# Cassandra port
EXPOSE 9042 

COPY entry.sh /bin
RUN mkdir -p /home/jovyan/.irods

ENTRYPOINT ["bash", "/bin/entry.sh"]
