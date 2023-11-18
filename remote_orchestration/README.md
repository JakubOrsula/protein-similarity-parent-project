# Remote orchestration

This file contains the instructions to set up and run the service on the remote.

## Prerequisites

To keep the configuration files simple - i.e. without templating they assume the following:
1. OS is a recent version of ubuntu
2. user is ubuntu with root privileges
3. user hase `$HOME` at `/home/ubuntu`
4. there are enough resources
    + at least 16 cpu machine with at least 32GB  RAM
    + at least 5GB free space at `$HOME`
    + at least 500GB data mounted
      + mountpoint is configurable but `/mnt/data` is the default

## Installation

You will need to know which version of the solution you want to install.
Latest is a recommended option.
Grab the version number from:
1. [releases](https://github.com/JakubOrsula/protein-similarity-parent-project/releases/latest)
2. [proteins project releases](https://github.com/JakubOrsula/protein-similarity-parent-project/releases/latest)

Run installation script using

```shell
SOLUTION_VERSION=3.003
PROTEINS_VERSION=0.24
mkdir protein-search-deployment && cd protein-search-deployment
wget -O install.sh "https://github.com/JakubOrsula/protein-similarity-parent-project/releases/download/$SOLUTION_VERSION/install.sh"
chmod u+x install.sh
./install.sh $SOLUTION_VERSION $PROTEINS_VERSION
```


### Configuration

Verify that systemd service is in place
```shell
systemctl status protein-search-mgmt.service
```

Please reboot before continuing.