#################
# Common        #
#################
variable "magento_ami" {
  type        = string
  description = "magento_ami"
}

variable "varnish_ami" {
  type        = string
  description = "varnish_ami"
}

variable "project" {
  description = "Project identifier, used in e.g. S3 bucket naming"
  type        = string
}

variable "cert_arn" {
  type        = string
  description = "cert_arn"
}

variable "ssh_key_name" {
  type        = string
  description = "Admin SSH key name stored in secrets manager."
}

variable "ssh_username" {
  type        = string
  description = "Admin SSH username."
}

variable "ssh_key_pair_name" {
  type        = string
  description = "Generated key-pair name in the AWS console."
}

####################
#  Networking      #
####################
variable "vpc_id" {
  type        = string
  description = "vpc_id"
}

variable "vpc_cidr" {
  type        = string
  description = "vpc_cidr"
}

variable "public_subnet_id" {
  type        = string
  description = "public_subnet_id"
}

variable "private_subnet_id" {
  type        = string
  description = "private_subnet_id"
}

variable "public2_subnet_id" {
  type        = string
  description = "public2_subnet_id"
}

variable "private2_subnet_id" {
  type        = string
  description = "private2_subnet_id"
}

variable "nat_gateway_ip1" {
  type        = string
  description = "nat_gateway_ip1"
}

variable "nat_gateway_ip2" {
  type        = string
  description = "nat_gateway_ip2"
}

####################
#  SecurityGroups  #
####################
variable "sg_bastion_ssh_in_id" {
  description = "Security group ID for SSH access from bastion host"
  type        = string
}

variable "sg_bastion_http_in_id" {
  description = "Security group ID for HTTP access from bastion host"
  type        = string
}

variable "sg_allow_all_out_id" {
  description = "Security group ID for allowing outbound connections"
  type        = string
}

variable "external_lb_sg_ids" {
  type        = list(string)
  description = "external_lb_sg_ids"
}


####################
# LB booleans      #
####################
variable "lb_access_logs_enabled" {
  type        = bool
  description = "Enable load balancer accesslogs to s3 bucket"
  default     = false
}


####################
# Cloudfront       #
####################
variable "acl_id" {
  type        = number
  description = "Optional ACL to use in front of Cloudfront distribution"
  default     = null
}

####################################################
# Magento autoscaling group min/max/desired values #
####################################################
variable "magento_autoscale_min" {
  type        = string
  default     = "1"
  description = "magento_autoscale_min"
}
variable "magento_autoscale_max" {
  type        = string
  default     = "8"
  description = "magento_autoscale_max"
}
variable "magento_autoscale_desired" {
  type        = string
  default     = "1"
  description = "magento_autoscale_desired"
}

#############################
# Magento EC2 Instance Size #
#############################
variable "ec2_instance_type_magento" {
  type        = string
  default     = "m6i.large"
  description = "ec2_instance_type_magento"
}

####################################################
# Varnish autoscaling group min/max/desired values #
####################################################
variable "varnish_autoscale_min" {
  type        = string
  default     = "1"
  description = "varnish_autoscale_min"
}
variable "varnish_autoscale_max" {
  type        = string
  default     = "1"
  description = "varnish_autoscale_max"
}
variable "varnish_autoscale_desired" {
  type        = string
  default     = "1"
  description = "varnish_autoscale_desired"
}

#############################
# Varnish EC2 Instance Size #
#############################
variable "ec2_instance_type_varnish" {
  type        = string
  default     = "m6i.large"
  description = "ec2_instance_type_varnish"
}