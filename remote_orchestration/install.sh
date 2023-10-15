#!/bin/bash

set -e
set -x

# Install dependencies
sudo apt-get update -y
sudo apt-get install -y openjdk-17-jdk
sudo apt-get install -y cmake build-essential
sudo apt-get install -y libz-dev
sudo apt-get install -y python3-pybind11
sudo apt-get install -y python3-dev
sudo apt-get install -y python3.8-venv
sudo apt-get install -y mariadb-server
sudo mysql_secure_installation

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

cd ../..

cd gesamt_distance || { git clone https://github.com/JakubOrsula/gesamt_distance.git && cd gesamt_distance; }
git pull
git checkout origin/master
mkdir -p build
cd build
cmake ..
make -j
sudo make install

cd ../..

# Download management solution


# Download messiff solution

# install systemd service
# chatgpt sudo cp remote_orchestration.service /etc/systemd/system/remote_orchestration.service

# Instruct user to specify the configuration


# ----- SEPARATE SCRIPT -----
# Verify the configuration

# register systemd hook to run at startup
# chatgpt sudo systemctl enable remote_orchestration.service
