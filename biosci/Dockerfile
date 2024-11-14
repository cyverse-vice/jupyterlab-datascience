FROM harbor.cyverse.org/vice/jupyter/datascience:3.6.3-rstudio-4.4

USER root

# Fix conda issue
RUN pip install --upgrade --force-reinstall zstandard && \
    pip install --upgrade --force-reinstall zstd

# Install devtools deps 
RUN apt update && \
    apt install libfreetype6-dev libpng-dev libtiff5-dev libjpeg-dev -y

# Install conda packages
RUN mamba install -c bioconda -c conda-forge libdeflate=1.22 blast fastqc multiqc star bowtie2 bwa hisat2 gatk4 nextflow snakemake samtools stringtie -y

USER jovyan

# Create
COPY environment.yml /home/jovyan/environment.yml
RUN mamba update mamba -y 
RUN mamba env create -f environment.yml && \
    mamba install -n biosci ipykernel -y && \
    /opt/conda/envs/biosci/bin/python -m ipykernel install --name "biosci" --user 
RUN conda init bash
RUN echo "conda activate biosci" >> ~/.bashrc && \ 
    /bin/bash -c "conda activate biosci"   

USER root

## Install tophat2
RUN conda create -n tophat python=2 tophat -c bioconda

## Install r-rodbc for ballgown
RUN mamba install -c conda-forge r-rodbc -y

# Install R packages and expose PATH
RUN R -e "install.packages('BiocManager', repos='https://cloud.r-project.org')"
RUN R -e "BiocManager::install(c('DESeq2', 'ggplot2', 'GenomeInfoDb', 'ballgown'), update = TRUE, ask = FALSE)"
RUN R -e "BiocManager::install('ballgown', update = TRUE, ask = FALSE)"
RUN echo "rsession-ld-library-path=/opt/conda/lib" >> /etc/rstudio/rserver.conf 

# Install more tools
# RUN mamba install -c bioconda bcftools gatk4 -y

# Install SRA-Toolkit
RUN wget --output-document sratoolkit.tar.gz https://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/current/sratoolkit.current-ubuntu64.tar.gz
RUN tar -vxzf sratoolkit.tar.gz && rm sratoolkit.tar.gz && \
    echo "export PATH=$PATH:/home/jovyan/sratoolkit.3.1.1-ubuntu64/bin" >> ~/.bashrc

# Install vim, subread, htcount, salmon, graphviz (for DAG) and update
RUN sudo apt-get update && sudo apt-get upgrade -y
RUN sudo apt-get install vim -y
RUN sudo apt-get install subread -y 
# RUN mamba install -c bioconda htseq salmon -y
RUN sudo apt-get install graphviz -y

# Add path for R packages (tidyverse, ragg)
RUN export PKG_CONFIG_PATH=$CONDA_PREFIX/lib/pkgconfig:$PKG_CONFIG_PATH
ENV PKG_CONFIG_PATH=$CONDA_PREFIX/lib/pkgconfig:$PKG_CONFIG_PATH

# Install pheatmap and enchancedvolcano
RUN R -e "BiocManager::install('EnhancedVolcano', update = TRUE, ask = FALSE)"
RUN R -e "install.packages(c('pheatmap', 'tidyverse', 'dplyr', 'gridExtra', 'RColorBrewer', 'rgl', 'vipor'), repos='https://cran.r-project.org/', dependencides = TRUE)"
RUN R -e "install.packages('remotes', repos='https://cran.r-project.org/')"
RUN R -e "remotes::install_version('matrixStats', version='1.4.1', repos='https://cran.r-project.org/')"
RUN R -e "BiocManager::install('DelayedMatrixStats')"
RUN R -e "BiocManager::install(c('edgeR', 'AnnotationDbi', 'org.Hs.eg.db', 'limma', 'fgsea'))"
# RUN R -e "BiocManager::install(c('edgeR', 'AnnotationDbi', 'org.Hs.eg.db', 'multtest', 'slingshot', 'SingleR', 'celldex', 'limma', 'fgsea'))"
# RUN R -e "install.packages('devtools', repos='https://cran.r-project.org/')"
#RUN R -e "remotes::install_github('immunogenomics/harmony')" && \
#    R -e "remotes::install_github('chris-mcginnis-ucsf/DoubletFinder')"

# Install Seurat and associated packages
# RUN R -e "install.packages('SeuratObject', repos='https://cran.r-project.org/')"
# RUN R -e "devtools::install_github('satijalab/seurat', 'seurat5', quiet = TRUE)"
# RUN R -e "devtools::install_github('satijalab/seurat-data', 'seurat5', quiet = TRUE)" && \
#     R -e "devtools::install_github('satijalab/azimuth', 'seurat5', quiet = TRUE)"
# RUN R -e "remotes::install_github('satijalab/seurat-wrappers', 'seurat5', quiet = TRUE)" && \
#     R -e "remotes::install_github('stuart-lab/signac', 'seurat5', quiet = TRUE)" && \
#     R -e "remotes::install_github('mojaveazure/seurat-disk', 'seurat5', quiet = TRUE)"

# Install monocle3 package from Bioconductor
# RUN R -e "remotes::install_github('cole-trapnell-lab/monocle3')"


RUN R -e "install.packages('tidyverse', repos='https://cloud.r-project.org')"

USER jovyan
WORKDIR /home/jovyan

EXPOSE 8888

COPY entry.sh /bin
RUN mkdir -p /home/jovyan/.irods

# adding right permissions
RUN chmod -R a+wx /home/jovyan/

ENTRYPOINT ["bash", "/bin/entry.sh"]
