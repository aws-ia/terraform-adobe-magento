#!/bin/bash
BASEDIR=$1

curl -L https://packagecloud.io/varnishcache/varnish65/gpgkey | sudo apt-key add -
echo "deb https://packagecloud.io/varnishcache/varnish65/debian/ $(lsb_release -cs) main" > /etc/apt/sources.list.d/varnishcache_varnish65.list
echo "deb-src https://packagecloud.io/varnishcache/varnish65/debian/ $(lsb_release -cs) main" >> /etc/apt/sources.list.d/varnishcache_varnish65.list

sudo apt update
sudo apt -y install varnish
sudo systemctl enable varnish

sudo rm /etc/varnish/default.vcl
sudo mv $BASEDIR/configs/backends.vcl /etc/varnish/
sudo mv $BASEDIR/configs/default.vcl /etc/varnish/
sudo chown -R root. /etc/varnish/

sudo mkdir -p /etc/systemd/system/varnish.service.d/
sudo mv $BASEDIR/configs/varnish-overrides.conf /etc/systemd/system/varnish.service.d/overrides.conf
sudo systemctl daemon-reload

sudo systemctl restart varnish