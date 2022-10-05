FROM harbor.cyverse.org/vice/jupyter/datascience:latest

USER jovyan

RUN conda update conda 
RUN conda config --remove channels conda-forge
RUN conda config --add channels conda-forge
RUN conda config --set channel_priority strict
COPY environment.yml /home/jovyan/ 
RUN mamba env create -f /home/jovyan/environment.yml
RUN echo ". /opt/conda/etc/profile.d/conda.sh" >> /home/jovyan/.bashrc && \
    echo "conda deactivate" >> /home/jovyan/.bashrc && \
    echo "conda activate Earthlab" >> /home/jovyan/.bashrc
RUN . /opt/conda/etc/profile.d/conda.sh && conda activate Earthlab && python -m ipykernel install --user --name Earthlab     
RUN source /home/jovyan/.bashrc

# Install JupyterLab widget extensions
RUN sudo chown -R 1000:100 /opt/conda/share
RUN jupyter labextension install \
    ipyvolume \
    itkwidgets \    
    jupyterlab_iframe \ 
    jupyter-leaflet \
    jupyter-threejs \
 && npm cache clean --force

RUN jupyter lab build