FROM harbor.cyverse.org/vice/jupyter/datascience:latest
USER root

# install misc dependencies
RUN apt-get update && apt-get install -y unzip clang llvm jq

#intstall fastx
RUN mkdir fastx_bin \
    && wget -O fastx_bin/fastx_toolkit_0.0.13_binaries_Linux_2.6_amd64.tar.bz2 http://hannonlab.cshl.edu/fastx_toolkit/fastx_toolkit_0.0.13_binaries_Linux_2.6_amd64.tar.bz2 \
    && tar -xjf fastx_bin/fastx_toolkit_0.0.13_binaries_Linux_2.6_amd64.tar.bz2 -C ./fastx_bin \
    && cp fastx_bin/bin/* /usr/local/bin \ 
    && rm -r fastx_*

#add TDM
RUN wget -O /bin/tdm.zip https://www.csc.tntech.edu/pdcincs/resources/modules/tools/TDM-GCC-64.zip --no-check-certificate
RUN unzip /bin/tdm.zip -d /bin
RUN rm /bin/tdm.zip
ENV PATH "$PATH:/bin/TDM-GCC-64/bin"

USER jovyan

#pull openmp
RUN git clone https://github.com/pdewan/OpenMPTraining.git /home/jovyan/OpenMPTraining

#pull dylan_plugin
RUN git clone https://github.com/dylanjtastet/llvm-instr /home/jovyan/llvm-instr

#pull super shell and install
RUN git clone -b CyverseLogging https://github.com/pdewan/SuperShell.git /home/jovyan/SuperShell \
    && cd /home/jovyan/SuperShell/DockerSuperShell/SuperShellV2/ \
    && chmod +x cyverse_install.sh \
    && ./cyverse_install.sh

