#!/bin/bash
BASEDIR=$1

sudo amazon-linux-extras install -y epel
sudo yum install -y jemalloc-devel
sudo yum -y update

curl -s https://packagecloud.io/install/repositories/varnishcache/varnish65/script.rpm.sh | sudo bash

sudo yum -y install varnish
sudo systemctl enable varnish

sudo rm /etc/varnish/default.vcl
sudo mv $BASEDIR/configs/backends.vcl /etc/varnish/
sudo mv $BASEDIR/configs/default.vcl /etc/varnish/
sudo chown -R root. /etc/varnish/

sudo mkdir -p /etc/systemd/system/varnish.service.d/
sudo mv $BASEDIR/configs/varnish-overrides-amzn.conf /etc/systemd/system/varnish.service.d/overrides.conf
sudo systemctl daemon-reload

sudo systemctl restart varnish