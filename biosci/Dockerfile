FROM harbor.cyverse.org/vice/jupyter/datascience:3.6.3-rstudio

USER root

# Fix conda issue
RUN pip install --upgrade --force-reinstall zstandard && \
    pip install --upgrade --force-reinstall zstd

# Install conda packages
RUN mamba install -c bioconda blast fastqc multiqc star bowtie2 bwa hisat2 gatk4 busco nextflow snakemake samtools stringtie -y 

## Install tophat2
RUN conda create -n tophat python=2 tophat -c bioconda

## Install r-rodbc or ballgown
RUN mamba install -c conda-forge r-rodbc -y

# Install R packages and expose PATH
RUN R -e "install.packages('BiocManager', repos='https://cloud.r-project.org')"
RUN R -e "BiocManager::install(c('DESeq2', 'ggplot2', 'GenomeInfoDb', 'ballgown'), update = TRUE, ask = FALSE)"
RUN R -e "BiocManager::install('ballgown', update = TRUE, ask = FALSE)"
RUN echo "rsession-ld-library-path=/opt/conda/lib" >> /etc/rstudio/rserver.conf 

# Install more tools
RUN mamba install -c bioconda bcftools gatk4 -y

# Install SRA-Toolkit
RUN wget --output-document sratoolkit.tar.gz https://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/current/sratoolkit.current-ubuntu64.tar.gz
RUN tar -vxzf sratoolkit.tar.gz && rm sratoolkit.tar.gz && \
    echo "export PATH=$PATH:/home/jovyan/sratoolkit.3.1.1-ubuntu64/bin" >> ~/.bashrc

# Install vim, subread, htcount, salmon, graphviz (for DAG) and update
RUN sudo apt-get update && sudo apt-get upgrade -y
RUN sudo apt-get install vim -y
RUN sudo apt-get install subread -y 
RUN mamba install -c bioconda htseq salmon -y
RUN sudo apt-get install graphviz -y

# Install pheatmap and enchancedvolcano
RUN R -e "BiocManager::install('EnhancedVolcano', update = TRUE, ask = FALSE)"
RUN R -e "install.packages('pheatmap', repos='https://cran.r-project.org/')"
RUN R -e "remotes::install_version('matrixStats', version='1.1.0', repos='https://cran.r-project.org/')"

USER jovyan
WORKDIR /home/jovyan

EXPOSE 8888

COPY entry.sh /bin
RUN mkdir -p /home/jovyan/.irods

ENTRYPOINT ["bash", "/bin/entry.sh"]
