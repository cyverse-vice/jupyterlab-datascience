[![Project Supported by CyVerse](https://de.cyverse.org/Powered-By-CyVerse-blue.svg)](https://learning.cyverse.org/projects/vice/en/latest/) [![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active) [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.4540701.svg)](https://doi.org/10.5281/zenodo.4540701)
 [![license](https://img.shields.io/badge/license-BSD3-red.svg?style=flat-square)](https://opensource.org/licenses/BSD-3-Clause) 

# jupyterlab-datascience

:exclamation: **Developer note:** As mentioned in [the official Jupyter image stack repository, newer images are pushed to quay.io](https://github.com/jupyter/docker-stacks?tab=readme-ov-file#quick-start). Please pull from `quay.io/jupyter/datascience-notebook` when developing new Tools and Apps.

[Project Jupyter](https://jupyter.org/) Datascience Notebook with a few added packages for use in [CyVerse Discovery Environment](https://de.cyverse.org)

Jupyter Lab Datascience image built from the [Datascience Notebook](https://hub.docker.com/r/jupyter/datascience-notebook) for [CyVerse VICE](https://cyverse-visual-interactive-computing-environment.readthedocs-hosted.com/en/latest/index.html). Project Jupyter's base image requires a couple additional configuration files for it be compatible with CyVerse Kubernetes orchestration and iRODS data store.

[![!Harbor](https://github.com/cyverse-vice/jupyterlab-datascience/actions/workflows/harbor.yml/badge.svg)](https://github.com/cyverse-vice/jupyterlab-datascience/actions) ![GitHub commits since tagged version](https://img.shields.io/github/commits-since/cyverse-vice/jupyterlab-datascience/latest/main?style=flat-square) 

| quick launch | 
| ------------ | 
| <a href="https://de.cyverse.org/apps/de/cc77b788-bc45-11eb-9934-008cfa5ae621/launch" target="_blank"><img src="https://img.shields.io/badge/Datascience-latest-orange?style=plastic&logo=jupyter"></a> |
| <a href="https://de.cyverse.org/apps/de/0bb01716-5d03-11ec-b195-008cfa5ae621/launch" target="_blank"><img src="https://img.shields.io/badge/Geospatial-latest-orange?style=plastic&logo=jupyter"></a> |
| <a href="https://de.cyverse.org/apps/de/c2227314-1995-11ed-986c-008cfa5ae621/launch" target="_blank"><img src="https://img.shields.io/badge/RStudio-latest-orange?style=plastic&logo=r"></a> |

## Development

1. Use either CodeSpaces or another clean Dev Environment that you trust to clone the repository

**note**: The larger datascience images (e.g., `geospatial`, `earthlab`, or ML types with CUDA, Tensorflow or Pytorch) are all >5GB in size when compressed and can be over 30GB when uncompressed. Make sure to use a VM with enough RAM and Disk storage (suggest >8 cores, >16 GB RAM, >60 GB disk).

2. Clone this repository

```
git clone https://github.com/cyverse-vice/jupyterlab-datascience
```

3. Determine what version the current `latest` image is running, and prepare a new folder with that version of JupyterHub if it is no longer `latest`.

Visit the [Jupyter Docker Stacks](https://jupyter-docker-stacks.readthedocs.io/en/latest/) pages

4. Rename the previous `latest` as its point release version number

5. Create a copy of the directory `latest` and make any updates required for broken package dependencies

6. Build the new image using the `latest` tag name

7. Test the new image by running it with a suitable sample notebook

8. Check the GitHub Action to make sure it is using the `latest` featured build successfully 

9. Push changes back to GitHub repository `main` branch and wait until GitHub Action completes.

## Running Docker locally or on a Virtual Machine

To run the JupyterLab, you must first `pull` from DockerHub, or activate a [CyVerse Account](https://user.cyverse.org/services/mine) and launch in the Discovery Environment VICE.

The container for running JupyterLab is hosted on DockerHub and can be started locally:

```
docker pull harbor.cyverse.org/vice/jupyter/datascience:latest
```

```
docker run -it --rm -p 8888:8888 harbor.cyverse.org/vice/jupyter/datascience:latest
```

## Run Docker container in CyVerse VICE

Unless you plan on making changes to this container, you should just use the existing launch button above.

You can build a new Docker container with additional dependencies from this Docker Hub image by using the `FROM cyversevice/jupyterlab-scipy:latest` at the beginning of your own Dockerfile.

## Developer notes

To test the container locally:

```
docker run -it --rm -p 8888:8888 -e REDIRECT_URL=http://localhost:8888 harbor.cyverse.org/vice/jupyter/datascience:latest
```

To build your own container with a Dockerfile and additional dependencies, pull the pre-built image from DockerHub:

```
FROM harbor.cyverse.org/vice/jupyter/datascience:latest
```

Follow the instructions in the [VICE manual for integrating your own tools and apps](https://learning.cyverse.org/vice/extend_apps/#building-an-app-for-your-tool).

---