FROM jupyter/datascience-notebook:lab-3.0.5

USER root

# Install a few dependencies for iCommands, text editing, and monitoring instances
RUN apt-get update && apt-get install -y lsb-release wget apt-transport-https curl supervisor nginx gnupg2 libfuse2 nano htop gcc less nodejs software-properties-common apt-utils glances

RUN wget -qO - https://packages.irods.org/irods-signing-key.asc | apt-key add - && \
    echo "deb [arch=amd64] https://packages.irods.org/apt/ bionic  main" > /etc/apt/sources.list.d/renci-irods.list && \
    apt-get update && \
    wget -c \
    http://security.ubuntu.com/ubuntu/pool/main/p/python-urllib3/python-urllib3_1.22-1ubuntu0.18.04.2_all.deb \
    http://security.ubuntu.com/ubuntu/pool/main/r/requests/python-requests_2.18.4-2ubuntu0.1_all.deb \
    http://security.ubuntu.com/ubuntu/pool/main/o/openssl1.0/libssl1.0.0_1.0.2n-1ubuntu5.5_amd64.deb && \
    apt install -y \
    ./python-urllib3_1.22-1ubuntu0.18.04.2_all.deb \
    ./python-requests_2.18.4-2ubuntu0.1_all.deb \
    ./libssl1.0.0_1.0.2n-1ubuntu5.5_amd64.deb && \
    rm -rf \
    ./python-urllib3_1.22-1ubuntu0.18.04.2_all.deb \
    ./python-requests_2.18.4-2ubuntu0.1_all.deb \
    ./libssl1.0.0_1.0.2n-1ubuntu5.5_amd64.deb

RUN apt install -y irods-icommands

# install iRODS plugin
RUN jupyter labextension install ijab && \
    pip install jupyterlab_irods

# Install CyberDuck CLI
RUN echo -e "deb https://s3.amazonaws.com/repo.deb.cyberduck.io stable main" | tee /etc/apt/sources.list.d/cyberduck.list > /dev/null && \
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys FE7097963FEFBE72 && \
apt-get update && \
apt-get install duck

# Install Github widget == not ready for 3.0.*
#RUN jupyter labextension install @jupyterlab/github

# Install and configure jupyter lab.
COPY jupyter_notebook_config.json /opt/conda/etc/jupyter/jupyter_notebook_config.json

# Add the jovyan user to UID 1000
RUN groupadd jovyan && usermod -aG jovyan jovyan && usermod -d /home/jovyan -u 1000 jovyan

RUN apt-get update && apt-get install -y sudo
RUN usermod -aG sudo jovyan
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Rebuild the Jupyter Lab with new tools
RUN jupyter lab build

USER jovyan
WORKDIR /home/jovyan

EXPOSE 8888

COPY entry.sh /bin
RUN mkdir -p /home/jovyan/.irods

ENTRYPOINT ["bash", "/bin/entry.sh"]
