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

# Download and install cpp dependencies
mkdir dependencies && cd dependencies
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

cd $INSTALLATION_LOCATION/dependencies
cd gesamt_distance || { git clone https://github.com/JakubOrsula/gesamt_distance.git && cd gesamt_distance; }
git pull
git checkout origin/master
mkdir -p build
cd build
cmake ..
make -j
sudo make install
cd ..
rm -rf build
git checkout origin/jo-integration
mkdir build
cmake ..
make -j
# note no install - library version for jo-integration is not needed system wide

cd $INSTALLATION_LOCATION


# Download management solution
mkdir managment-solution cd managment-solution
wget -O JOIntegration-with-dependencies.jar https://github.com/JakubOrsula/protein-similarity-parent-project/releases/download/2.06/JOIntegration-1.0-SNAPSHOT-jar-with-dependencies.jar
wget -O run.properties https://github.com/JakubOrsula/protein-similarity-parent-project/releases/download/2.06/run.properties.example


# Set up systemd service
wget -O /etc/systemd/system/protein-search-mgmt.service https://github.com/JakubOrsula/protein-similarity-parent-project/releases/download/2.06/protein-search-mgmt.service
systemctl daemon-reload
systemctl enable protein-search-mgmt.service


# Download messiff solution


# Download python solution
git clone https://github.com/JakubOrsula/ProteinSearch
cd ProteinSearch
python3 -m venv venv
source venv/bin/activate
sudo apt-get install -y apache2-dev
pip install -r requirements.txt

# Instruct user to specify the configuration and start the service
echo "Please edit the run.properties configuration file"
echo "and start the service with 'sudo systemctl start protein-search-mgmt.service'"
echo "reboot is recommended to ensure the service starts on boot"