# These variables have no default values and must be supplied when
# consuming this module.

variable "project" {
  description = "Project identifier, used in e.g. S3 bucket naming"
  type = string
}

variable "create_vpc" {
  description = "To create a new VPC or not"
  type = bool
}

variable "vpc_cidr" {
  description = "VPC CIDR"
  type = string
}

variable "az1" {
  description = "Availability zone 1, used to place subnets etc"
  type = string
}

variable "az2" {
  description = "Availability zone 2, used to place subnets etc"
  type = string
}

variable "management_addresses" {
  description = "IP addresses for management traffic"
  type = list(string)
}

variable "base_ami_id" {
    type = string
    description = "Base AMI for EC2 instances."
}

variable "ec2_instance_type_bastion" {
  description = "EC2 instance type for bastion host"
  default = "t3.micro"
  type = string
}

variable "domain_name" {
  type = string
  description = "Add domain that is used e.g. bastion host connections."
}

variable "bastion_autoscale_min" {
  default = "1"
}
variable "bastion_autoscale_max" {
  default = "1"
}
variable "bastion_autoscale_desired" {
  default = "1"
}

################################################
#  Existing VPC Configurations                 #
#  Only applied if create_vpc is set to "true" #
################################################
variable "vpc_id" {
  type = string
  default = ""
}

variable "vpc_public_subnet_id" {
  type = string
  default = ""
}

variable "vpc_public2_subnet_id" {
  type = string
  default = ""
}

variable "vpc_private_subnet_id" {
  type = string
  default = ""
}

variable "vpc_private2_subnet_id" {
  type = string
  default = ""
}

variable "vpc_rds_subnet_id" {
  type = string
  default = ""
}

variable "vpc_rds_subnet2_id" {
  type = string
  default = ""
}

variable "ssh_key_pair_name" {
    type = string
    description = "Generated key-pair name in the AWS console."
}