#!/bin/bash -ex

MASTER=ubuntu@147.251.21.168 #todo to .env and share with other scripts
ssh -L 13306:localhost:3306 -T $MASTER &