FROM harbor.cyverse.org/vice/jupyter/datascience:latest

USER jovyan

RUN conda update conda 
RUN conda config --remove channels conda-forge
RUN conda config --add channels conda-forge
RUN conda config --set channel_priority strict
COPY environment.yml /home/jovyan/ 
RUN mamba env create -f /home/jovyan/environment.yml
RUN echo ". /opt/conda/etc/profile.d/conda.sh" >> /home/jovyan/.bashrc && \
    echo "conda activate geospatial" >> /home/jovyan/.bashrc 
RUN source /home/jovyan/.bashrc

# Create Kernel for Jupyter Notebooks
RUN python -m ipykernel install --user --name geospatial --display-name "Python (geospatial)"

# Install JupyterLab widget extensions
RUN pip install jupyterlab-geojson sidecar
RUN sudo chown -R 1000:100 /opt/conda/share
RUN jupyter labextension install \
    ipyvolume \
    itkwidgets \    
    jupyterlab_iframe \ 
    jupyter-leaflet \
    jupyter-threejs \
 && npm cache clean --force

RUN jupyter lab build

# Install geospatial kernel into Jupyter   

RUN conda clean --all -f -y