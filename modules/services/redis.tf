# ------------------------
# | ElastiCache (Redis)  |
# ------------------------

resource "aws_elasticache_subnet_group" "elasticache" {
  name        = "elasticache-subnet-group"
  description = "Use the private subnet for ElastiCache instances."
  subnet_ids  = [var.private_subnet_id, var.private2_subnet_id]
}

resource "aws_elasticache_parameter_group" "magento_required" {
  name   = "magento-required"
  family = "redis6.x"

  parameter {
    name  = "maxmemory-policy"
    value = "allkeys-lfu"
  }
}

# Redis instance for backend caching
#tfsec:ignore:aws-elasticache-enable-in-transit-encryption
resource "aws_elasticache_replication_group" "redis_backend_cache" {
  automatic_failover_enabled    = true
  availability_zones            = [var.az1, var.az2]
  multi_az_enabled              = true
  engine                        = "redis"
  engine_version                = var.redis_engine_version
  replication_group_id          = "redis-backend-cache"
  replication_group_description = "Redis Replication Group"
  transit_encryption_enabled    = false
  node_type                     = var.ec2_instance_type_redis_cache
  number_cache_clusters         = 2
  parameter_group_name          = aws_elasticache_parameter_group.magento_required.name
  subnet_group_name             = aws_elasticache_subnet_group.elasticache.name
  security_group_ids            = [aws_security_group.allow_redis_in.id]
  port                          = 6379
  at_rest_encryption_enabled    = true

  lifecycle {
    ignore_changes = [number_cache_clusters]
  }

  tags = {
    Name      = "magento_redis_backend_cache"
    Terraform = true
  }
}

# Redis instance for sessions
#tfsec:ignore:aws-elasticache-enable-in-transit-encryption
resource "aws_elasticache_replication_group" "redis_sessions" {
  automatic_failover_enabled    = true
  availability_zones            = [var.az1, var.az2]
  multi_az_enabled              = true
  engine                        = "redis"
  engine_version                = var.redis_engine_version
  replication_group_id          = "redis-sessions"
  replication_group_description = "Redis Replication Group"
  transit_encryption_enabled    = false
  node_type                     = var.ec2_instance_type_redis_session
  number_cache_clusters         = 2
  parameter_group_name          = aws_elasticache_parameter_group.magento_required.name
  subnet_group_name             = aws_elasticache_subnet_group.elasticache.name
  security_group_ids            = [aws_security_group.allow_redis_in.id]
  port                          = 6379
  at_rest_encryption_enabled    = true

  lifecycle {
    ignore_changes = [number_cache_clusters]
  }

  tags = {
    Name      = "magento_redis_sessions"
    Terraform = true
  }
}