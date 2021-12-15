#!/bin/bash

cd /tmp || exit
git clone https://github.com/aws/efs-utils
cd efs-utils || exit
./build-deb.sh
sudo apt-get -y install ./build/amazon-efs-utils*deb
