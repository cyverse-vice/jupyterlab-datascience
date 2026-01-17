#!/bin/bash

function irods_environment() {
    cat <<EOF
{
    "irods_host": "data.cyverse.org",
    "irods_port": 1247,
    "irods_user_name": "$IPLANT_USER",
    "irods_zone_name": "iplant"
}
EOF
}

# Create iRODS configuration
mkdir -p $HOME/.irods
touch $HOME/.irods/irods_environment.json
irods_environment >> $HOME/.irods/irods_environment.json

# Add conda to PATH
echo "npm config set prefix /home/jovyan/.npm-global" && \
echo "export PATH=/home/jovyan/.npm-global/bin:/opt/conda/bin:$PATH" >> ~/.bashrc

# Copy configuration files from data store (legacy method)
if [ -f /data-store/iplant/home/$IPLANT_USER/.gitconfig ]; then
  cp /data-store/iplant/home/$IPLANT_USER/.gitconfig ~/
fi

if [ -d /data-store/iplant/home/$IPLANT_USER/.ssh ]; then
  cp -r /data-store/iplant/home/$IPLANT_USER/.ssh ~/
fi

exec jupyter lab --no-browser --LabApp.token="" --LabApp.password=""
