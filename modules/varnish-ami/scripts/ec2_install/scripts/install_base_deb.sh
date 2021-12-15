#!/bin/bash

sudo apt update

sudo apt install -y curl gnupg2 gnupg ca-certificates lsb-release debian-archive-keyring \
    apt-transport-https wget unzip lsof strace mariadb-client python3-venv python3-pip \
    git jq binutils telnet