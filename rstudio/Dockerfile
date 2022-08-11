FROM harbor.cyverse.org/vice/jupyter/datascience:latest

USER root

# R pre-requisites
RUN apt-get update --yes && \
    apt install --yes \
    fonts-dejavu \
    unixodbc \
    unixodbc-dev \
    r-cran-rodbc && \
    apt-get clean && rm -rf /var/lib/apt/lists/* && \
    apt-get update --yes 

# Install RStudio
RUN wget https://download2.rstudio.org/server/bionic/amd64/rstudio-server-2022.02.0-443-amd64.deb && \
    apt install -y ./rstudio-server-*.deb && \
    rm -f rstudio-server-*.deb
# Install Shiny Server
RUN apt-get install -y gdebi-core && \
    wget https://download3.rstudio.org/ubuntu-18.04/x86_64/shiny-server-1.5.19.995-amd64.deb && \
    gdebi --non-interactive shiny-server-1.5.19.995-amd64.deb && \
    rm -f shiny-server-*.deb

# Update permissions for /opt/conda
RUN chown -R jovyan:users /opt/conda/share/jupyter/lab/
USER jovyan
# reinstall R packages 
RUN mamba install --quiet --yes \
    'r-base' \
    'r-caret' \
    'r-crayon' \
    'r-devtools' \
    'r-e1071' \
    'r-forecast' \
    'r-hexbin' \
    'r-htmltools' \
    'r-htmlwidgets' \
    'r-irkernel' \
    'r-nycflights13' \
    'r-randomforest' \
    'r-rcurl' \
    'r-rmarkdown' \
    'r-rodbc' \
    'r-rsqlite' \
    'r-shiny' \
    'r-tidyverse' \
    'unixodbc' && \
    mamba clean --all -f -y
# Install Jupyter Lab Proxy extensions (cards in Launcher)
RUN pip install git+https://github.com/jupyterhub/jupyter-rsession-proxy.git jupyter-server-proxy jupyter-shiny-proxy && \
    jupyter labextension install @jupyterlab/server-proxy 

# Install Mamba Gator package manager
RUN rm -f ~/.jupyter/lab/workspaces/default* && \
    mamba install -y -c conda-forge mamba_gator

# Install and configure jupyter lab.
COPY jupyter_notebook_config.json /opt/conda/etc/jupyter/jupyter_notebook_config.json

# Rebuild the Jupyter Lab with new tools
RUN jupyter lab build
