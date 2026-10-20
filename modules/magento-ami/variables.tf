#################
# Common        #
#################
variable "base_ami_id" {
  type        = string
  description = "Base AMI for EC2 instances."
}

variable "ssh_key_name" {
  type        = string
  description = "Admin SSH key name stored in secrets manager."
}

variable "ssh_username" {
  type        = string
  description = "Admin SSH username"

  validation {
    condition     = can(regex("^[a-zA-Z0-9._-]+$", var.ssh_username))
    error_message = "ssh_username may only contain letters, digits, dots, underscores, and hyphens."
  }
}

variable "ssh_key_pair_name" {
  type        = string
  description = "Generated key-pair name in the AWS console."
}

################################
# Magento Composer Credentials #
################################
variable "mage_composer_username" {
  type        = string
  description = "Magento auth.json username"

  validation {
    condition     = can(regex("^[a-zA-Z0-9._@-]+$", var.mage_composer_username))
    error_message = "mage_composer_username may only contain letters, digits, and the characters . _ @ -"
  }
}

variable "mage_composer_password" {
  type        = string
  description = "Magento auth.json password"
  sensitive   = true

  validation {
    condition     = can(regex("^[a-zA-Z0-9._@-]+$", var.mage_composer_password))
    error_message = "mage_composer_password may only contain letters, digits, and the characters . _ @ -"
  }
}

###################################
#  SecurityGroups and Networking  #
###################################
variable "sg_allow_all_out_id" {
  description = "Security group ID for allowing outbound connections"
  type        = string
}

variable "public_subnet_id" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "management_addresses" {
  description = "IP addresses for management traffic"
  type        = list(string)
}