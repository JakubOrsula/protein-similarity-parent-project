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

INSTALLATION_LOCATION=/home/ubuntu/protein-search-deployment
mkdir $INSTALLATION_LOCATION && cd $INSTALLATION_LOCATION

mkdir cpp_dependencies && cd cpp_dependencies
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

cd $INSTALLATION_LOCATION/cpp_dependencies
cd gesamt_distance || { git clone https://github.com/JakubOrsula/gesamt_distance.git && cd gesamt_distance; }
git pull
git checkout origin/master
mkdir -p build
cd build
cmake ..
make -j
sudo make install

cd $INSTALLATION_LOCATION

# Download management solution
mkdir managment-solution cd managment-solution
wget -O JOIntegration-with-dependencies.jar https://github.com/JakubOrsula/protein-similarity-parent-project/releases/download/untagged-22bf72fdbead6b26d7fb/JOIntegration-1.0-SNAPSHOT-jar-with-dependencies.jar


# install systemd service
cp remote_orchestration.service /etc/systemd/system/remote_orchestration.service
systemctl daemon-reload
systemctl enable protein-search-mgmt.service


# Download messiff solution


# chatgpt sudo cp remote_orchestration.service /etc/systemd/system/remote_orchestration.service

# Instruct user to specify the configuration


# ----- SEPARATE SCRIPT -----
# Verify the configuration

# register systemd hook to run at startup
# chatgpt sudo systemctl enable remote_orchestration.service
