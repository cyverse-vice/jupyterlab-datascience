FROM harbor.cyverse.org/vice/jupyter/datascience:3.6.3-rstudio-4.4

USER root

# Fix conda issue
RUN pip install --upgrade --force-reinstall zstandard && \
    pip install --upgrade --force-reinstall zstd

# Install devtools deps 
RUN apt update && \
    apt install libfreetype6-dev libpng-dev libtiff5-dev libjpeg-dev libcurl4-openssl-dev libssl-dev libxml2-dev -y && \
    apt upgrade -y

# Give user powers & export env
ARG LOCAL_USER=jovyan
ARG PRIV_CMDS='ALL'
RUN usermod -aG sudo jovyan && \
    echo "$LOCAL_USER ALL=NOPASSWD: $PRIV_CMDS" >> /etc/sudoers

# Create env & export lib env
COPY environment.yml /home/jovyan/environment.yml
RUN mamba update mamba -y 
RUN mamba env create -f environment.yml && \
    mamba install -n biosci ipykernel -y
RUN echo "conda activate biosci" >> ~/.bashrc && \
    bash -c 'echo "export PKG_CONFIG_PATH=${CONDA_PREFIX}/lib/pkgconfig:${PKG_CONFIG_PATH}" >> ~/.bashrc' && \
    source ~/.bashrc 

## Install tophat2
RUN conda create -n tophat python=2 tophat -c bioconda

## Install r-rodbc for ballgown
RUN mamba install -c conda-forge r-rodbc -y

# Install R packages and expose PATH
RUN echo "rsession-ld-library-path=/opt/conda/lib" >> /etc/rstudio/rserver.conf 

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

# Install vim, subread, htcount, graphviz (for DAG) and update
RUN apt-get update && sudo apt-get upgrade -y && \
    apt-get install vim htcount pearl subread graphviz -y

# Install Java (OpenJDK)
RUN apt-get update && apt-get install -y \
    openjdk-17-jdk \
    && rm -rf /var/lib/apt/lists/*
# Set JAVA_HOME environment variable
ENV JAVA_HOME /usr/lib/jvm/java-17-openjdk-amd64
# Verify installation
RUN java -version

# Obtain and extract CIRI2
RUN wget https://downloads.sourceforge.net/project/ciri/CIRI-full/CIRI_Full_v2.1.1.jar && \
    mv CIRI_Full_v2.1.1.jar /home/jovyan/work/CIRI-full.jar && \
    echo "export PATH=$PATH:/home/jovyan/work" >> ~/.bashrc

# Add path for R packages (tidyverse, ragg)
RUN export PKG_CONFIG_PATH=$CONDA_PREFIX/lib/pkgconfig:$PKG_CONFIG_PATH
ENV PKG_CONFIG_PATH=$CONDA_PREFIX/lib/pkgconfig:$PKG_CONFIG_PATH

# Install pheatmap and enchancedvolcano
RUN R -e "install.packages(c('pheatmap', 'dplyr', 'gridExtra', 'RColorBrewer', 'rgl', 'vipor', 'remotes'), repos='https://cran.r-project.org/', dependencides = TRUE)"
RUN R -e "BiocManager::install(c('EnhancedVolcano', 'DelayedMatrixStats', 'edgeR', 'AnnotationDbi', 'org.Hs.eg.db','multtest', 'slingshot', 'SingleR', 'celldex', 'limma', 'fgsea'),  update = TRUE, ask = FALSE)"
RUN R -e "remotes::install_version('matrixStats', version='1.4.1', repos='https://cran.r-project.org/')"
RUN R -e "devtools::install_github('immunogenomics/harmony')" && \
    R -e "devtools::install_github('chris-mcginnis-ucsf/DoubletFinder')"

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
