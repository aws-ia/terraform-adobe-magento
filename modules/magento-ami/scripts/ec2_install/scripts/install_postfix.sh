#!/bin/bash
BASEDIR=/opt/ec2_install

REGION=$(curl --silent http://169.254.169.254/latest/dynamic/instance-identity/document | jq .region -r)
export REGION

# Temporary file to store key - value data
VARIABLE_TEMP_FILE="/tmp/discovered-vars-postfix"

sudo chmod +x $BASEDIR/scripts/magento_vars.py
/usr/bin/python3 $BASEDIR/scripts/magento_vars.py > ${VARIABLE_TEMP_FILE}

SMTPUSERNAME=$(grep 'smtp_user:' ${VARIABLE_TEMP_FILE} | tail -n1 | awk '{ print $2}')
SMTPPASSWORD=$(grep 'smtp_pass:' ${VARIABLE_TEMP_FILE} | tail -n1 | awk '{ print $2}')

grep -i debian /etc/os-release
if [ $? -eq 0 ]; then
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y postfix
fi

grep -i amazon /etc/os-release
if [ $? -eq 0 ]; then
sudo yum install -y postfix
sudo systemctl enable postfix
sudo systemctl start postfix
fi

sudo postconf -e "relayhost = [email-smtp.$REGION.amazonaws.com]:587" \
"smtp_sasl_auth_enable = yes" \
"smtp_sasl_security_options = noanonymous" \
"smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd" \
"smtp_use_tls = yes" \
"smtp_tls_security_level = encrypt" \
"smtp_tls_note_starttls_offer = yes"

sudo sed -e '/-o smtp_fallback_relay=/ s/^#*/#/' -i /etc/postfix/master.cf

sudo touch /etc/postfix/sasl_passwd
echo "[email-smtp.$REGION.amazonaws.com]:587 $SMTPUSERNAME:$SMTPPASSWORD" | sudo tee /etc/postfix/sasl_passwd

sudo postmap hash:/etc/postfix/sasl_passwd
sudo chown root:root /etc/postfix/sasl_passwd /etc/postfix/sasl_passwd.db
sudo chmod 0600 /etc/postfix/sasl_passwd /etc/postfix/sasl_passwd.db

grep -i debian /etc/os-release
if [ $? -eq 0 ]; then
sudo postconf -e 'smtp_tls_CAfile = /etc/ssl/certs/ca-certificates.crt'
fi

grep -i amazon /etc/os-release
if [ $? -eq 0 ]; then
sudo postconf -e 'smtp_tls_CAfile = /etc/ssl/certs/ca-bundle.crt'
fi

sudo postfix reload
