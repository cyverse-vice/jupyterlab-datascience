#!/bin/bash

echo '{"irods_host": "data.cyverse.org", "irods_port": 1247, "irods_user_name": "$IPLANT_USER", "irods_zone_name": "iplant"}' | envsubst > $HOME/.irods/irods_environment.json

# Copy .gitconfig from volume mount
cp ~/data-store/iplant/home/{$IPLANT_USER}/.gitconfig ~/.gitconfig

exec jupyter lab --no-browser --LabApp.token="" --LabApp.password=""
