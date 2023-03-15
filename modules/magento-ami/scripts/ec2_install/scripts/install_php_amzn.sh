#!/bin/bash
BASEDIR=$1

PHPVER="81"
PHPEXT="bcmath,bz2,curl,dba,enchant,fileinfo,gd,gmp,iconv,igbinary,imagick,imap,intl,mbstring,memcached,mysql,odbc,pgsql,pspell,redis,simplexml,soap,tidy,xsl,zip"

sudo printf "[main]\nenabled = 0\n" | sudo tee /etc/yum/pluginconf.d/priorities.conf

sudo yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo yum install -y https://rpms.remirepo.net/enterprise/remi-release-7.rpm
sudo yum-config-manager --setopt="remi-php${PHPVER}.priority=5" --enable remi-php${PHPVER}

sudo yum update -y

sudo yum -y install php-fpm php
eval sudo yum -y install "php-{$PHPEXT}"

sudo mv $BASEDIR/configs/www.conf "/etc/php-fpm.d/www.conf"
sudo sed -i 's/\/run\/php\/php8.1-fpm.sock/\/var\/run\/php8.1-fpm.sock/g' /etc/php-fpm.d/www.conf

sudo systemctl enable "php-fpm"
sudo systemctl restart "php-fpm"
