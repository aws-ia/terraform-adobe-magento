#!/bin/bash

FILE=./terraform.auto.tfvars

vpc_vars() {
    read -rp "VPC cidr: " VPCCIDR
    read -rp "VPC id: " VPCID
    read -rp "VPC public_subnet_id: " VPCPUBSUBNET
    read -rp "VPC public2_subnet_id: " VPCPUB2SUBNET
    read -rp "VPC private_subnet_id: " VPCPRISUBNET
    read -rp "VPC private2_subnet_id: " VPCPRI2SUBNET
    read -rp "VPC rds_subnet_id: " VPCRDSSUB
    read -rp "VPC rds_subnet2_id: "  VPCRDSSUB2
}

save_vpc_vars() {
    sed -i".TMP" "s/create_vpc\ \=\ true/create_vpc\ \=\ false/g" $FILE
    rm "$FILE.TMP"
    cat >> $FILE << EOF
vpc_cidr = "$VPCCIDR"
vpc_id = "$VPCID"
vpc_public_subnet_id = "$VPCPUBSUBNET"
vpc_public2_subnet_id = "$VPCPUB2SUBNET"
vpc_private_subnet_id = "$VPCPRISUBNET"
vpc_private2_subnet_id = "$VPCPRI2SUBNET"
vpc_rds_subnet_id = "$VPCRDSSUB"
vpc_rds_subnet2_id = "$VPCRDSSUB2"
EOF
}

getvars() {
    read -rp "AWS Profile: " PROFILE
    read -rp "Project Name: " PROJECT
    read -rp "Domain: " DOMAIN
    read -rp "Region: " REGION
    read -rp "AZ 1: " AZ1
    read -rp "AZ 2: " AZ2
    while true; do
        read -rp "Create a new VPC [Yn]: " CREATEVPC
        case $CREATEVPC in
            [Yy]* ) break;;
            [Nn]* ) vpc_vars;;
            * ) echo "Please answer yes or no.";;
        esac
        if [ ! -z ${CREATEVPC+x} ]; then break ; fi
    done
    read -rp "Key pair name in AWS: " KEYPAIR
    read -rp "Composer User: " COMPOSERUSER
    read -srp "Composer Pass: " COMPOSERPASS
    echo ""
    SSHUSERNAME="admin"
    read -rp "Base AMI image to use, debian_10 or amazon_linux_2: " BASEIMAGE
    if [[ $BASEIMAGE == "amazon_linux_2" ]];
    then
        SSHUSERNAME="ec2-user"
    fi
    read -rp "Magento Admin Firstname: " ADMINFIRSTNAME
    read -rp "Magento Admin Lastname: " ADMINLASTNAME
    read -rp "Magento Admin Email: " ADMINEMAIL
    read -rp "Magento Admin Username: " ADMINUSERNAME
    read -srp "Magento Admin Password: " ADMINPASS
    while : ; do
        if [[ $ADMINPASS == *[[:digit:]]* ]] && [[ $ADMINPASS == *[[:alpha:]]* ]] && [[ ${#ADMINPASS} -gt 7 ]]
        then
            break
        else
            echo ""
            read -srp "Password must be seven or more characters long and include both letters and numbers: " ADMINPASS
        fi
    done
    echo ""
    read -srp "Database Password: " DBPASS
    while : ; do
        if [[ ${#DBPASS} -lt 8 ]] || [[ ${#DBPASS} -gt 32 ]] || [[ $DBPASS == *\/* ]] || [[ $DBPASS == *\"* ]] || [[ $DBPASS == *\@* ]]
        then
            echo ""
            read -srp "Password must 8-32 character string and not include /, \", or @" DBPASS
        else
            break
        fi
    done
    echo ""
    read -rp "IP to whitelist: " WHITELISTIP

    cat > $FILE << EOF
profile = "$PROFILE"
project = "$PROJECT"
domain_name = "$DOMAIN"

region = "$REGION"
az1 = "$AZ1"
az2 = "$AZ2"

create_vpc = true

base_ami_os = "$BASEIMAGE"
ssh_key_pair_name = "$KEYPAIR"
ssh_username = "$SSHUSERNAME"

# Magento composer credentials
mage_composer_username = "$COMPOSERUSER"
mage_composer_password = "$COMPOSERPASS"

magento_admin_email = "$ADMINEMAIL"
magento_admin_firstname = "$ADMINFIRSTNAME"
magento_admin_lastname = "$ADMINLASTNAME"
magento_admin_username = "$ADMINUSERNAME"
magento_admin_password = "$ADMINPASS"

magento_database_password = "$DBPASS"

# Whitelisted IP addresses
management_addresses = [
    "$WHITELISTIP/32",
]
EOF

case $CREATEVPC in
    [Nn]* ) save_vpc_vars;;
esac
}

if [ -f "$FILE" ]; then
    read -rp "$FILE exists, overwrite? [yn]" yn
    case $yn in
        [Yy]* ) getvars;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
else 
    getvars  
fi
