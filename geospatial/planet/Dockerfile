FROM harbor.cyverse.org/vice/jupyter/datascience:latest

USER jovyan

RUN conda update conda 
RUN conda config --remove channels conda-forge
RUN conda config --add channels conda-forge
RUN conda config --set channel_priority strict
COPY environment.yml /home/jovyan/ 
RUN mamba env create -f /home/jovyan/environment.yml
# using ~/.bash_profile instead of ~/.bashrc for non-interactive tty (-it) containers
RUN echo ". /opt/conda/etc/profile.d/conda.sh" >> /home/jovyan/.bash_profile && \
    echo "conda activate planet" >> /home/jovyan/.bash_profile
RUN . /opt/conda/etc/profile.d/conda.sh && conda deactivate && conda activate planet && ipython kernel install --name "planet" --user 
RUN source /home/jovyan/.bash_profile

# Install JupyterLab widget extensions
RUN sudo chown -R 1000:100 /opt/conda/share

RUN jupyter lab build

RUN mamba clean --all -f -y
