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
wget -O install.sh https://github.com/JakubOrsula/protein-similarity-parent-project/releases/download/2.06/install.sh
chmod u+x install.sh
./install.sh <release version of this project> <release version of proteins project>
```


### Configuration

Verify that systemd service is in place
```shell
systemctl status protein-search-mgmt.service
```

Please reboot before continuing.