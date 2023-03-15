#!/bin/bash

sudo adduser --comment "" magento

sudo yum -y update

sudo yum install -y curl gnupg2 gnupg ca-certificates  \
    wget unzip lsof strace python3-pip git jq binutils telnet rsync 