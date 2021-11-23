output "magento_admin_password" {
  value = aws_ssm_parameter.magento_admin_password.value
}