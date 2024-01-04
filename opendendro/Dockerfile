FROM harbor.cyverse.org/vice/jupyter/datascience:4.0.1

# Base packages
RUN R -e "install.packages(c('KernSmooth', 'MASS', 'Matrix', 'codetools', 'lattice', 'mgcv', 'nlme'), \
  repos='http://cran.rstudio.com/', version='4.2.3')"

# Database related packages
RUN R -e "install.packages(c('DBI', 'R6', 'bit', 'bit64', 'blob'), \
  repos='http://cran.rstudio.com/', version='4.2.3')"

# Data manipulation and visualization packages
RUN R -e "install.packages(c('dplyr', 'ggplot2', 'plyr', 'reshape2', 'tidyr', 'tidyselect', 'tidyverse'), \
  repos='http://cran.rstudio.com/', version='4.2.3')"

# HTTP and web related packages
RUN R -e "install.packages(c('curl', 'httr', 'httr2', 'httpuv'), \
  repos='http://cran.rstudio.com/', version='4.2.3')"

# String and text related packages
RUN R -e "install.packages(c('stringi', 'stringr'), \
  repos='http://cran.rstudio.com/', version='4.2.3')"

# Date and time related packages
RUN R -e "install.packages(c('lubridate', 'timechange'), \
  repos='http://cran.rstudio.com/', version='4.2.3')"

# IO related packages
RUN R -e "install.packages(c('readr', 'readxl', 'vroom'), \
  repos='http://cran.rstudio.com/', version='4.2.3')"

# Development related packages
RUN R -e "install.packages(c('devtools', 'roxygen2', 'testthat', 'usethis'), \
  repos='http://cran.rstudio.com/', version='4.2.3')"


# Install dplR
RUN R -e "install.packages(c('dplR'), \
    repos='http://cran.rstudio.com/', version='4.2.3')"

# Install dplPy & create Jupyter kernel 
RUN git clone --branch 0.1.x --depth 1 https://github.com/OpenDendro/dplPy.git && \
    cd dplPy && \   
    mamba env create -f environment.yml 
# using ~/.bash_profile instead of ~/.bashrc for non-interactive tty (-it) containers
RUN echo ". /opt/conda/etc/profile.d/conda.sh" >> /home/jovyan/.bash_profile && \
    echo "conda deactivate" >> /home/jovyan/.bash_profile && \
    echo "conda activate dplpy" >> /home/jovyan/.bash_profile
RUN . /opt/conda/etc/profile.d/conda.sh && conda activate dplpy && python -m ipykernel install --user --name "dplpy"   
RUN source /home/jovyan/.bash_profile