[![Project Supported by CyVerse](https://img.shields.io/badge/Supported%20by-CyVerse-blue.svg)](https://learning.cyverse.org/projects/vice/en/latest/) [![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active) [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.4540701.svg)](https://doi.org/10.5281/zenodo.4540701)
 [![license](https://img.shields.io/badge/license-BSD3-red.svg?style=flat-square)](https://opensource.org/licenses/BSD-3-Clause) ![GitHub all releases](https://img.shields.io/github/downloads/cyverse-vice/jupyterlab-datascience/total?style=flat-square)

# jupyterlab-datascience
[Project Jupyter](https://jupyter.org/) Data Science Notebook with CyVerse addins 

Jupyter Lab Datascience image built from the [Datascience Notebook](https://hub.docker.com/r/jupyter/datascience-notebook) for [CyVerse VICE](https://cyverse-visual-interactive-computing-environment.readthedocs-hosted.com/en/latest/index.html). Project Jupyter's base image requires a couple additional configuration files for it be compatible with CyVerse Kubernetes orchestration and iRODS data store.

[![CircleCI](https://circleci.com/gh/cyverse-vice/jupyterlab-datascience.svg?style=svg)](https://circleci.com/gh/cyverse-vice/jupyterlab-datascience) ![GH actions branch parameter](https://github.com/github/docs/actions/workflows/main.yml/badge.svg?branch=main) ![GitHub commits since tagged version](https://img.shields.io/github/commits-since/cyverse-vice/jupyterlab-datascience/latest/main?style=flat-square) [![Docker Pulls](https://img.shields.io/docker/pulls/cyversevice/Datascience?color=orange&logo=docker&logoColor=white)](https://hub.docker.com/r/cyversevice/jupyterlab-datascience) 

quick launch | size | 
------------ | ---- | 
<a href="" target="_blank"><img src="https://img.shields.io/badge/Datascience-latest-orange?style=plastic&logo=jupyter"></a> | [![SIZE](https://img.shields.io/docker/image-size/cyversevice/jupyterlab-datascience/latest.svg)](https://img.shields.io/docker/image-size/cyversevice/jupyterlab-datascience/latest) |
<a href="" target="_blank"><img src="https://img.shields.io/badge/Datascience-3.0.15-orange?style=plastic&logo=jupyter"></a> | [![SIZE](https://img.shields.io/docker/image-size/cyversevice/jupyterlab-datascience/3.0.15.svg)](https://img.shields.io/docker/image-size/cyversevice/jupyterlab-datascience/3.0.15) |
<a href="" target="_blank"><img src="https://img.shields.io/badge/Datascience-3.0.5-orange?style=plastic&logo=jupyter"></a> | [![SIZE](https://img.shields.io/docker/image-size/cyversevice/jupyterlab-datascience/3.0.5.svg)](https://img.shields.io/docker/image-size/cyversevice/jupyterlab-datascience/3.0.5) |
<a href="https://de.cyverse.org/apps/de/07a2d5b2-76e2-11eb-be5f-008cfa5ae621/launch?quick-launch-id=60054c75-0e80-4169-8a9b-51cba04f756d" target="_blank"><img src="https://img.shields.io/badge/Datascience-2.2.9-orange?style=plastic&logo=jupyter"></a> | [![SIZE](https://img.shields.io/docker/image-size/cyversevice/jupyterlab-datascience/2.2.9.svg)](https://img.shields.io/docker/image-size/cyversevice/jupyterlab-datascience/2.2.9) |

# Instructions

## Run Docker locally or on a Virtual Machine

To run the JupyterLab, you must first `pull` from DockerHub, or activate a [CyVerse Account](https://user.cyverse.org/services/mine) and launch in the Discovery Environment VICE.

The container for running JupyterLab is hosted on DockerHub and can be started locally:


```
docker pull cyversevice/jupyterlab-datascience:latest
```

```
docker run -it --rm -d cyversevice/jupyterlab-datascience:latest
```

## Run Docker container in CyVerse VICE

Unless you plan on making changes to this container, you should just use the existing launch button above.

You can build a new Docker container with additional dependencies from this Docker Hub image by using the `FROM cyversevice/jupyterlab-scipy:latest` at the beginning of your own Dockerfile.

###### Developer notes

To test the container locally:

```
docker run -it --rm -v /$HOME:/work --workdir /work -p 8888:8888 -e REDIRECT_URL=http://localhost:8888 cyversevice/jupyterlab-datascience:latest
```
