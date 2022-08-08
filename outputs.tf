output "magento_frontend_url" {
  value       = module.magento.cloudfront_distribution_url
  description = "Magento frontend URL"
}

output "magento_admin_url" {
  value       = "${module.magento.cloudfront_distribution_url}/admin"
  description = "Magento admin URL"
}

output "magento_admin_password" {
  value       = module.ssm.magento_admin_password
  sensitive   = true
  description = "Magento admin password"
}

output "magento_admin_email" {
  value       = var.magento_admin_email
  description = "Magento admin email address"
}

output "magento_database_host" {
  value       = module.services.magento_database_host
  description = "Magento DB hostname"
}

output "magento_elasticsearch_host" {
  value       = module.services.magento_elasticsearch_host
  description = "Magento ES hostname"
}

output "magento_cache_host" {
  value       = module.services.magento_cache_host
  description = "Magento cache hostname"
}

output "magento_session_host" {
  value       = module.services.magento_session_host
  description = "Magento session hostname"
}

output "magento_rabbitmq_host" {
  value       = module.services.magento_rabbitmq_host
  description = "Magento rabbitmq hostname"
}

output "magento_files_s3" {
  value       = module.magento.magento_files_s3
  description = "Magento files S3"
}

output "alb_external_dns_name" {
  value       = module.magento.alb_external_dns_name
  description = "ALB DNS hostname"
}