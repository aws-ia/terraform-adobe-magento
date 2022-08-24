#!/bin/bash
BASEDIR=$1

sudo useradd nginx

curl -s https://nginx.org/keys/nginx_signing.key | gpg --dearmor \
    | sudo tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null

gpg --dry-run --quiet --import --import-options import-show /usr/share/keyrings/nginx-archive-keyring.gpg

echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
    http://nginx.org/packages/debian $(lsb_release -cs) nginx" \
        | sudo tee /etc/apt/sources.list.d/nginx.list

echo -e "Package: *\nPin: origin nginx.org\nPin: release o=nginx\nPin-Priority: 900\n" \
    | sudo tee /etc/apt/preferences.d/99nginx

sudo apt update
sudo apt -y install nginx
sudo systemctl enable nginx

sudo rm /etc/nginx/conf.d/default.conf
sudo mv $BASEDIR/configs/varnish.conf /etc/nginx/conf.d/
sudo mv $BASEDIR/configs/nginx.conf /etc/nginx/nginx.conf
sudo chown root. /etc/nginx/conf.d/varnish.conf

sudo usermod -aG varnish nginx

#sudo systemctl restart nginx

