#!/bin/bash
REGION=$(curl --silent http://169.254.169.254/latest/dynamic/instance-identity/document | jq .region -r)

if ! pgrep -x "rsync" > /dev/null
then
  for i in $(aws --region="$REGION" ec2 describe-instances --filters Name=tag-key,Values='aws:autoscaling:groupName' Name=tag-value,Values=magento-web-*  --output text --query 'Reservations[*].Instances[*].[InstanceId,PrivateIpAddress]' | grep -v $(cat /home/magento/privateip) | grep -v None | awk '{print $2}');
  do
    rsync -e "ssh -o ConnectTimeout=2 -o ConnectionAttempts=1 -o StrictHostKeyChecking=no" --update -raz --progress /var/www/html/magento/ magento@$i:/var/www/html/magento
  done
fi