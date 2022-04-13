####################
#  Region and AZs  #
####################
variable "az1" {
  description = "Availability zone 1, used to place subnets etc"
  default     = "us-east-1a"
  type        = string
}

variable "az2" {
  description = "Availability zone 2, used to place subnets etc"
  default     = "us-east-1b"
  type        = string
}

#################
# Common        #
#################
variable "project" {
  description = "Project identifier, used in e.g. S3 bucket naming"
  type        = string
}

#variable "route53_internal_zone_id" {
#  description = "Route53 internal zone's ID"
#  type = string
#}

####################
#  Networking      #
####################
variable "vpc_id" {
  type = string
}

variable "private_subnet_id" {
  type = string
}

variable "private2_subnet_id" {
  type = string
}

variable "public_subnet_id" {
  type = string
}

variable "public2_subnet_id" {
  type = string
}


variable "rds_subnet_id" {
  type = string
}

variable "rds_subnet2_id" {
  type = string
}

#variable "bastion_instance_id" {
#  type = list(string)
#}

####################
#  SecurityGroups  #
####################
variable "sg_bastion_ssh_in_id" {
  description = "Security group ID for SSH access from bastion host"
  type        = string
}

variable "sg_allow_all_out_id" {
  description = "Security group ID for allowing outbound connections"
  type        = string
}

variable "sg_restricted_http_in_id" {
  description = "Security group ID for allowing restricted HTTP connections"
  type        = string
}

variable "sg_restricted_https_in_id" {
  description = "Security group ID for allowing restricted HTTPS connections"
  type        = string
}

variable "sg_efs_private_in_id" {
  type = string
}

####################
#  RDS             #
####################
variable "skip_rds_snapshot_on_destroy" {
  description = "Skip the creation of a snapshot when db resource is destroyed?"
  default     = true
}

variable "magento_db_backup_retention_period" {
  type = string
}

variable "magento_db_allocated_storage" {
  type = string
}

variable "magento_db_performance_insights_enabled" {
  description = "Enable performace_insights for RDS DB"
  type        = bool
  default     = false
}

# Variables with default values. You do not have to set these, but you can.
variable "magento_db_name" {
  description = "RDS database name for Magento"
  type        = string
  default     = "magento"
}

variable "magento_db_username" {
  description = "RDS username for Magento DB"
  type        = string
  default     = "magento"
}

variable "magento_database_password" {
  description = "RDS username for Magento DB"
  type        = string
}

#######################
# Elasticache / Redis #
#######################
variable "redis_engine_version" {
  type        = string
  description = "Redis engine version"
  default     = "6.x"
}

#######################
# RabbitMQ            #
#######################
variable "mq_engine_version" {
  type    = string
  default = "3.8.22"
}

variable "rabbitmq_username" {
  description = "Username for RabbitMQ"
  type        = string
}

#######################
# ElasticSearch       #
#######################
variable "elasticsearch_domain" {
  type = string
}

variable "es_version" {
  default = "7.4"
  type    = string
}

variable "es_instance_type" {
  default = "m5.large.elasticsearch"
  type    = string
}

########
# SES  #
########
variable "magento_admin_email" {
  description = "Magento Admin email used for SES."
  type        = string
}

########################################################
# EC2 instance types used within the module            #
########################################################
variable "ec2_instance_type_redis_cache" {
  default = "cache.m5.large"
}

variable "ec2_instance_type_redis_session" {
  default = "cache.m5.large"
}

variable "ec2_instance_type_rds" {
  default = "db.r5.2xlarge"
}

variable "mq_instance_type" {
  default = "mq.m5.large"
}

variable "use_aurora" {
  type        = bool
  description = "Use Aurora or RDS"
  default     = true
}