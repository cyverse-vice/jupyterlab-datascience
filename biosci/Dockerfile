FROM harbor.cyverse.org/vice/jupyter/datascience:3.6.3-rstudio

USER root

# Fix conda issue
RUN pip install --upgrade --force-reinstall zstandard && \
    pip install --upgrade --force-reinstall zstd

# Install conda packages
RUN mamba install -c bioconda blast fastqc multiqc star bowtie2 bwa hisat2 gatk4 busco nextflow snakemake samtools -y 

## Install tophat2
RUN conda create -n tophat python=2 tophat -c bioconda

# Install R packages and expose PATH
RUN R -e "install.packages('BiocManager', repos='https://cloud.r-project.org')"
RUN R -e "BiocManager::install(c('DESeq2', 'ggplot2', 'GenomeInfoDb'), update = FALSE, ask = FALSE)"
RUN echo "rsession-ld-library-path=/opt/conda/lib" >> /etc/rstudio/rserver.conf 

USER jovyan
WORKDIR /home/jovyan

EXPOSE 8888

COPY entry.sh /bin
RUN mkdir -p /home/jovyan/.irods

ENTRYPOINT ["bash", "/bin/entry.sh"]