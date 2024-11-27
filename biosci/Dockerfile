FROM harbor.cyverse.org/vice/jupyter/datascience:3.6.3-rstudio-4.4

USER root

# Fix conda issue
RUN pip install --upgrade --force-reinstall zstandard && \
    pip install --upgrade --force-reinstall zstd

# Install deps 
RUN apt update && \
    apt install vim perl subread graphviz libfreetype6-dev libpng-dev libtiff5-dev libjpeg-dev libcurl4-openssl-dev libssl-dev libxml2-dev openjdk-17-jdk -y && \
    apt upgrade -y

ENV JAVA_HOME /usr/lib/jvm/java-17-openjdk-amd64

# Give user powers & export env
ARG LOCAL_USER=jovyan
ARG PRIV_CMDS='ALL'
RUN usermod -aG sudo jovyan && \
    echo "$LOCAL_USER ALL=NOPASSWD: $PRIV_CMDS" >> /etc/sudoers

RUN chmod -R a+wx /home/jovyan/

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

# Install R packages and expose PATH
# RUN echo "rsession-ld-library-path=/opt/conda/lib" >> /etc/rstudio/rserver.conf 

#COPY rscriptinstall.R /rscriptinstall.R 
#RUN Rscript --no-save /rscriptinstall.R  BiocManager

# Install R packages and expose PATH
#RUN R -e "install.packages('BiocManager', repos='https://cloud.r-project.org')"
RUN /opt/conda/envs/biosci/bin/R -e "BiocManager::install('DESeq2', update = FALSE, ask = FALSE, dependencies = TRUE)"
RUN /opt/conda/envs/biosci/bin/R -e "BiocManager::install(c('ggplot2', 'GenomeInfoDb', 'ballgown'), update = FALSE, ask = FALSE, dependencies = TRUE)"
RUN /opt/conda/envs/biosci/bin/R -e "BiocManager::install('ballgown', update = TRUE, ask = FALSE, dependecies = TRUE)"
RUN echo "rsession-ld-library-path=/opt/conda/lib" >> /etc/rstudio/rserver.conf 

# Install SRA-Toolkit
RUN wget --output-document sratoolkit.tar.gz https://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/current/sratoolkit.current-ubuntu64.tar.gz
RUN tar -vxzf sratoolkit.tar.gz && rm sratoolkit.tar.gz
#    echo "export PATH=$PATH:/home/jovyan/sratoolkit.3.1.1-ubuntu64/bin" >> ~/.bashrc

# Obtain and extract CIRI2
RUN wget https://downloads.sourceforge.net/project/ciri/CIRI-full/CIRI_Full_v2.1.1.jar && \
    mv CIRI_Full_v2.1.1.jar /home/jovyan/CIRI-full.jar
#    echo "export PATH=$PATH:/home/jovyan/work" >> ~/.bashrc

# Add path for R packages (tidyverse, ragg)
RUN export PKG_CONFIG_PATH=$CONDA_PREFIX/lib/pkgconfig:$PKG_CONFIG_PATH
ENV PKG_CONFIG_PATH=$CONDA_PREFIX/lib/pkgconfig:$PKG_CONFIG_PATH

# Install pheatmap and enchancedvolcano
#RUN R -e "install.packages(c('pheatmap', 'dplyr', 'gridExtra', 'RColorBrewer', 'rgl', 'vipor', 'remotes'), repos='https://cran.r-project.org/', dependencides = TRUE)"
RUN /opt/conda/envs/biosci/bin/R -e "BiocManager::install(c('EnhancedVolcano', 'DelayedMatrixStats', 'edgeR', 'AnnotationDbi', 'org.Hs.eg.db','multtest', 'slingshot', 'SingleR', 'celldex', 'limma', 'fgsea'),  update = TRUE, ask = FALSE)"
RUN /opt/conda/envs/biosci/bin/R -e "BiocManager::install('slingshot', update = TRUE, ask = FALSE)"
RUN /opt/conda/envs/biosci/bin/R -e "devtools::install_github('immunogenomics/harmony')" && \
    /opt/conda/envs/biosci/bin/R -e "devtools::install_github('chris-mcginnis-ucsf/DoubletFinder')"

# Install Seurat and associated packages
#RUN /opt/conda/envs/biosci/bin/R -e "install.packages('SeuratObject', repos='https://cran.r-project.org/')"
#RUN /opt/conda/envs/biosci/bin/R -e "remotes::install_github('satijalab/seurat', 'seurat5', update = TRUE, ask = FALSE)"
RUN /opt/conda/envs/biosci/bin/R -e "remotes::install_github('satijalab/seurat-data', 'seurat5', update = TRUE, ask = FALSE)"
RUN /opt/conda/envs/biosci/bin/R -e "remotes::install_github('satijalab/azimuth', ref = 'master')"
#RUN /opt/conda/envs/biosci/bin/R -e "remotes::install_github('satijalab/seurat-wrappers', update = TRUE, ask = FALSE)" && \
RUN /opt/conda/envs/biosci/bin/R -e "remotes::install_github('stuart-lab/signac', update = TRUE, ask = FALSE)" && \
    /opt/conda/envs/biosci/bin/R -e "remotes::install_github('mojaveazure/seurat-disk', update = TRUE, ask = FALSE)"

# Install monocle3 package from Bioconductor
RUN /opt/conda/envs/biosci/bin/R -e "BiocManager::install(c('BiocGenerics', 'DelayedArray', 'DelayedMatrixStats', 'lme4', 'S4Vectors', 'SingleCellExperiment', 'SummarizedExperiment', 'batchelor', 'HDF5Array', 'terra', 'ggrastr'), update = TRUE, ask = FALSE)"
RUN /opt/conda/envs/biosci/bin/R -e "devtools::install_github('cole-trapnell-lab/monocle3', dependencies = TRUE, update = FALSE, ask = FALSE)"

RUN wget https://github.com/ShiLab-Bioinformatics/subread/releases/download/2.0.2/subread-2.0.2-Linux-x86_64.tar.gz && \
    tar -xvf subread-2.0.2-Linux-x86_64.tar.gz && \
    mv subread-2.0.2-Linux-x86_64/bin/utilities subread-2.0.2-Linux-x86_64/ && \
    mv subread-2.0.2-Linux-x86_64/bin/* /bin && \
    mv subread-2.0.2-Linux-x86_64/utilities/* /bin && \
    rm -r subread-2.0.2-Linux-x86_64*

RUN sudo chmod -R a+wx /opt/conda/envs/biosci/lib/R/library
RUN touch ~/.Rprofile && \
    echo ".libPaths(c('/opt/conda/envs/biosci/lib/R/library', .libPaths()))" >> ~/.Rprofile
RUN sudo chmod -R a+wx /home/jovyan/

# Specify the R binary to use
ENV RSTUDIO_WHICH_R=/opt/conda/envs/biosci/bin/R
RUN echo "rsession-which-r=/opt/conda/envs/biosci/bin/R" >> /etc/rstudio/rserver.conf

# Update the LD_LIBRARY_PATH for RStudio Server
RUN sed -i 's|^rsession-ld-library-path=.*|rsession-ld-library-path=/opt/conda/envs/biosci/lib|' /etc/rstudio/rserver.conf

USER jovyan
WORKDIR /home/jovyan

EXPOSE 8888

COPY entry.sh /bin
RUN mkdir -p /home/jovyan/.irods

# adding right permissions
#RUN sudo chmod -R a+wx /home/jovyan/
#RUN echo "export PATH='$PATH:/opt/conda/envs/biosci/bin:/opt/conda/condabin:/opt/conda/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/go/bin'" >> ~/.bashrc && \
#    echo "export PATH='$PATH:/home/jovyan/work'" >> ~/.bashrc && \
#    echo "export PATH='$PATH:/home/jovyan/sratoolkit.3.1.1-ubuntu64/bin'" >> ~/.bashrc
RUN echo "source ~/.bashrc" >> ~/.bash_profile
#    echo "export PATH=$PATH:/home/jovyan/sratoolkit.3.1.1-ubuntu64/bin" >> ~/.bash_profile && \
#    echo "export LD_LIBRARY_PATH=/usr/lib/x86_64-linux-gnu/:$LD_LIBRARY_PATH" >> ~/.bash_profile

ENTRYPOINT ["bash", "/bin/entry.sh"]
