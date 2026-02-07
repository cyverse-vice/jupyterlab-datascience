#!/bin/bash
# Configure iRODS environment
mkdir -p $HOME/.irods
echo '{"irods_host": "data.cyverse.org", "irods_port": 1247, "irods_user_name": "$IPLANT_USER", "irods_zone_name": "iplant"}' | envsubst > $HOME/.irods/irods_environment.json

# Copy credentials from data-store mount (if they exist)
if [ -f /data-store/iplant/home/$IPLANT_USER/.gitconfig ]; then
  cp /data-store/iplant/home/$IPLANT_USER/.gitconfig ~/
fi

if [ -d /data-store/iplant/home/$IPLANT_USER/.ssh ]; then
  cp -r /data-store/iplant/home/$IPLANT_USER/.ssh ~/
fi

# Start JupyterLab
exec start-notebook.py
