FROM cyversevice/jupyterlab-datascience:2.2.9 

USER root

RUN apt-get update && \
    apt-get install -y libfreetype6-dev pkg-config libx11-dev && \
    apt-get clean && \
    rm -rv /var/lib/apt/lists/*

RUN chown -R jovyan:jovyan /opt/conda
USER jovyan

RUN conda update -n base conda 

RUN conda install --yes -c conda-forge \
    altair \
    awscli \
    bottleneck \
    contextily \
    cython \  
    dask \
    h5py \
    humanize \
    gcsfs \ 
    google-api-python-client \
    ipyparallel \
    ipyvolume \
    ipywidgets \
    matplotlib \
    ncurses \
    netcdf4 \
    nodejs \
    numcodecs \ 
    oauth2client \
    opencv \
    palettable \
    pandas \
    pathlib2 \
    pycrypto \
    pyhdf \
    pyresample \
    pyproj \
    pysal \
    rasterio \
    s3fs \
    scikit-learn \
    scikit-image \
    scipy \
    scikit-image \
    seaborn \
    shapely \
    six \
    spectral \
    statsmodels \
    tqdm \
    udunits2 \
    wget 

# Geospatial Conda Packages
RUN conda install --yes -c conda-forge \
    entwine \
    geos \
    gdal \
    pdal \
    proj 

RUN conda install --yes -c conda-forge \
    cartopy \
    fiona \    
    folium \     
    geopandas \
    ipyleaflet 

RUN conda install --yes -c conda-forge \
    earthengine-api \
    geemap 

RUN conda install --yes -c conda-forge\
    planet    

RUN conda install --yes -c conda-forge \
    regionmask \
    satpy \
    xarray \
    xarray-topo \
    xarray-simlab \
    vega_datasets \
    zarr 


# add Tensorflow Probability -- late in the build may move to prior container sooner than later
RUN conda install --yes -c conda-forge tensorflow-probability

RUN conda clean --all -f -y 

# Install JupyterLab Extensions

RUN conda install -c conda-forge jupyter_bokeh

RUN pip install jupyterlab-geojson sidecar

RUN jupyter labextension install @jupyterlab/toc

RUN jupyter labextension install \
    ipyvolume \
    itkwidgets \    
    jupyterlab_iframe \ 
    jupyter-leaflet \
    jupyter-threejs \
 && npm cache clean --force

# add bqplot extension
RUN jupyter labextension install bqplot && \
    jupyter nbextension install bqplot --py --symlink --sys-prefix && \ 
    jupyter nbextension enable bqplot --py --sys-prefix

RUN jupyter lab build

# pip install Planet POrder 
RUN pip install xshape porder

RUN conda clean --all -f -y

USER root
# purge older nodejs
RUN apt purge nodejs -y

USER jovyan
WORKDIR /home/jovyan

# install iRODS plugin
RUN conda install -c conda-forge nodejs -y
RUN pip install jupyterlab_irods

USER root
RUN jupyter serverextension enable --py jupyterlab_irods
RUN jupyter labextension install ijab

USER jovyan
