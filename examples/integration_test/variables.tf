#####################
# Project specifics #
#####################

variable "project" {
  type        = string
  description = "Name of the project."
  default     = "test-project"
}

variable "domain_name" {
  type        = string
  description = "Add domain name for the project. Creates a Route 53 DNS Zone."
  default     = false
}

variable "cert" {
  type    = string
  default = false
}

variable "profile" {
  type = string
}

variable "ssh_key_name" {
  type        = string
  description = "Name of the SSH-key stored in Secrets Manager"
  default     = "ssh-key-admin"
}

variable "ssh_key_pair_name" {
  type        = string
  description = "Generated key-pair name in the AWS console."
  default     = "admin"
}

variable "ssh_username" {
  type        = string
  description = "Default SSH username"
  default     = "admin"
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "create_vpc" {
  type = bool
}

variable "vpc_cidr" {
  type        = string
  default     = "10.0.0.0/16"
  description = "VPC CIDR"
}

variable "az1" {
  type    = string
  default = "us-east-1a"
}

variable "az2" {
  type    = string
  default = "us-east-1b"
}

variable "management_addresses" {
  description = "Whitelisted IP addresses for e.g. Security Groups"
  type        = list(string)
}

variable "mage_composer_username" {
  type        = string
  description = "Magento auth.json username"
}

variable "mage_composer_password" {
  type        = string
  description = "Magento auth.json password"
}

variable "magento_admin_firstname" {
  type        = string
  description = "Firstname for Magento admin."
  default     = "Admin"
}

variable "magento_admin_lastname" {
  type        = string
  description = "Lastname for Magento admin."
  default     = "Admin"
}

variable "magento_admin_username" {
  type        = string
  description = "Username for Magento admin."
  default     = "admin"
}

variable "magento_admin_password" {
  type        = string
  description = "Password for Magento admin."
  default     = "magentopass1234"
}

variable "magento_admin_email" {
  type        = string
  description = "Email address for Magento admin."
  default     = "someone@somewhere.com"
}

variable "magento_database_password" {
  type        = string
  description = "Password for Magento DB."
  default     = "magentopass1234"
}

variable "elasticsearch_domain" {
  type        = string
  description = "ElasticSearch domain"
  default     = "elasticsearch"
}

variable "rabbitmq_username" {
  type        = string
  description = "Username for RabbitMQ"
  default     = "rabbitmquser"
}

variable "base_ami_os" {
  description = "Amazon Linux 2 (amazon_linux_2) or Debian 10 (debian_10)"
  default     = "debian_10"
}

###
# Existing VPC
###
variable "vpc_id" {
  type    = string
  default = ""
}
variable "vpc_public_subnet_id" {
  type    = string
  default = ""
}

variable "vpc_public2_subnet_id" {
  type    = string
  default = ""
}

variable "vpc_private_subnet_id" {
  type    = string
  default = ""
}

variable "vpc_private2_subnet_id" {
  type    = string
  default = ""
}

variable "vpc_rds_subnet_id" {
  type    = string
  default = ""
}

variable "vpc_rds_subnet2_id" {
  type    = string
  default = ""
}
