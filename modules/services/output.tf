output "redis_sessions_host" {
  value = aws_elasticache_replication_group.redis-sessions.primary_endpoint_address
}

output "redis_cache_host" {
  value = aws_elasticache_replication_group.redis-backend-cache.primary_endpoint_address
}

output "magento_database_host" {
  value = var.use_aurora ? "${aws_rds_cluster.magento_db_aurora[0].endpoint}" : "${aws_db_instance.magento_db[0].endpoint}"
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