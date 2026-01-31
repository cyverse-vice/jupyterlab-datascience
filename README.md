[![Project Supported by CyVerse](https://de.cyverse.org/Powered-By-CyVerse-blue.svg)](https://learning.cyverse.org/projects/vice/en/latest/) [![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active) [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.4540701.svg)](https://doi.org/10.5281/zenodo.4540701) [![license](https://img.shields.io/badge/license-BSD3-red.svg)](https://opensource.org/licenses/BSD-3-Clause)

# JupyterLab Data Science

[Project Jupyter](https://jupyter.org/) Data Science Notebook with AI tools and CyVerse integration for the [CyVerse Discovery Environment](https://de.cyverse.org).

Built from the official [Jupyter Docker Stacks](https://jupyter-docker-stacks.readthedocs.io/) `datascience-notebook` image with additional tools for cloud-based data science workflows.

[![Harbor Build Status](https://github.com/cyverse-vice/jupyterlab-datascience/actions/workflows/harbor.yml/badge.svg)](https://github.com/cyverse-vice/jupyterlab-datascience/actions) ![GitHub commits since tagged version](https://img.shields.io/github/commits-since/cyverse-vice/jupyterlab-datascience/latest/main?style=flat-square)

## Quick Launch

| Version | Instant Launch | Regular Launch |
|---------|----------------|----------------|
| 4.3.4 | <a href="https://de.cyverse.org/instantlaunch/576c2c18-ed5f-11ef-b797-008cfa5ae621" target="_blank" rel="noopener noreferrer"><img src="https://de.cyverse.org/Powered-By-CyVerse-blue.svg"></a> | <a href="https://de.cyverse.org/apps/de/c2227314-1995-11ed-986c-008cfa5ae621/launch" target="_blank" rel="noopener noreferrer"><img src="https://img.shields.io/badge/Datascience-latest-orange?style=plastic&logo=jupyter"></a> |

## Features

### AI Development Tools
- **Claude Code** - Anthropic AI coding assistant (`claude`)
- **Gemini CLI** - Google AI CLI (`gemini`)
- **OpenAI Codex** - OpenAI coding assistant (`codex`)
- **Jupyter AI** - AI assistant integration for notebooks

### Development Tools
- **GitHub CLI (`gh`)** - Command-line tool for GitHub operations
- **Git Credential Manager** - Secure credential storage
- **VS Code Server** - Browser-based VS Code environment

### Data Science & Analytics
- **Python** - NumPy, Pandas, Matplotlib, Scikit-learn
- **R** - RStudio integration available
- **Julia** - Julia kernel support
- **RStudio Server** - Web-based R development
- **Shiny Server** - Interactive R applications

### CyVerse Integration
- **GoCommands (`gocmd`)** - CyVerse data transfer utilities
- **iRODS integration** - Direct access to CyVerse Data Store
- **K8s CSI driver support** - Automatic environment configuration

### System Utilities
- **Monitoring** - htop, glances for system monitoring
- **Build tools** - gcc, development essentials

## Run Locally

```bash
# Pull the container
docker pull harbor.cyverse.org/vice/jupyter/datascience:latest

# Run the container
docker run -it --rm -p 8888:8888 -e REDIRECT_URL=http://localhost:8888 harbor.cyverse.org/vice/jupyter/datascience:latest
```

Access JupyterLab at: http://localhost:8888

## Build Your Own Container

```dockerfile
FROM harbor.cyverse.org/vice/jupyter/datascience:latest

# Add your customizations
RUN mamba install -y your-package
```

## Development

### Building Large Images

The larger variants (geospatial, earthlab, ML types) are >5GB compressed and >30GB uncompressed. Recommended build environment:
- 8+ CPU cores
- 16+ GB RAM
- 60+ GB disk space

### Build Steps

1. Clone the repository
2. Check current Jupyter Docker Stacks version
3. Update dependencies as needed
4. Build and test locally
5. Push to GitHub for CI/CD

```bash
git clone https://github.com/cyverse-vice/jupyterlab-datascience
cd jupyterlab-datascience/latest
docker build -t jupyter-datascience:latest .
```

## Resources

- [CyVerse VICE Documentation](https://learning.cyverse.org/vice/about/)
- [Integrate Your Own Tools](https://learning.cyverse.org/de/create_apps/)
- [Jupyter Docker Stacks](https://jupyter-docker-stacks.readthedocs.io/)
- [GoCommands Documentation](https://learning.cyverse.org/ds/gocommands/)
