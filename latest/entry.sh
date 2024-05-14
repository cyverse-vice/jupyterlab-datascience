#!/bin/bash

echo '{"irods_host": "data.cyverse.org", "irods_port": 1247, "irods_user_name": "$IPLANT_USER", "irods_zone_name": "iplant"}' >> $HOME/.irods/irods_environment.json

echo "export PATH=$PATH:/opt/conda/bin" >> ~/.bashrc

if [ -f /data-store/iplant/home/$IPLANT_USER/.gitconfig ]; then
  cp /data-store/iplant/home/$IPLANT_USER/.gitconfig ~/
fi

exec jupyter lab --no-browser --LabApp.token="" --LabApp.password=""
