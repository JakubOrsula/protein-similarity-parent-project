#!/bin/bash -ex

# Check if the REMOTE address is provided as an argument
if [ $# -eq 0 ]; then
  echo "REMOTE address not provided"
  exit 1
fi

# Set the REMOTE address and username as variables
REMOTE=$1
rsync -av --info=progress2 --delete ../JOIntegration/target/JOIntegration-1.0-SNAPSHOT-jar-with-dependencies.jar $REMOTE:~/run/
rsync -av --info=progress2 --delete ./slave_run.properties $REMOTE:~/run/
rsync -av --info=progress2 --delete ./run_me_on_slave_app.sh $REMOTE:~/run/
rsync -av --info=progress2 --delete ./run_me_on_slave_tunnel.sh $REMOTE:~/run/

