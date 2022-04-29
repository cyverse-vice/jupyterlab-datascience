FROM harbor.cyverse.org/vice/jupyter/geospatial:latest

# Jupyterlab3 does not work with Node 17.x
# Mamba should be installed in all base images
RUN mamba install -c conda-forge jupyterlab=3.3.4 nodejs=16.13.2 gitpython=3.1.26 jupyter-packaging=0.11.1


###############################
# Non Custom Jupyter Extensions.
###############################
RUN mamba install -c conda-forge jupyterlab_widgets jupyterlab-git
RUN jupyter labextension install --no-build jupyterlab-plotly
RUN npm install typescript -g


###############################
# Custom Jupyter Extensions.
###############################
RUN jupyter labextension install @maap-jupyterlab/hide-che-panel-jupyter-extension@1.0.0 --no-build
RUN jupyter labextension install @maap-jupyterlab/jobs-dps-jupyter-extension@jupyterlab_v3 --no-build
RUN jupyter labextension install @maap-jupyterlab/dps-jupyter-server-extension@jupyterlab_v3 --no-build
RUN jupyter labextension install @maap-jupyterlab/edsc-jupyter-extension@1.0.1 --no-build
RUN jupyter labextension install @maap-jupyterlab/maapsec-jupyter-extension@1.0.0 --no-build

RUN jupyter lab build && \
    jupyter lab clean && \
    jlpm cache clean && \
    npm cache clean --force && \
    rm -rf $HOME/.node-gyp && \
    rm -rf $HOME/.local

RUN find /opt/conda/ -follow -type f -name '*.a' -delete && \
    find /opt/conda/ -follow -type f -name '*.js.map' -delete && \
    /opt/conda/bin/conda clean -afy && \
    npm cache clean --force

