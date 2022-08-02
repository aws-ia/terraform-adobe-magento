####################
# Project specific #
####################

variable "project" {
  type        = string
  description = "Name of the project."
  default     = "terraform-magento"
}

variable "domain_name" {
  type        = string
  description = "Add domain name for the project. Creates a Route 53 DNS Zone."
  default     = "your-domain-here.com"
}

####################
#  AWS Information #
####################

variable "profile" {
  type        = string
  description = "Profile to be used when connecting to AWS, usually stored in ~/.aws/credentials on local computer."
  default     = "default"
}

#######################
# EC2/SSH Information #
#######################
variable "ssh_key_name" {
  type        = string
  description = "Name of the SSH-key created for deployement and stored in Secrets Manager"
  default     = "ssh-key-admin"
}

variable "ssh_key_pair_name" {
  type        = string
  description = "Name of the generated key-pair created in the AWS console for this deployment."
  default     = "admin"
}

variable "ssh_username" {
  type        = string
  description = "Default SSH username, admin for Debian 10 instance ec2-user for Amazon Linux 2"
  default     = "admin"
}

variable "base_ami_os" {
  description = "Amazon Linux 2 (amazon_linux_2) or Debian 10 (debian_10)"
  default     = "debian_10"
}

######################
# AWS Region and AZs #
######################
variable "region" {
  type        = string
  description = "AWS Region that will be used for deployment. This should match the region that was used when setting up the Terraform Cloud workspace"
  default     = "us-east-1"
}

variable "az1" {
  type        = string
  description = "Availability Zone 2 used for deployment"
  default     = "us-east-1a"
}

variable "az2" {
  type        = string
  description = "Availability Zone 2 used for deployment"
  default     = "us-east-1b"
}

##############
# Networking #
##############
variable "create_vpc" {
  type        = bool
  description = "Create new VPC or use an existing. Valid choices are TRUE or FALSE. If you do not create a new VPC, you will be asked for VPC CIDR, VPC ID, VPC Public Subnet ID, VPC Public2 Subnet ID, VPC Private Subnet ID, VPC Private2 Subnet ID, VPC RDS Subnet ID, VPC RDS Subnet2 ID"
  default     = true
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR used for this deployment."
  default     = "10.0.0.0/16"
}

variable "management_addresses" {
  description = "Whitelisted IP addresses for access to the bastion host."
  type        = list(string)
  default     = ["10.0.0.0/32", ]
}

#######################
# Magento Information #
#######################
variable "mage_composer_username" {
  type        = string
  description = "Magento public authentication key for composer (previously generated on Adobe site)."
  default     = "magento_api_public_key"
}

variable "mage_composer_password" {
  type        = string
  description = "Magento private authentication key for composer (previously generated on Adobe Site)."
  default     = "magento_api_private_key"
}

variable "magento_admin_firstname" {
  type        = string
  description = "First name for Magento admin account."
  default     = "Admin"
}

variable "magento_admin_lastname" {
  type        = string
  description = "Last name for Magento admin account."
  default     = "Admin"
}

variable "magento_admin_username" {
  type        = string
  description = "Username for Magento admin account."
  default     = "admin"
}

variable "magento_admin_password" {
  type        = string
  description = "Password for Magento admin account. Must be 7 or more characters and include both letters and numbers."
  default     = "your_admin_password"
}

variable "magento_admin_email" {
  type        = string
  description = "Email address for Magento admin account."
  default     = "your_admin@email.com"
}

#############
# Database  #
#############
variable "use_aurora" {
  type        = bool
  description = "Use Aurora or RDS"
  default     = true
}

variable "magento_database_password" {
  type        = string
  description = "Password for Magento DB."
  default     = "your_db_password"
}

#################
# ElasticSearch #
#################
variable "elasticsearch_domain" {
  type        = string
  description = "ElasticSearch domain."
  default     = "elasticsearch"
}

############
# RabbitMQ #
############
variable "rabbitmq_username" {
  type        = string
  description = "Username for RabbitMQ."
  default     = "rabbitmquser"
}


####################################################
# Existing VPC                                     #
# Only set when create_vpc is set to "false" above #
####################################################
variable "vpc_id" {
  type        = string
  description = "VPC ID if deploying into an existing VPC"
  default     = ""
}
variable "vpc_public_subnet_id" {
  type        = string
  description = "ID of public subnet 1 in existing VPC"
  default     = ""
}

variable "vpc_public2_subnet_id" {
  type        = string
  description = "ID of public subnet 2 in existing VPC"
  default     = ""
}

variable "vpc_private_subnet_id" {
  type        = string
  description = "ID of private subnet 1 in existing VPC"
  default     = ""
}

variable "vpc_private2_subnet_id" {
  type        = string
  description = "ID of private subnet 2 in existing VPC"
  default     = ""
}

variable "vpc_rds_subnet_id" {
  type        = string
  description = "ID of private subnet 1 for RDS in existing VPC"
  default     = ""
}

variable "vpc_rds_subnet2_id" {
  type        = string
  description = "ID of private subnet 2 for RDS in existing VPC"
  default     = ""
}


###################
# AMI Certificate #
###################

variable "cert" {
  type        = string
  description = "ARN of Certificate for AMI"
  default     = false
}

