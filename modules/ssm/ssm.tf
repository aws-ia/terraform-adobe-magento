######################
# Generate randoms   #
######################

resource "random_string" "random_encryption_key" {
  length  = 32
  special = false
  upper   = false
}

resource "aws_ssm_parameter" "magento_admin_password" {
  name  = "/magento_admin_password"
  type  = "SecureString"
  value = var.magento_admin_password
  tags = {
    Terraform = true
  }
}

resource "aws_ssm_parameter" "magento_admin_firstname" {
  name  = "/magento_admin_firstname"
  type  = "String"
  value = var.magento_admin_firstname
  tags = {
    Terraform = true
  }
}

resource "aws_ssm_parameter" "magento_admin_lastname" {
  name  = "/magento_admin_lastname"
  type  = "String"
  value = var.magento_admin_lastname
  tags = {
    Terraform = true
  }
}

resource "aws_ssm_parameter" "magento_admin_email" {
  name  = "/magento_admin_email"
  type  = "String"
  value = var.magento_admin_email
  tags = {
    Terraform = true
  }
}

resource "aws_ssm_parameter" "magento_admin_username" {
  name  = "/magento_admin_username"
  type  = "String"
  value = var.magento_admin_username
  tags = {
    Terraform = true
  }
}

############################
# Database Encryption Keys #
############################

resource "aws_ssm_parameter" "magento_crypt_key" {
  name  = "/magento_crypt_key"
  type  = "SecureString"
  value = random_string.random_encryption_key.result
  tags = {
    Terraform = true
  }
}

################
# Project Name #
################

resource "aws_ssm_parameter" "project_name" {
  name  = "/project_name"
  type  = "String"
  value = var.project
  tags = {
    Terraform = true
  }
}