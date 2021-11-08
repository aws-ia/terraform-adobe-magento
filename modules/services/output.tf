output "redis_sessions_host" {
  value = aws_elasticache_replication_group.redis-sessions.primary_endpoint_address
}

output "redis_cache_host" {
  value = aws_elasticache_replication_group.redis-backend-cache.primary_endpoint_address
}

output "magento_database_host" {
  value = aws_db_instance.magento_db.endpoint
}

output "magento_elasticsearch_host" {
  value = aws_elasticsearch_domain.es.endpoint
}

output "magento_cache_host" {
  value = aws_elasticache_replication_group.redis-backend-cache.primary_endpoint_address
}

output "magento_session_host" {
  value = aws_elasticache_replication_group.redis-sessions.primary_endpoint_address
}

output "magento_rabbitmq_host" {
  value = aws_mq_broker.rabbit_mq.instances.0.endpoints
}