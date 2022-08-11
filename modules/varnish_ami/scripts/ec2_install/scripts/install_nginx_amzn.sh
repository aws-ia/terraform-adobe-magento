#!/bin/bash
BASEDIR=$1

sudo useradd nginx

sudo amazon-linux-extras enable nginx1
sudo yum -y update
sudo yum -y install nginx
sudo systemctl enable nginx

sudo rm /etc/nginx/conf.d/default.conf
sudo mv $BASEDIR/configs/varnish.conf /etc/nginx/conf.d/
sudo mv $BASEDIR/configs/nginx.conf /etc/nginx/nginx.conf
sudo chown root. /etc/nginx/conf.d/varnish.conf

sudo usermod -aG varnish nginx

sudo systemctl restart nginx

