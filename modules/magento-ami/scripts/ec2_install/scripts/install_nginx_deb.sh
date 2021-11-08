#!/bin/bash
BASEDIR=$1

REGION=$(curl --silent http://169.254.169.254/latest/dynamic/instance-identity/document | jq .region -r)

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
sudo mv $BASEDIR/configs/magento.conf /etc/nginx/conf.d/
sudo chown root. /etc/nginx/conf.d/magento.conf
sudo sed -i "s/REGION/$REGION/g" /etc/nginx/conf.d/magento.conf

sudo usermod -aG magento nginx

sudo systemctl restart nginx

