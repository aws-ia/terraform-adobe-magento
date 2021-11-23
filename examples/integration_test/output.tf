output "magento_frontend_url" {
  value = module.magento.magento_frontend_url
}

output "magento_admin_url" {
  value = "${module.magento.magento_frontend_url}/admin"
}

output "magento_admin_password" {
  value     = module.magento.magento_admin_password
  sensitive = true
}

output "magento_admin_email" {
  value = var.magento_admin_email
}

output "magento_database_host" {
  value = module.magento.magento_database_host
}

output "magento_elasticsearch_host" {
  value = module.magento.magento_elasticsearch_host
}

output "magento_cache_host" {
  value = module.magento.magento_cache_host
}

output "magento_session_host" {
  value = module.magento.magento_session_host
}

output "magento_rabbitmq_host" {
  value = module.magento.magento_rabbitmq_host
}

output "magento_files_s3" {
  value = module.magento.magento_files_s3
}

output "alb_external_dns_name" {
  value = module.magento.alb_external_dns_name
}