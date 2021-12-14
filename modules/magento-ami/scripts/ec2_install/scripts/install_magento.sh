#!/bin/bash
BASEDIR=$1

sudo mkdir -p /var/www/html/magento
sudo chown -R magento. /var/www/html
mkdir -p /home/magento/.config/composer/
sudo mv $BASEDIR/configs/auth.json /home/magento/.config/composer/
sudo chown -R magento. /home/magento/.config/
composer create-project --repository-url=https://repo.magento.com/ magento/project-community-edition /var/www/html/magento