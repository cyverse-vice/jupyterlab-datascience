#!/bin/bash

echo '{"irods_host": "data.cyverse.org", "irods_port": 1247, "irods_user_name": "$IPLANT_USER", "irods_zone_name": "iplant"}' | envsubst > $HOME/.irods/irods_environment.json
python -m ipykernel install --user --name=geospatial --display-name "Python (Geospatial)" 
exec jupyter lab --no-browser 
