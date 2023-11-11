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

SOLUTION_VERSION=$1
PROTEINS_VERSION=$2

# Check if the first argument is empty
if [ -z "$SOLUTION_VERSION" ]; then
    echo "Error: SOLUTION_VERSION argument not provided."
    exit 1
fi

# Check if the second argument is empty
if [ -z "$PROTEINS_VERSION" ]; then
    echo "Error: PROTEINS_VERSION argument not provided."
    exit 1
fi

# Continue with the rest of the script if both arguments are present
echo "SOLUTION_VERSION: $SOLUTION_VERSION"
echo "PROTEINS_VERSION: $PROTEINS_VERSION"

INSTALLATION_LOCATION=$(pwd)/protein-search-deployment
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
wget -O JOIntegration-with-dependencies.jar https://github.com/JakubOrsula/protein-similarity-parent-project/releases/download/"$SOLUTION_VERSION"/JOIntegration-1.0-SNAPSHOT-jar-with-dependencies.jar
wget -O run.properties https://github.com/JakubOrsula/protein-similarity-parent-project/releases/download/"$SOLUTION_VERSION"/run.properties.example
wget -O update.sh https://github.com/JakubOrsula/protein-similarity-parent-project/releases/download/"$SOLUTION_VERSION"/update.sh
mkdir secondaryFiltering # for secondaryFiltering results

# Set up systemd service
wget -O /etc/systemd/system/protein-search-mgmt.service https://github.com/JakubOrsula/protein-similarity-parent-project/releases/download/"$SOLUTION_VERSION"/protein-search-mgmt.service
systemctl daemon-reload
systemctl enable protein-search-mgmt.service


# Download messiff solution
cd $INSTALLATION_LOCATION/dependencies
wget -O release.zip https://github.com/JakubOrsula/mics-proteins/releases/download/"$SOLUTION_VERSION"/release.zip
unzip release.zip
rm -rf release.zip
wget -O proteins.jar https://github.com/JakubOrsula/mics-proteins/releases/download/"$SOLUTION_VERSION"/proteins.jar


# Download python solution
cd $INSTALLATION_LOCATION/dependencies
mdkir tmpfiles
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