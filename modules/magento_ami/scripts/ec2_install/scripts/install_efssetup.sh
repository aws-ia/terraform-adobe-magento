#!/bin/bash

EFS_REGION=$(curl --silent http://169.254.169.254/latest/dynamic/instance-identity/document | jq .region -r)

sudo mkdir -p /mnt/efs

EFS_MOUNT_POINT="/mnt/efs"
EFS_FILE_SYSTEM_ID=$(aws ssm get-parameter --name "magento_efs_id" --region ${EFS_REGION} | jq -r .Parameter.Value)

sudo test -f "sudo /sbin/mount.efs" && sudo bash -c 'echo '"${EFS_FILE_SYSTEM_ID}:/ ${EFS_MOUNT_POINT} efs defaults,_netdev"' >> /etc/fstab' || sudo bash -c 'echo '"${EFS_FILE_SYSTEM_ID}.efs.${EFS_REGION}.amazonaws.com:/ ${EFS_MOUNT_POINT} nfs4 nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport,_netdev 0 0"' >> /etc/fstab'