#!/bin/bash

rm -rf dependencies
wget -O install.sh https://github.com/JakubOrsula/protein-similarity-parent-project/releases/download/2.09/install.sh
chmod +x install.sh
echo "Install script updated. Run it with versions of your choosing."