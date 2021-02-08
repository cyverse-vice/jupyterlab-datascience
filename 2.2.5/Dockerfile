FROM jupyter/datascience-notebook:lab-2.2.5

USER root

# Install a few dependencies for iCommands, text editing, and monitoring instances
RUN apt-get update && apt-get install -y lsb-release wget apt-transport-https curl supervisor nginx gnupg2 libfuse2 nano htop gcc less nodejs software-properties-common apt-utils glances
RUN curl "http://ftp.debian.org/debian/pool/main/g/glibc/multiarch-support_2.28-10_amd64.deb" -O && \
    dpkg -i multiarch-support_2.28-10_amd64.deb && \
    rm multiarch-support_2.28-10_amd64.deb
RUN curl "http://ftp.se.debian.org/debian/pool/main/o/openssl/libssl1.0.0_1.0.1t-1+deb8u8_amd64.deb" -O && \
    dpkg -i libssl1.0.0_1.0.1t-1+deb8u8_amd64.deb && \
    rm libssl1.0.0_1.0.1t-1+deb8u8_amd64.deb
RUN wget https://files.renci.org/pub/irods/releases/4.1.12/ubuntu14/irods-icommands-4.1.12-ubuntu14-x86_64.deb && \
    dpkg -i irods-icommands-4.1.12-ubuntu14-x86_64.deb && \
    rm irods-icommands-4.1.12-ubuntu14-x86_64.deb

# install jupyterlab git extension
RUN jupyter labextension install @jupyterlab/git && \
        pip install --upgrade jupyterlab-git && \
        jupyter serverextension enable --py jupyterlab_git

# Install CyberDuck CLI
RUN echo -e "deb https://s3.amazonaws.com/repo.deb.cyberduck.io stable main" | tee /etc/apt/sources.list.d/cyberduck.list > /dev/null && \
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys FE7097963FEFBE72 && \
apt-get update && \
apt-get install duck

# Install and configure jupyter lab.
COPY jupyter_notebook_config.json /opt/conda/etc/jupyter/jupyter_notebook_config.json

# Add the jovyan user to UID 1000
RUN groupadd jovyan && usermod -aG jovyan jovyan && usermod -d /home/jovyan -u 1000 jovyan

USER jovyan
WORKDIR /home/jovyan

EXPOSE 8888

COPY entry.sh /bin
RUN mkdir -p /home/jovyan/.irods

ENTRYPOINT ["bash", "/bin/entry.sh"]
