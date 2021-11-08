output "magento_frontend_url" {
  value = module.magento.cloudfront-distribution-url
}

output "magento_admin_url" {
  value = "${module.magento.cloudfront-distribution-url}/admin"
}

output "magento_admin_password" {
  value = module.ssm.magento_admin_password
  sensitive = true
}

output "magento_admin_email" {
  value = var.magento_admin_email
}

output "magento_database_host" {
  value = module.services.magento_database_host
}

output "magento_elasticsearch_host" {
  value = module.services.magento_elasticsearch_host
}

output "magento_cache_host" {
  value = module.services.magento_cache_host
}

output "magento_session_host" {
  value = module.services.magento_session_host
}

output "magento_rabbitmq_host" {
  value = module.services.magento_rabbitmq_host
}

output "magento_files_s3" {
  value = module.magento.magento_files_s3
}

output "alb_external_dns_name" {
  value = module.magento.alb_external_dns_name
}