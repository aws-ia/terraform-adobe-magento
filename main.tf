terraform {
  required_version = ">= 1.0.0"
}

provider "aws" {
  region  = var.region
  profile = var.profile
}

# Create the basis for base module
module "account" {
  source = "./modules/account"
  project = var.project
  domain_name = var.domain_name
}

# Generate DB and RabbitMQ passwords
# Generate Magento encryption key
module "ssm" {
  source = "./modules/ssm"
  project = var.project
  magento_admin_firstname = var.magento_admin_firstname
  magento_admin_lastname = var.magento_admin_lastname
  magento_admin_email = var.magento_admin_email
  magento_admin_username = var.magento_admin_username
  magento_admin_password = var.magento_admin_password
  magento_database_password = var.magento_database_password
}

# Run base module which includes Networking and bastion hosts
module "base" {
  source = "./modules/base"

  create_vpc = var.create_vpc
  project = var.project
  vpc_cidr = var.vpc_cidr
  management_addresses = var.management_addresses 
  az1 = var.az1 
  az2 = var.az2 
  base_ami_id = data.aws_ami.selected.id
  domain_name = var.domain_name
  ssh_key_pair_name = var.ssh_key_pair_name

  ###
  # Existing VPC
  # Only applied if variable create_vpc is set to false
  ###
  vpc_id = var.vpc_id
  vpc_public_subnet_id = var.vpc_public_subnet_id
  vpc_public2_subnet_id = var.vpc_public2_subnet_id
  vpc_private_subnet_id = var.vpc_private_subnet_id
  vpc_private2_subnet_id = var.vpc_private2_subnet_id
  vpc_rds_subnet_id = var.vpc_rds_subnet_id
  vpc_rds_subnet2_id = var.vpc_rds_subnet2_id

  depends_on = [
    module.account
  ]
}

# Generate SSL certificate for your domain
module "acm" {
  source = "./modules/acm"
  domain_name = var.domain_name
  route53_zone_id = module.account.route53_zone_id

  depends_on = [
    module.base
  ]
}

# Create services: RabbitMQ, Redis, CloudFront and RDS
module "services" {
  source = "./modules/services"
  # Common
  az1 = var.az1
  az2 = var.az2
  project = var.project
  
  # Services
  skip_rds_snapshot_on_destroy = var.skip_rds_snapshot_on_destroy
  magento_db_allocated_storage = var.magento_db_allocated_storage
  magento_db_backup_retention_period = var.magento_db_backup_retention_period
  magento_db_performance_insights_enabled = var.magento_db_performance_insights_enabled
  rabbitmq_username = var.rabbitmq_username
  magento_database_password = var.magento_database_password
  elasticsearch_domain = var.elasticsearch_domain
  # SES
  magento_admin_email = var.magento_admin_email

  # Network
  vpc_id = module.base.vpc_id
  private_subnet_id = module.base.subnet_private_id
  private2_subnet_id = module.base.subnet_private2_id
  public_subnet_id = module.base.subnet_public_id
  public2_subnet_id = module.base.subnet_public2_id
  rds_subnet_id = module.base.rds_subnet_id
  rds_subnet2_id = module.base.rds_subnet2_id
  
  # Security
  sg_bastion_ssh_in_id = module.base.sg_bastion_ssh_in_id
  sg_allow_all_out_id = module.base.sg_allow_all_out_id
  sg_restricted_http_in_id = module.base.sg_restricted_http_in_id
  sg_restricted_https_in_id = module.base.sg_restricted_https_in_id
  sg_efs_private_in_id = module.base.sg_efs_private_in_id

  depends_on = [
    module.base
  ]
}

# Create Magento AMI
module "magento-ami" {
  source = "./modules/magento-ami"
  base_ami_id = data.aws_ami.selected.id
  ssh_key_name = var.ssh_key_name
  ssh_username = var.ssh_username
  mage_composer_username = var.mage_composer_username
  mage_composer_password = var.mage_composer_password
  vpc_id = module.base.vpc_id
  public_subnet_id = module.base.subnet_public_id
  management_addresses = var.management_addresses
  sg_allow_all_out_id = module.base.sg_allow_all_out_id
  ssh_key_pair_name = var.ssh_key_pair_name

  depends_on = [
    module.services
  ]
}

# Create Varnish AMI
module "varnish-ami" {
  source = "./modules/varnish-ami"
  base_ami_id = data.aws_ami.selected.id
  ssh_key_name = var.ssh_key_name
  ssh_username = var.ssh_username
  vpc_id = module.base.vpc_id
  public_subnet_id = module.base.subnet_public_id
  management_addresses = var.management_addresses
  sg_allow_all_out_id = module.base.sg_allow_all_out_id
  ssh_key_pair_name = var.ssh_key_pair_name

  depends_on = [
    module.services
  ]
}


# Create ALB/ASG, CloudFront and Magento EC2 instances
module "magento" {
  source = "./modules/magento"
  # Common
  project = var.project
  ssh_key_name = var.ssh_key_name
  ssh_username = var.ssh_username
  ssh_key_pair_name = var.ssh_key_pair_name
  # Network
  vpc_id = module.base.vpc_id
  private_subnet_id = module.base.subnet_private_id
  private2_subnet_id = module.base.subnet_private2_id
  public_subnet_id = module.base.subnet_public_id
  public2_subnet_id = module.base.subnet_public2_id
  vpc_cidr = var.vpc_cidr
  # Security
  sg_bastion_ssh_in_id = module.base.sg_bastion_ssh_in_id
  sg_allow_all_out_id = module.base.sg_allow_all_out_id
  sg_bastion_http_in_id = module.base.sg_bastion_http_in_id
  lb_access_logs_enabled = var.lb_access_logs_enabled

  external_lb_sg_ids = tolist(
    [
      module.base.sg_all_http_in_id,
      module.base.sg_all_https_in_id,
      module.base.sg_allow_all_out_id
    ]
  ) 

  # AMIs
  magento_ami = module.magento-ami.magento_ami_id
  varnish_ami = module.varnish-ami.varnish_ami_id
  cert_arn = var.cert
  nat_gateway_ip1 = module.base.nat_gateway_ip1
  nat_gateway_ip2 = module.base.nat_gateway_ip2
  
  depends_on = [
    module.magento-ami,
    module.varnish-ami
  ]
}
