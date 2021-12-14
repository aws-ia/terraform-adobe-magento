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

output "user_instructions" {
  value = <<README
NOTE! It takes about ~15 minutes for Magento to bootstrap
so please wait for a while before trying out the installation.

Webshop will be available at: https://${module.magento.magento_frontend_url}/ once ready.

Bastion host and Magento webserver IPs can be found from the AWS Console.

You can connect to web node with the following:
ssh -i PATH_TO_GENERATED_KEY -J admin@BASTION_PUBLIC_IP admin@WEB_NODE_PRIVATE_IP

Ensure you have SSH key forwarding enabled.
README
}