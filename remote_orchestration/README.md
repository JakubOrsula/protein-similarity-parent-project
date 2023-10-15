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

Run installation script using

```shell
wget -O - https://raw.githubusercontent.com/.../install.sh | bash
```

or if you need curl

```shell
curl -sSL https://raw.githubusercontent.com/.../install.sh | bash
```

### Configuration

Verify that systemd service is in place
```shell
systemctl status protein-search-mgmt.service
```

Please reboot before continuing.