FROM harbor.cyverse.org/vice/jupyter/datascience:4.3.4

USER jovyan
COPY mmtf-pyspark.yml /home/jovyan/

RUN conda init bash

ENV CONDA_DEFAULT_ENV=mmtf-pyspark

RUN mamba env create -f /home/jovyan/mmtf-pyspark.yml && \
    mamba clean 

# Create Jupyter kernel for the new environment
RUN python -m ipykernel install --user --name mmtf-pyspark --display-name "Python (mmtf-pyspark)" 

# using ~/.bash_profile instead of ~/.bashrc for non-interactive tty (-it) containers
RUN echo "source activate mmtf-pyspark" >> /home/jovyan/.bash_profile
RUN . /opt/conda/etc/profile.d/conda.sh && conda deactivate && conda activate mmtf-pyspark && ipython kernel install --name "mmtf-pyspark" --user 

# Optionally, automatically activate your environment upon shell start
RUN echo "source activate mmtf-pyspark" >> ~/.bashrc

# Install Java  
RUN sudo apt-get update && \
    sudo apt-get install -y openjdk-8-jdk

EXPOSE 8888

ENTRYPOINT ["bash", "/bin/entry.sh"]