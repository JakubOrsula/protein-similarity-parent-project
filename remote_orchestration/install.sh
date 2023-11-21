#!/bin/bash

set -x

INSTALLATION_LOCATION=$(pwd)

# attempt to stop messiffs
cd dependencies/mics-proteins/ppp_codes
./http.sh stop
cd "$INSTALLATION_LOCATION"/dependencies/mics-proteins/sequential_sketches
./http_64pivots.sh stop
./http_512pivots.sh stop
cd "$INSTALLATION_LOCATION"

# todo systemctl stop protein-search-mgmt.service

set -e

# backup configuration file
touch run.properties
cp run.properties run.properties.old


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

sleep 5

# Install dependencies
sudo apt-get update -y
sudo apt-get install -y unzip
sudo apt-get install -y openjdk-17-jdk
sudo apt-get install -y cmake build-essential
sudo apt-get install -y libz-dev
sudo apt-get install -y python3-pybind11
sudo apt-get install -y python3-dev
sudo apt-get install -y python3.8-venv
sudo apt-get install -y gcc libpq-dev
sudo apt-get install -y python3-pip
sudo apt-get install -y python3-wheel
pip3 install wheel
sudo apt-get install -y mariadb-server
sudo apt-get install -y libmariadb3
sudo apt-get install -y libmariadb-dev
sudo apt-get install -y pymol # webapp visualizations
sudo apt-get install -y imagemagick # webapp visualizations
sudo apt-get install -y ghostscript # webapp visualizations
sudo apt-get install -y fonts-freefont-otf # webapp visualizations


# Check if the .mysql_setup_done file exists
if [ ! -f ~/.mysql_setup_done ]; then
    echo "MySQL secure installation not completed in a previous run. Starting..."
    echo "You will be aksed to set up root password - we recommend setting it to 'password' as it is the default in the solution."
    sudo mysql_secure_installation

    touch ~/.mysql_setup_done
    echo "MySQL secure installation completed and marker file created."
else
    echo "MySQL secure installation already completed in a previous run."
fi

echo '# Set JDK installation directory according to selected Java compiler' | sudo tee /etc/profile.d/java_home.sh
echo 'export JAVA_HOME=$(readlink -f /usr/bin/javac | sed "s:/bin/javac::")' | sudo tee -a /etc/profile.d/java_home.sh
source /etc/profile.d/java_home.sh

INSTALLATION_LOCATION=$(pwd)

# Download and install dependencies
rm -rf dependencies
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
git checkout master
git pull
mkdir -p build && cd build
cmake ..
make -j
sudo make install
cd ..
rm -rf build
git checkout jo-integration
git pull
mkdir build && cd build
cmake ..
make -j
# note no install - library version for jo-integration is not needed system wide

cd $INSTALLATION_LOCATION

# Download management solution
wget -O JOIntegration-with-dependencies.jar https://github.com/JakubOrsula/protein-similarity-parent-project/releases/download/"$SOLUTION_VERSION"/JOIntegration-1.0-SNAPSHOT-jar-with-dependencies.jar
wget -O run.properties https://github.com/JakubOrsula/protein-similarity-parent-project/releases/download/"$SOLUTION_VERSION"/run.properties.example
mkdir -p secondaryFiltering # for secondaryFiltering results

# Set up systemd service
sudo wget -O /etc/systemd/system/protein-search-mgmt.service https://github.com/JakubOrsula/protein-similarity-parent-project/releases/download/"$SOLUTION_VERSION"/protein-search-mgmt.service
sudo systemctl daemon-reload
sudo systemctl enable protein-search-mgmt.service


# Download messiff solution
cd $INSTALLATION_LOCATION/dependencies
mkdir mics-proteins && cd mics-proteins
wget -O release.zip https://github.com/JakubOrsula/mics-proteins/releases/download/"$PROTEINS_VERSION"/release.zip
unzip release.zip
rm -rf release.zip
cp -r jars ppp_codes/
cp -r jars sequential_sketches/
rm -rf jars
cd $INSTALLATION_LOCATION/dependencies
wget -O proteins.jar https://github.com/JakubOrsula/mics-proteins/releases/download/"$PROTEINS_VERSION"/proteins.jar


# Download python solution
cd $INSTALLATION_LOCATION/dependencies
mkdir tmpfiles
git clone https://github.com/JakubOrsula/ProteinSearch
cd ProteinSearch
python3 -m venv venv --system-site-packages
echo 'export PYTHONPATH="$PYTHONPATH:/usr/local/lib"' >> venv/bin/activate
source venv/bin/activate
sudo apt-get install -y apache2-dev
pip install -r requirements.txt
pip install -r requirements.txt
deactivate

cd $INSTALLATION_LOCATION

echo '========================='
echo 'Installation successful!'
echo '========================='

# Instruct user to specify the configuration and start the service
echo "Please edit the run.properties configuration file"
echo "and start the service with 'sudo systemctl start protein-search-mgmt.service'"
echo "reboot is recommended to ensure the service starts on boot"
