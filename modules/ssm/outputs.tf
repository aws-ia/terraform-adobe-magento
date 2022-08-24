output "magento_admin_password" {
  description = "magento admin password"
  value       = aws_ssm_parameter.magento_admin_password.value
}