#!/bin/bash

mkdir -p $HOME/.irods
touch $HOME/.irods/irods_environment.json
echo '{"irods_host": "data.cyverse.org", "irods_port": 1247, "irods_user_name": "$IPLANT_USER", "irods_zone_name": "iplant"}' >> $HOME/.irods/irods_environment.json

echo "export PATH=$PATH:/opt/conda/bin" >> ~/.bashrc

if [ -f /data-store/iplant/home/$IPLANT_USER/.gitconfig ]; then
  cp /data-store/iplant/home/$IPLANT_USER/.gitconfig ~/
fi

if [ -d /data-store/iplant/home/$IPLANT_USER/.ssh ]; then
  cp -r /data-store/iplant/home/$IPLANT_USER/.ssh ~/
fi

exec jupyter lab --no-browser --LabApp.token="" --LabApp.password="" --ip="0.0.0.0" --port=8888