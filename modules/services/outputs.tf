output "redis_sessions_host" {
  description = "redis_sessions Host"
  value       = aws_elasticache_replication_group.redis_sessions.primary_endpoint_address
}

output "redis_cache_host" {
  description = "redis_cache host"
  value       = aws_elasticache_replication_group.redis_backend_cache.primary_endpoint_address
}

output "magento_database_host" {
  description = "magento_database host"
  value       = var.use_aurora ? aws_rds_cluster.magento_db_aurora[0].endpoint : aws_db_instance.magento_db[0].endpoint
}

output "magento_elasticsearch_host" {
  description = "magento_elasticsearch host"
  value       = aws_elasticsearch_domain.es.endpoint
}

output "magento_cache_host" {
  description = "magento_cache host"
  value       = aws_elasticache_replication_group.redis_backend_cache.primary_endpoint_address
}

output "magento_session_host" {
  description = "magento_session host"
  value       = aws_elasticache_replication_group.redis_sessions.primary_endpoint_address
}

output "magento_rabbitmq_host" {
  description = "magento_rabbitmq host"
  value       = aws_mq_broker.rabbit_mq.instances[0].endpoints
}