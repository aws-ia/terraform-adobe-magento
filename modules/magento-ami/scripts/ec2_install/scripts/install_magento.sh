#!/bin/bash
BASEDIR=$1

sudo mkdir -p /var/www/html/magento
sudo chown -R magento. /var/www/html
mkdir -p /home/magento/.config/composer/
sudo mv $BASEDIR/configs/auth.json /home/magento/.config/composer/
sudo chown -R magento. /home/magento/.config/
cd /home/magento
sudo -u magento composer create-project --repository-url=https://repo.magento.com/ magento/project-community-edition=2.4.5-p2 /var/www/html/magento -n
cd /var/www/html/magento
sudo -u magento composer require customerparadigm/amazon-personalize-extension:"^1.0"
sudo -u magento composer require imaginationmedia/aws-fraud-magento2