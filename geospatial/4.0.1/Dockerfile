FROM harbor.cyverse.org/vice/jupyter/datascience:4.0.1

USER jovyan

# Clean up conda
RUN conda update conda 
RUN conda config --remove channels conda-forge
RUN conda config --add channels conda-forge
RUN conda config --set channel_priority strict

# Create Planet environment using mamba
COPY planet_environment.yml /home/jovyan/ 
RUN mamba env create -f /home/jovyan/planet_environment.yml

# using ~/.bash_profile instead of ~/.bashrc for non-interactive tty (-it) containers
RUN echo ". /opt/conda/etc/profile.d/conda.sh" >> /home/jovyan/.bash_profile && \
    echo "conda activate planet" >> /home/jovyan/.bash_profile
RUN . /opt/conda/etc/profile.d/conda.sh && conda deactivate && conda activate planet && ipython kernel install --name "planet" --user 

# Create OSGEO environment using mamba
COPY osgeo_environment.yml /home/jovyan/ 
RUN mamba env create -f /home/jovyan/osgeo_environment.yml

# using ~/.bash_profile instead of ~/.bashrc for non-interactive tty (-it) containers
RUN echo ". /opt/conda/etc/profile.d/conda.sh" >> /home/jovyan/.bash_profile && \
    echo "conda activate osgeo" >> /home/jovyan/.bash_profile
RUN . /opt/conda/etc/profile.d/conda.sh && conda deactivate && conda activate osgeo && ipython kernel install --name "osgeo" --user 

# Install JupyterLab widget extensions
# RUN sudo chown -R 1000:100 /opt/conda/share
# RUN jupyter labextension install @jupyter-widgets/jupyterlab-manager

# Source BASH profile
RUN source /home/jovyan/.bash_profile

# Build it
RUN jupyter lab build

# Clean it up
RUN mamba clean --all -f -y

