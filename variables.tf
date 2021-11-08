#####################
# Project specifics #
#####################

variable "project" {
  type = string
  description = "Name of the project."
}

variable "domain_name" {
  type = string
  description = "Add domain name for the project."
  default = null
}

variable "cert" {
  type = string
  default = false
}

variable "profile" {
  type = string
}

variable "ssh_key_name" {
  type = string
}

variable "ssh_username" {
  type = string
}

variable "ssh_key_pair_name" {
  type = string
}

variable "magento_admin_firstname" {
  description = "Firstname for Magento admin."
}

variable "magento_admin_lastname" {
  description = "Lastname for Magento admin."
}

variable "magento_admin_username" {
  description = "Username for Magento admin."
}
variable "magento_admin_password" {
  description = "Password for Magento admin."
}

variable "magento_database_password" {
  description = "Password for Magento DB."
}

variable "magento_admin_email" {
  description = "Email address for Magento admin."
}

##############
#  Base AMI  #
##############
  locals {
  os_ami_queries = {
    debian_10 = {
      most_recent = true
      owners = ["136693071363"] # debian
      filters = {
        name = ["debian-11-amd64*"]
      }
    }
    amazon_linux_2 = {
      most_recent = true
      owners = ["amazon"]
      filters = {
        name = ["amzn2-ami-hvm-*-x86_64*"]
      }
    }
  }
  ami_query = local.os_ami_queries[var.base_ami_os]
}

data "aws_ami" "selected" {
  most_recent = true
  owners = local.ami_query.owners

  dynamic "filter" {
    for_each = local.ami_query.filters
    content {
      name   = filter.key
      values = filter.value
    }
  }
}

variable "base_ami_ids" {
  description = "Base AMI for bastion host and Magento EC2 instances. Amazon Linux 2 or Debian 10."
  type = map(string)
  default = {
    "amazon_linux_2" = "ami-02e136e904f3da870",
    "debian_10" = "ami-07d02ee1eeb0c996c"
  }
}

variable "base_ami_os" {
  type = string
}

#######
# AZs #
#######
variable "region" {
  type = string
  default = "us-east-1"
}

variable "az1" {
  type = string
  default = "us-east-1a"
}

variable "az2" {
  type = string
  default = "us-east-1b"
}


##########################################
#  Networking and External IP addresses  # 
##########################################
variable "create_vpc" {
  type = bool
}

variable "vpc_cidr" {
  type = string
  description = "VPC CIDR"
}

variable "management_addresses" {
  description = "Whitelisted IP addresses for e.g. Security Groups"
  type    = list(string)
}

variable "mage_composer_username" {
  type = string
  description = "Magento auth.json username"
}

variable "mage_composer_password" {
  type = string
  description = "Magento auth.json password"
}

##################
# Load Balancing #
##################

variable "lb_access_logs_enabled" {
  type = bool
  description = "Enable load balancer accesslogs to s3 bucket"
  default = false
}

##################
#  RDS Database  #
##################

variable "magento_db_backup_retention_period" {
  default = 3
}

variable "magento_db_allocated_storage" {
  default = 60
}

variable "skip_rds_snapshot_on_destroy" {
  type = bool
  description = "Take a final snapshot on RDS destroy?"
  default = false
}

variable "magento_db_performance_insights_enabled" {
  default = true
}

##################
#  ElasticSearch #
##################

variable "elasticsearch_domain" {
  type = string
  description = "ElasticSearch domain"
}

##################
#  RabbitMQ      #
##################

variable "rabbitmq_username" {
  type = string
  description = "Username for RabbitMQ"
}

################################################
#  Existing VPC Configurations                 #
#  Only applied if create_vpc is set to "true" #
################################################
variable "vpc_id" {
  type = string
}
variable "vpc_public_subnet_id" {
  type = string
}

variable "vpc_public2_subnet_id" {
  type = string
}

variable "vpc_private_subnet_id" {
  type = string
}

variable "vpc_private2_subnet_id" {
  type = string
}

variable "vpc_rds_subnet_id" {
  type = string
}

variable "vpc_rds_subnet2_id" {
  type = string
}