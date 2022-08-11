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
  type        = string
  description = "vpc_id"
}

variable "private_subnet_id" {
  type        = string
  description = "private_subnet_id"
}

variable "private2_subnet_id" {
  type        = string
  description = "private2_subnet_id"
}

variable "public_subnet_id" {
  type        = string
  description = "public_subnet_id"
}

variable "public2_subnet_id" {
  type        = string
  description = "public2_subnet_id"
}

variable "rds_subnet_id" {
  type        = string
  description = "rds_subnet_id"
}

variable "rds_subnet2_id" {
  type        = string
  description = "rds_subnet2_id"
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
  description = "Security group ID for allowing EFS"
  type        = string
}

####################
#  RDS             #
####################
variable "skip_rds_snapshot_on_destroy" {
  type        = bool
  description = "Skip the creation of a snapshot when db resource is destroyed?"
  default     = true
}

variable "magento_db_backup_retention_period" {
  description = "magento_db_backup_retention_period"
  type        = string
}

variable "magento_db_allocated_storage" {
  description = "magento_db_allocated_storage"
  type        = string
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
  description = "mq_engine_version"
  type        = string
  default     = "3.8.22"
}

variable "rabbitmq_username" {
  description = "Username for RabbitMQ"
  type        = string
}

#######################
# ElasticSearch       #
#######################
variable "elasticsearch_domain" {
  description = "elasticsearch_domain"
  type        = string
}

variable "es_version" {
  description = "es_version"
  default     = "7.4"
  type        = string
}

variable "es_instance_type" {
  description = "es instance type"
  default     = "m5.large.elasticsearch"
  type        = string
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
  description = "ec2_instance_type_redis_cache"
  type        = string
  default     = "cache.m5.large"
}

variable "ec2_instance_type_redis_session" {
  description = "ec2_instance_type_redis_session"
  type        = string
  default     = "cache.m5.large"
}

variable "ec2_instance_type_rds" {
  description = "ec2_instance_type_rds"
  type        = string
  default     = "db.r5.2xlarge"
}

variable "mq_instance_type" {
  description = "mq_instance_type"
  type        = string
  default     = "mq.m5.large"
}

variable "use_aurora" {
  type        = bool
  description = "Use Aurora or RDS"
  default     = true
}