FROM harbor.cyverse.org/vice/jupyter/datascience:latest

USER root

RUN apt-get update && \
    apt-get install -y libfreetype6-dev pkg-config libx11-dev && \
    apt-get clean && \
    rm -rv /var/lib/apt/lists/*

# RUN chown -R jovyan:jovyan /opt/conda
USER jovyan

RUN conda update -n base conda 

COPY environment.yml environment.yml
RUN conda env create -f environment.yml
RUN echo ". /opt/conda/etc/profile.d/conda.sh" >> /home/jovyan/.bashrc && \
    echo "conda activate geospatial" >> /home/jovyan/.bashrc
RUN source /home/jovyan/.bashrc

# Install JupyterLab widget extensions
RUN conda install -c conda-forge jupyter_bokeh
RUN pip install jupyterlab-geojson sidecar
RUN jupyter labextension install @jupyterlab/toc
RUN jupyter labextension install \
    ipyvolume \
    itkwidgets \    
    jupyterlab_iframe \ 
    jupyter-leaflet \
    jupyter-threejs \
 && npm cache clean --force
# add bqplot extension
RUN jupyter labextension install bqplot && \
    jupyter nbextension install bqplot --py --symlink --sys-prefix && \ 
    jupyter nbextension enable bqplot --py --sys-prefix
RUN jupyter lab build

RUN conda clean --all -f -y