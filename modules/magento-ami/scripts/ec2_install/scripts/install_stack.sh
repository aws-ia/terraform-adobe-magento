#!/bin/bash
BASEDIR=/tmp/ec2_install
sudo cp -a $BASEDIR /opt/

grep -i debian /etc/os-release
if [ $? -eq 0 ]; then
  $BASEDIR/scripts/install_base_deb.sh "$BASEDIR"
  $BASEDIR/scripts/install_nginx_deb.sh "$BASEDIR"
  $BASEDIR/scripts/install_php_deb.sh "$BASEDIR"
  $BASEDIR/scripts/install_efshelper_deb.sh
fi

grep -i amazon /etc/os-release
if [ $? -eq 0 ]; then
  $BASEDIR/scripts/install_base_amzn.sh
  $BASEDIR/scripts/install_nginx_amzn.sh "$BASEDIR"
  $BASEDIR/scripts/install_php_amzn.sh "$BASEDIR"
fi

sudo pip3 install boto3
sudo pip3 install --upgrade awscli

$BASEDIR/scripts/install_composer.sh 

sudo $BASEDIR/scripts/install_postfix.sh

sudo $BASEDIR/scripts/install_efssetup.sh
sudo su - magento -c "$BASEDIR/scripts/install_magento.sh $BASEDIR"

echo "$(date -d "+1 hour" +"%M %H * * *") sudo shutdown -h" | crontab -