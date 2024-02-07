# Remote orchestration

This file contains the instructions to set up and run the service on the remote.

## Prerequisites

To keep the configuration files simple - i.e. without templating they assume the following:
1. OS is Ubuntu version 20.04
2. user is ubuntu with root privileges
3. user has `$HOME` at `/home/ubuntu`
4. there are enough resources
    + at least 16 cpu machine with at least 32GB  RAM
    + at least 40GB free space at `$HOME`
    + at least 500GB of space available on any filesystem
      + default tries to use `/mnt/data` as root for datasets

## Installation

If you change the installation directory from `protein-search-deployment`
also adjust the path in the systemd service.

```shell
mkdir protein-search-deployment && cd protein-search-deployment
wget -O install_latest.sh "https://raw.githubusercontent.com/sb-ncbr/protein-similarity-parent-project/master/remote_orchestration/install_latest.sh"
chmod u+x install_latest.sh
./install_latest.sh
```

Adjust your configuration in `protein-search-deployment/run.properties`.
The solution should out of the box if all prerequisites were met.

Verify that systemd service is in place
```shell
systemctl status protein-search-mgmt.service
```

### Fresh install notes

Upon fresh install there will be no dataset. You can either wait for automatic update at 1am
or force the update yourself via CLI

```shell
java -cp JOIntegration-with-dependencies.jar com.example.CliApp --run updateDataset
```

restart the systemd service afterward

```shell
systemctl restart protein-search-mgmt.service
```

