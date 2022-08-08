#####################
# Project specifics #
#####################

variable "project" {
  type        = string
  description = "Name of the project."
}

variable "domain_name" {
  type        = string
  description = "Add domain name for the project."
  default     = null
}

variable "cert" {
  type        = string
  default     = false
  description = "TLS certificate"
}

variable "profile" {
  type        = string
  description = "AWS profile"
}

variable "ssh_key_name" {
  type        = string
  description = "SSH key name"
}

variable "ssh_username" {
  type        = string
  description = "SSH username"
}

variable "ssh_key_pair_name" {
  type        = string
  description = "SSH keypair name"
}

variable "magento_admin_firstname" {
  type        = string
  description = "Firstname for Magento admin."
}

variable "magento_admin_lastname" {
  type        = string
  description = "Lastname for Magento admin."
}

variable "magento_admin_username" {
  type        = string
  description = "Username for Magento admin."
}
variable "magento_admin_password" {
  type        = string
  description = "Password for Magento admin."
}

variable "magento_database_password" {
  type        = string
  description = "Password for Magento DB."
}

variable "magento_admin_email" {
  type        = string
  description = "Email address for Magento admin."
}

##############
#  Base AMI  #
##############
locals {
  os_ami_queries = {
    debian_10 = {
      most_recent = true
      owners      = ["136693071363"] # debian
      filters = {
        name = ["debian-11-amd64*"]
      }
    }
    amazon_linux_2 = {
      most_recent = true
      owners      = ["amazon"]
      filters = {
        name = ["amzn2-ami-hvm-*-x86_64*"]
      }
    }
  }
  ami_query = local.os_ami_queries[var.base_ami_os]
}

data "aws_ami" "selected" {
  most_recent = true
  owners      = local.ami_query.owners

  dynamic "filter" {
    for_each = local.ami_query.filters
    content {
      name   = filter.key
      values = filter.value
    }
  }
}

/*
variable "base_ami_ids" {
  description = "Base AMI for bastion host and Magento EC2 instances. Amazon Linux 2 or Debian 10."
  type        = map(string)
  default = {
    "amazon_linux_2" = "ami-02e136e904f3da870",
    "debian_10"      = "ami-07d02ee1eeb0c996c"
  }
}
*/

variable "base_ami_os" {
  type        = string
  description = "OS for base AMI"
}

#######
# AZs #
#######
variable "region" {
  type        = string
  default     = "us-east-1"
  description = "AWS region"
}

variable "az1" {
  type        = string
  default     = "us-east-1a"
  description = "AZ 1"
}

variable "az2" {
  type        = string
  default     = "us-east-1b"
  description = "AZ 2"
}


##########################################
#  Networking and External IP addresses  # 
##########################################
variable "create_vpc" {
  type        = bool
  description = "Create VPC or not"
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR"
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

##################
# Load Balancing #
##################

variable "lb_access_logs_enabled" {
  type        = bool
  description = "Enable load balancer accesslogs to s3 bucket"
  default     = false
}

##################
#  RDS Database  #
##################

variable "magento_db_backup_retention_period" {
  type        = number
  default     = 3
  description = "Backup retention period for DB"
}

variable "magento_db_allocated_storage" {
  type        = number
  default     = 60
  description = "DB allocated storage space"
}

variable "skip_rds_snapshot_on_destroy" {
  type        = bool
  description = "Take a final snapshot on RDS destroy?"
  default     = false
}

variable "magento_db_performance_insights_enabled" {
  type        = bool
  default     = true
  description = "DB performance insights"
}

##################
#  ElasticSearch #
##################

variable "elasticsearch_domain" {
  type        = string
  description = "ElasticSearch domain"
}

##################
#  RabbitMQ      #
##################

variable "rabbitmq_username" {
  type        = string
  description = "Username for RabbitMQ"
}

################################################
#  Existing VPC Configurations                 #
#  Only applied if create_vpc is set to "true" #
################################################
variable "vpc_id" {
  type        = string
  description = "VPC ID"
}
variable "vpc_public_subnet_id" {
  type        = string
  description = "VPC public subnet 1"
}

variable "vpc_public2_subnet_id" {
  type        = string
  description = "VPC public subnet 1"
}

variable "vpc_private_subnet_id" {
  type        = string
  description = "VPC private subnet 1"
}

variable "vpc_private2_subnet_id" {
  type        = string
  description = "VPC private subnet 1"
}

variable "vpc_rds_subnet_id" {
  type        = string
  description = "RDS private subnet 1"
}

variable "vpc_rds_subnet2_id" {
  type        = string
  description = "RDS private subnet 2"
}

variable "use_aurora" {
  type        = bool
  description = "Use Aurora or RDS"
  default     = true
}