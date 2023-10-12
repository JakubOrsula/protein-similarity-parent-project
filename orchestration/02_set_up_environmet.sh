#!/bin/bash -ex

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
  sudo apt-get update -y
  sudo apt-get install -y openjdk-17-jdk
  sudo apt-get install -y cmake build-essential
  sudo apt-get install -y libz-dev
  sudo apt-get install -y python3-pybind11
  sudo apt-get install -y python3-dev
  sudo apt-get install -y python3.8-venv

  if [ -d "tbb" ]; then
    cd tbb
    git pull
  else
    git clone https://github.com/wjakob/tbb.git
    cd tbb
    mkdir -p build
  fi
  cd build
  cmake ..
  make -j
  sudo make install

  cd ~

  if [ -d "gesamt_distance" ]; then
      cd gesamt_distance
      git pull
    else
      git clone https://github.com/JakubOrsula/gesamt_distance.git
      cd gesamt_distance
      git checkout jakub/master
      mkdir -p build
    fi
  cd build
  cmake ..
  make -j
  sudo make install
EOF
