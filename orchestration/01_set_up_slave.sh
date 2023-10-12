#!/bin/bash

set -e # Stop the script if any command fails
set -x # Print all commands being executed

# Check if the REMOTE address is provided as an argument
if [ $# -eq 0 ]; then
  echo "REMOTE address not provided"
  exit 1
fi

# Set the REMOTE address and username as variables
REMOTE=$1

# Use here document to execute commands on the remote server
ssh "$REMOTE" << EOF
  set -e # Stop the script if any command fails
  set -x # Print all commands being executed

  # Generate SSH key and save public key to file
  ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -q -N ""
  cat ~/.ssh/id_ed25519.pub > ~/id_ed25519.pub
  echo "export JAVA_HOME=/usr/lib/jvm/java-1.17.0-openjdk-amd64/" >> .bashrc
  echo "export LD_LIBRARY_PATH=/home/ubuntu/gesamt_distance/build/distance" >> .bashrc
EOF

# Copy public key to the local machine
scp "$REMOTE":~/id_ed25519.pub /tmp
scp /tmp/id_ed25519.pub protein-jo:/tmp/id_ed25519.pub

# Add public key to authorized keys on protein-jo machine
ssh protein-jo "mkdir -p ~/.ssh && cat /tmp/id_ed25519.pub >> ~/.ssh/authorized_keys && rm /tmp/id_ed25519.pub"

echo "this script is not IDEMPOTENT"