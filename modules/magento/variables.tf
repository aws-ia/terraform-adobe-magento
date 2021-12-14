#################
# Common        #
#################
variable "magento_ami" {
  type = string
}

variable "varnish_ami" {
  type = string
}

variable "project" {
  description = "Project identifier, used in e.g. S3 bucket naming"
  type        = string
}

variable "cert_arn" {
  type = string
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
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "public_subnet_id" {
  type = string
}

variable "private_subnet_id" {
  type = string
}

variable "public2_subnet_id" {
  type = string
}

variable "private2_subnet_id" {
  type = string
}

variable "nat_gateway_ip1" {
  type = string
}

variable "nat_gateway_ip2" {
  type = string
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
  type = list(string)
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
  description = "Optional ACL to use in front of Cloudfront distribution"
  default     = null
}

####################################################
# Magento autoscaling group min/max/desired values #
####################################################
variable "magento_autoscale_min" {
  default = "1"
}
variable "magento_autoscale_max" {
  default = "8"
}
variable "magento_autoscale_desired" {
  default = "1"
}

#############################
# Magento EC2 Instance Size #
#############################
variable "ec2_instance_type_magento" {
  default = "m6i.large"
}

####################################################
# Varnish autoscaling group min/max/desired values #
####################################################
variable "varnish_autoscale_min" {
  default = "1"
}
variable "varnish_autoscale_max" {
  default = "1"
}
variable "varnish_autoscale_desired" {
  default = "1"
}

#############################
# Varnish EC2 Instance Size #
#############################
variable "ec2_instance_type_varnish" {
  default = "m6i.large"
}