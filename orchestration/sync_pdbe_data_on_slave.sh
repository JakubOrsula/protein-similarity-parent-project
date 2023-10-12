#!/bin/bash -ex

# Check if the REMOTE address is provided as an argument
if [ $# -eq 0 ]; then
  echo "REMOTE address not provided"
  exit 1
fi

# Set the REMOTE address and username as variables
REMOTE=$1
MASTER=ubuntu@147.251.21.168 #todo to .env and share with other scripts

# Use here document to execute commands on the remote server
ssh "$REMOTE" << EOF
  set -e # Stop the script if any command fails
  set -x # Print all commands being executed

  rsync -a --info=progress2 --delete $MASTER:/mnt/data-ssd/PDBe_binary/ ./PDBe_binary/
EOF
