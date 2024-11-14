FROM harbor.cyverse.org/vice/jupyter/datascience:3.6.3-rstudio-4.4

USER root

# Fix conda issue
RUN pip install --upgrade --force-reinstall zstandard && \
    pip install --upgrade --force-reinstall zstd

# Install devtools deps 
RUN apt update && \
    apt install libfreetype6-dev libpng-dev libtiff5-dev libjpeg-dev libcurl4-openssl-dev libssl-dev libxml2-dev -y && \
    apt upgrade -y

# Give user powers & export env
ARG LOCAL_USER=jovyan
ARG PRIV_CMDS='ALL'
RUN usermod -aG sudo jovyan && \
    echo "$LOCAL_USER ALL=NOPASSWD: $PRIV_CMDS" >> /etc/sudoers

# RUN chmod -R a+wx /opt/conda/

# Create env & export lib env
COPY environment.yml /home/jovyan/environment.yml
RUN mamba update mamba -y 
RUN mamba env create -f environment.yml && \
    mamba install -n biosci ipykernel -y
RUN echo "conda activate biosci" >> ~/.bashrc && \
    bash -c 'echo "export PKG_CONFIG_PATH=${CONDA_PREFIX}/lib/pkgconfig:${PKG_CONFIG_PATH}" >> ~/.bashrc' && \
    source ~/.bashrc 

## Install r-rodbc for ballgown
RUN mamba install -c conda-forge r-rodbc -y

# Install R packages and expose PATH
RUN echo "rsession-ld-library-path=/opt/conda/lib" >> /etc/rstudio/rserver.conf 

RUN sudo apt-get install graphviz -y

# Add path for R packages (tidyverse, ragg)
RUN export PKG_CONFIG_PATH=$CONDA_PREFIX/lib/pkgconfig:$PKG_CONFIG_PATH
ENV PKG_CONFIG_PATH=$CONDA_PREFIX/lib/pkgconfig:$PKG_CONFIG_PATH

# Install pheatmap and enchancedvolcano
# RUN R -e "install.packages('tidyverse', repos='https://cran.r-project.org/', dependencies=TRUE)"
RUN R -e "install.packages('remotes', repos='https://cran.r-project.org/')" 

USER jovyan
WORKDIR /home/jovyan

EXPOSE 8888

COPY entry.sh /bin
RUN mkdir -p /home/jovyan/.irods

# adding right permissions
RUN sudo chmod -R a+wx /home/jovyan/

RUN echo "source ~/.bashrc" >> ~/.bash_profile

ENTRYPOINT ["bash", "/bin/entry.sh"]
