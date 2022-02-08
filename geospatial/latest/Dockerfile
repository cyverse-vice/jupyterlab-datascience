FROM harbor.cyverse.org/vice/jupyter/datascience:latest

USER root

RUN apt update && \
    apt install -y libfreetype6-dev pkg-config libx11-dev && \
    apt clean && \
    rm -rv /var/lib/apt/lists/*

# RUN chown -R jovyan:jovyan /opt/conda
USER jovyan

RUN conda update conda 
RUN conda config --remove channels conda-forge
RUN conda config --add channels conda-forge
RUN conda config --set channel_priority strict
COPY environment.yml /home/jovyan/ 
RUN conda env create -f /home/jovyan/environment.yml
RUN echo ". /opt/conda/etc/profile.d/conda.sh" >> /home/jovyan/.bashrc && \
    echo "conda activate geospatial" >> /home/jovyan/.bashrc
RUN source /home/jovyan/.bashrc

# Install JupyterLab widget extensions
RUN pip install jupyterlab-geojson sidecar
RUN sudo chown -R jovyan:jovyan /opt/conda/share
RUN jupyter labextension install \
    ipyvolume \
    itkwidgets \    
    jupyterlab_iframe \ 
    jupyter-leaflet \
    jupyter-threejs \
 && npm cache clean --force

RUN jupyter lab build

RUN conda clean --all -f -y
