#!/bin/bash
BASEDIR=/opt/ec2_install

REGION=$(curl --silent http://169.254.169.254/latest/dynamic/instance-identity/document | jq .region -r)
export REGION

PRIVATEIPFILE="/home/magento/privateip"
curl --silent http://169.254.169.254/latest/dynamic/instance-identity/document | jq -r .privateIp > $PRIVATEIPFILE

# Temporary file to store key - value data
VARIABLE_TEMP_FILE="/tmp/discovered-vars"

sudo chmod +x $BASEDIR/scripts/magento_vars.py
/usr/bin/python3 $BASEDIR/scripts/magento_vars.py > ${VARIABLE_TEMP_FILE}

sudo cp -a $VARIABLE_TEMP_FILE /opt/

sudo -u magento sh -c 'ssh-keygen -t rsa -q -f "$HOME/.ssh/id_rsa" -N ""'
sudo cp ~admin/.ssh/authorized_keys ~magento/.ssh/
sudo chown magento. ~magento/.ssh/authorized_keys
sudo chmod 600 ~magento/.ssh/authorized_keys

MAGENTO_DB_HOST=$(grep 'magento_database_host:' ${VARIABLE_TEMP_FILE} | tail -n1 | awk '{ print $2}')
MAGENTO_DB_PASS=$(grep 'magento_database_password:' ${VARIABLE_TEMP_FILE} | tail -n1 | awk '{ print $2}')
MAGENTO_REDIS_CACHE_HOST=$(grep 'magento_cache_host:' ${VARIABLE_TEMP_FILE} | tail -n1 | awk '{ print $2}')
MAGENTO_REDIS_SESSION_HOST=$(grep 'magento_session_host:' ${VARIABLE_TEMP_FILE} | tail -n1 | awk '{ print $2}')
MAGENTO_ES_HOST=$(grep 'magento_elasticsearch_host:' ${VARIABLE_TEMP_FILE} | tail -n1 | awk '{ print $2}')
MAGENTO_MQ_HOST=$(grep 'magento_rabbitmq_host:' ${VARIABLE_TEMP_FILE} | tail -n1 | awk '{ print $2}')
MAGENTO_MQ_USER=$(grep 'magento_rabbitmq_username:' ${VARIABLE_TEMP_FILE} | tail -n1 | awk '{ print $2}')
MAGENTO_MQ_PASS=$(grep 'rabbitmq_password:' ${VARIABLE_TEMP_FILE} | tail -n1 | awk '{ print $2}')
MAGENTO_VARNISH_HOST=$(hostname --all-ip-addresses | awk '{$1=$1;print}')
BASE_DOMAIN=$(grep 'cloudfront_domain:' /tmp/discovered-vars | tail -n1 | awk '{ print $2}')
MAGENTO_CRYPT_KEY=$(grep 'magento_crypt_key:' ${VARIABLE_TEMP_FILE} | tail -n1 | awk '{ print $2}')
MAGENTO_FILES_S3=$(grep 'magento_files_s3:' ${VARIABLE_TEMP_FILE} | tail -n1 | awk '{ print $2}')
MAGENTO_CRYPT_KEY=$(grep 'magento_crypt_key:' ${VARIABLE_TEMP_FILE} | tail -n1 | awk '{ print $2}')
MAGENTO_EFS_ID=$(grep 'magento_efs_id:' ${VARIABLE_TEMP_FILE} | tail -n1 | awk '{ print $2}')
MAGENTO_ADMIN_EMAIL=$(grep 'magento_admin_email:' ${VARIABLE_TEMP_FILE} | tail -n1 | awk '{ print $2}')
MAGENTO_ADMIN_USERNAME=$(grep 'magento_admin_username:' ${VARIABLE_TEMP_FILE} | tail -n1 | awk '{ print $2}')
MAGENTO_ADMIN_PASS=$(grep 'magento_admin_password:' ${VARIABLE_TEMP_FILE} | tail -n1 | awk '{ print $2}')
MAGENTO_ADMIN_FIRSTNAME=$(grep 'magento_admin_firstname:' ${VARIABLE_TEMP_FILE} | tail -n1 | awk '{ print $2}')
MAGENTO_ADMIN_LASTNAME=$(grep 'magento_admin_lastname:' ${VARIABLE_TEMP_FILE} | tail -n1 | awk '{ print $2}')

MAGENTO_BUCKET=$(echo $MAGENTO_FILES_S3 | cut -d. -f1)

sudo sed -i "s/AWS_BUCKET/$MAGENTO_FILES_S3/g" /etc/nginx/conf.d/magento.conf
sudo systemctl restart nginx

if [ ! -d "/mnt/efs/magento" ]
then
    sudo mkdir -p /mnt/efs/magento
    sudo chown magento. /mnt/efs
    sudo chown magento. /mnt/efs/magento
    sudo -u magento mkdir -p /mnt/efs/magento/pub
    sudo -u magento mkdir -p /mnt/efs/magento/app/etc
    sudo -u magento mv /var/www/html/magento/app/etc/env.php /mnt/efs/magento/app/etc/
    sudo -u magento mv /var/www/html/magento/app/etc/config.php /mnt/efs/magento/app/etc/
    sudo -u magento mv /var/www/html/magento/pub/static /mnt/efs/magento/pub/
    sudo -u magento mv /var/www/html/magento/var /mnt/efs/magento/  
fi

if [ ! -L "/var/www/html/magento/app/etc/env.php" ]
then
    cd /var/www/html/magento/app/etc || exit
    sudo -u magento ln -s /mnt/efs/magento/app/etc/env.php
fi

if [ ! -L "/var/www/html/magento/app/etc/config.php" ]
then
    cd /var/www/html/magento/app/etc || exit
    sudo -u magento ln -s /mnt/efs/magento/app/etc/config.php
fi

if [ ! -L "/var/www/html/magento/var" ]
then
    cd /var/www/html/magento || exit
    rm -rf ./var/ && sudo -u magento ln -s /mnt/efs/magento/var
fi

if [ ! -L "/var/www/html/magento/pub/static" ]
then
    cd /var/www/html/magento/pub || exit
    rm -rf ./static/ && sudo -u magento ln -s /mnt/efs/magento/pub/static
fi

if [ ! -f "/mnt/efs/magento/app/etc/env.php" ]
then
    sudo -u magento php -d memory_limit=-1 /var/www/html/magento/bin/magento setup:install \
        --backend-frontname=admin \
        --db-host=${MAGENTO_DB_HOST} \
        --db-name=magento \
        --db-user=magento \
        --db-password=${MAGENTO_DB_PASS} \
        --search-engine=elasticsearch7 \
        --elasticsearch-host=https://${MAGENTO_ES_HOST} \
        --elasticsearch-port=443 \
        --elasticsearch-index-prefix=magento2 \
        --elasticsearch-enable-auth=0 \
        --elasticsearch-timeout=15 \
        --http-cache-hosts=${MAGENTO_VARNISH_HOST}:80 \
        --session-save=redis \
        --session-save-redis-host=${MAGENTO_REDIS_SESSION_HOST} \
        --session-save-redis-port=6379 \
        --session-save-redis-db=0 \
        --session-save-redis-max-concurrency=20 \
        --cache-backend=redis \
        --cache-backend-redis-server=${MAGENTO_REDIS_CACHE_HOST} \
        --cache-backend-redis-db=0 \
        --cache-backend-redis-port=6379 \
        --amqp-host=${MAGENTO_MQ_HOST} \
        --amqp-port=5671 \
        --amqp-user=${MAGENTO_MQ_USER} \
        --amqp-password=${MAGENTO_MQ_PASS} \
        --amqp-ssl=true \
        --base-url=https://${BASE_DOMAIN}/ \
        --base-url-secure=https://${BASE_DOMAIN}/ \
        --use-rewrites=1 \
        --use-secure=1 \
        --use-secure-admin=1 \
        --key=${MAGENTO_CRYPT_KEY} \
        --admin-firstname=${MAGENTO_ADMIN_FIRSTNAME} \
        --admin-lastname=${MAGENTO_ADMIN_LASTNAME} \
        --admin-email=${MAGENTO_ADMIN_EMAIL} \
        --admin-user=${MAGENTO_ADMIN_USERNAME} \
        --admin-password=${MAGENTO_ADMIN_PASS} \
        --cleanup-database | tee /tmp/magento.install.log

    sudo -u magento php -d memory_limit=-1 /var/www/html/magento/bin/magento deploy:mode:set developer
    sudo -u magento cp -a /opt/ec2_install/configs/auth.json /var/www/html/magento/
    sudo -u magento php -d memory_limit=-1 /var/www/html/magento/bin/magento module:disable Magento_AdminNotification
    sudo -u magento php -d memory_limit=-1 /var/www/html/magento/bin/magento sampledata:deploy
    sudo -u magento php -d memory_limit=-1 /var/www/html/magento/bin/magento setup:upgrade
    sudo -u magento php -d memory_limit=-1 /var/www/html/magento/bin/magento deploy:mode:set production

    sudo -u magento php -d memory_limit=-1 /var/www/html/magento/bin/magento maintenance:enable

    sudo -u magento php -d memory_limit=-1 /var/www/html/magento/bin/magento config:set web/secure/offloader_header X-Forwarded-Proto
    sudo -u magento php -d memory_limit=-1 /var/www/html/magento/bin/magento config:set --scope=default --scope-code=0 system/full_page_cache/caching_application 2
    sudo -u magento php -d memory_limit=-1 /var/www/html/magento/bin/magento config:set trans_email/ident_general/email ${MAGENTO_ADMIN_EMAIL}

    sudo -u magento php -d memory_limit=-1 /var/www/html/magento/bin/magento config:set system/media_storage_configuration/media_database 0

    sudo -u magento php -d memory_limit=-1 /var/www/html/magento/bin/magento setup:config:set --remote-storage-driver="aws-s3" \
        --remote-storage-bucket="${MAGENTO_FILES_S3}" \
        --remote-storage-region="${REGION}"
    sudo -u magento php -d memory_limit=-1 /var/www/html/magento/bin/magento remote-storage:sync

    sudo -u magento php -d memory_limit=-1 /var/www/html/magento/bin/magento maintenance:disable
    
    sudo aws s3 cp /home/magento/.ssh/id_rsa.pub s3://${MAGENTO_BUCKET}/sync/master.pub
    sudo aws s3 cp $PRIVATEIPFILE s3://${MAGENTO_BUCKET}/sync/

    sudo -u magento php -d memory_limit=-1 /var/www/html/magento/bin/magento cron:install

    sudo cp /opt/ec2_install/scripts/sync.sh /home/magento/sync.sh
    sudo chown magento. /home/magento/sync.sh
    sudo -u magento crontab -l > /tmp/tmpcron
    sudo -u magento echo "*/2 * * * * /bin/bash /home/magento/sync.sh" | sudo -u magento tee -a /tmp/tmpcron
    sudo -u magento crontab /tmp/tmpcron
else
    sudo -u magento aws s3 cp s3://${MAGENTO_BUCKET}/sync/master.pub /home/magento/master.pub
    sudo -u magento cat /home/magento/master.pub >> /home/magento/.ssh/authorized_keys
    sudo chmod 600 /home/magento/.ssh/authorized_keys
    sudo chown magento. /home/magento/.ssh/authorized_keys
fi

sudo -u magento php -d memory_limit=-1 /var/www/html/magento/bin/magento cache:flush

echo flushall >/dev/tcp/${MAGENTO_REDIS_CACHE_HOST}/6379

sudo rm /etc/sudoers.d/91-magento

### set permissions per https://devdocs.magento.com/guides/v2.4/config-guide/prod/prod_file-sys-perms.html
cd /var/www/html/magento
find app/code var/view_preprocessed vendor pub/static app/etc generated/code generated/metadata \( -type f -or -type d \) -exec chmod u-w {} + && chmod o-rwx app/etc/env.php
chmod u+x bin/magento
chmod -R u+w .