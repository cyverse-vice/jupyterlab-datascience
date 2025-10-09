#!/bin/bash

# Create iRODS configuration
mkdir -p $HOME/.irods
touch $HOME/.irods/irods_environment.json
echo '{"irods_host": "data.cyverse.org", "irods_port": 1247, "irods_user_name": "$IPLANT_USER", "irods_zone_name": "iplant"}' >> $HOME/.irods/irods_environment.json

# Add conda to PATH
echo "export PATH=$PATH:/opt/conda/bin" >> ~/.bashrc

# Copy configuration files from data store (legacy method)
if [ -f /data-store/iplant/home/$IPLANT_USER/.gitconfig ]; then
  cp /data-store/iplant/home/$IPLANT_USER/.gitconfig ~/
fi

if [ -d /data-store/iplant/home/$IPLANT_USER/.ssh ]; then
  cp -r /data-store/iplant/home/$IPLANT_USER/.ssh ~/
fi

# Source hidden environment files provided by K8s CSI driver
# These files will be mounted to /home/jovyan/ by the K8s CSI driver
for env_file in /home/jovyan/.*env*; do
  if [ -f "$env_file" ] && [ -r "$env_file" ]; then
    echo "Sourcing environment file: $env_file"
    set -a  # automatically export all variables
    source "$env_file"
    set +a  # disable automatic export
  fi
done

# Source any .env files in the home directory
for env_file in /home/jovyan/.env*; do
  if [ -f "$env_file" ] && [ -r "$env_file" ]; then
    echo "Sourcing environment file: $env_file"
    set -a  # automatically export all variables
    source "$env_file"
    set +a  # disable automatic export
  fi
done

exec jupyter lab --no-browser --LabApp.token="" --LabApp.password="" --ip="0.0.0.0" --port=8888
