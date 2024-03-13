#!/bin/bash

set -x
set -e

rm -f install.sh

SOLUTION_VERSION=$(curl -s https://raw.githubusercontent.com/sb-ncbr/protein-similarity-parent-project/master/VERSION)
PROTEINS_VERSION=$(curl -s https://raw.githubusercontent.com/sb-ncbr/mics-proteins/main/VERSION)

wget -O install.sh https://github.com/sb-ncbr/protein-similarity-parent-project/releases/download/"$SOLUTION_VERSION"/install.sh

chmod u+x install.sh
./install.sh "$SOLUTION_VERSION" "$PROTEINS_VERSION"
