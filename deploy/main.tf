# Magento Quickstart
module "magento" {
  source                    = "../"
  region                    = var.region
  create_vpc                = var.create_vpc
  az1                       = var.az1
  az2                       = var.az2
  profile                   = var.profile
  project                   = var.project
  base_ami_os               = var.base_ami_os
  domain_name               = var.domain_name
  ssh_key_name              = var.ssh_key_name
  ssh_key_pair_name         = var.ssh_key_pair_name
  ssh_username              = var.ssh_username
  mage_composer_username    = var.mage_composer_username
  mage_composer_password    = var.mage_composer_password
  magento_admin_firstname   = var.magento_admin_firstname
  magento_admin_lastname    = var.magento_admin_lastname
  magento_admin_username    = var.magento_admin_username
  magento_admin_password    = var.magento_admin_password
  magento_admin_email       = var.magento_admin_email
  magento_database_password = var.magento_database_password
  cert                      = var.cert
  elasticsearch_domain      = var.elasticsearch_domain
  rabbitmq_username         = var.rabbitmq_username
  management_addresses      = var.management_addresses
  use_aurora                = var.use_aurora

  vpc_cidr = var.vpc_cidr
  ###
  # Existing VPC
  # Only applied if variable create_vpc is set to false
  ###
  vpc_id                 = var.vpc_id
  vpc_public_subnet_id   = var.vpc_public_subnet_id
  vpc_public2_subnet_id  = var.vpc_public2_subnet_id
  vpc_private_subnet_id  = var.vpc_private_subnet_id
  vpc_private2_subnet_id = var.vpc_private2_subnet_id
  vpc_rds_subnet_id      = var.vpc_rds_subnet_id
  vpc_rds_subnet2_id     = var.vpc_rds_subnet2_id

}
