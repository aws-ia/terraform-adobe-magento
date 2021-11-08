# These variables have no default values and must be supplied when
# consuming this module.

variable "project" {
  description = "Project identifier, used in e.g. S3 bucket naming"
  type = string
}

variable "domain_name" {
  description = "Project domain name used in e.g. bastion hosts"
  type = string
}