#!/bin/bash
BASEDIR=$1

REGION=$(curl --silent http://169.254.169.254/latest/dynamic/instance-identity/document | jq .region -r)

sudo amazon-linux-extras enable nginx1
sudo yum -y update
sudo yum -y install nginx
sudo systemctl enable nginx

sudo mv $BASEDIR/configs/magento.conf /etc/nginx/conf.d/
sudo chown root. /etc/nginx/conf.d/magento.conf
sudo sed -i 's/\/var\/run\/php\/php8.1-fpm.sock/\/var\/run\/php8.1-fpm.sock/g' /etc/nginx/conf.d/magento.conf
sudo sed -i "s/REGION/$REGION/g" /etc/nginx/conf.d/magento.conf

sudo usermod -aG magento nginx

sudo systemctl restart nginx

