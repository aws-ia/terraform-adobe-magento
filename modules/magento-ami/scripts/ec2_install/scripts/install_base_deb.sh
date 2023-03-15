#!/bin/bash
BASEDIR=$1

sudo adduser --disabled-password --gecos "" magento

sudo rm -rf ~magento/.bashrc
sudo rm -rf ~admin/.bashrc
sudo cp -a $BASEDIR/scripts/.bashrc ~magento/.bashrc
sudo cp -a $BASEDIR/scripts/.bashrc ~admin/.bashrc
sudo chown magento. ~magento/.bashrc
sudo chown admin. ~admin/.bashrc

sudo apt update

sudo apt install -y curl gnupg2 gnupg ca-certificates lsb-release debian-archive-keyring \
    apt-transport-https wget unzip lsof strace mariadb-client python3-venv python3-pip \
    git jq binutils telnet rsync libsasl2-modules