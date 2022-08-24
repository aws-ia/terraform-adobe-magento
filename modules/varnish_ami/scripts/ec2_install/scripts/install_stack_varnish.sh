#!/bin/bash
BASEDIR=/tmp/ec2_install
sudo cp -a $BASEDIR /opt/

grep -i debian /etc/os-release
if [ $? -eq 0 ]; then
  $BASEDIR/scripts/install_base_deb.sh
  $BASEDIR/scripts/install_nginx_deb.sh "$BASEDIR"
  $BASEDIR/scripts/install_varnish_deb.sh "$BASEDIR"
fi

grep -i amazon /etc/os-release
if [ $? -eq 0 ]; then
  $BASEDIR/scripts/install_base_amzn.sh
  $BASEDIR/scripts/install_nginx_amzn.sh "$BASEDIR"
  $BASEDIR/scripts/install_varnish_amzn.sh "$BASEDIR"
fi

echo "$(date -d "+1 hour" +"%M %H * * *") sudo shutdown -h" | crontab -