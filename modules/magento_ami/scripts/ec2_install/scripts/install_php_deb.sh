#!/bin/bash
BASEDIR=$1

PHPVER="8.1"
PHPEXT="bcmath,bz2,curl,dba,enchant,fileinfo,gd,gmp,iconv,igbinary,imagick,imap,intl,mbstring,memcached,mysql,odbc,pgsql,pspell,redis,simplexml,soap,tidy,xsl,zip"

sudo wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/php.list

sudo apt update
sudo apt -y install "php${PHPVER}-fpm" "php${PHPVER}"
eval sudo apt -y install "php${PHPVER}-{$PHPEXT}"

sudo mv $BASEDIR/configs/www.conf "/etc/php/${PHPVER}/fpm/pool.d/www.conf"

sudo systemctl enable "php${PHPVER}-fpm"
sudo systemctl restart "php${PHPVER}-fpm"

