################
# Magento Vars #
################

resource "aws_ssm_parameter" "magento_database_host" {
  name  = "/magento_database_host"
  type  = "String"
  value = var.use_aurora ? aws_rds_cluster.magento_db_aurora[0].endpoint : aws_db_instance.magento_db[0].address
  tags = {
    Terraform = true
  }
}

resource "aws_ssm_parameter" "magento_database_username" {
  name  = "/magento_database_username"
  type  = "String"
  value = var.use_aurora ? aws_rds_cluster.magento_db_aurora[0].master_username : aws_db_instance.magento_db[0].username
  tags = {
    Terraform = true
  }
}

resource "aws_ssm_parameter" "magento_cache_host" {
  name  = "/magento_cache_host"
  type  = "String"
  value = aws_elasticache_replication_group.redis_backend_cache.primary_endpoint_address
  tags = {
    Terraform = true
  }
}

resource "aws_ssm_parameter" "magento_session_host" {
  name  = "/magento_session_host"
  type  = "String"
  value = aws_elasticache_replication_group.redis_sessions.primary_endpoint_address
  tags = {
    Terraform = true
  }
}

resource "aws_ssm_parameter" "magento_rabbitmq_host" {
  name  = "/magento_rabbitmq_host"
  type  = "String"
  value = trimsuffix(trimprefix(aws_mq_broker.rabbit_mq.instances[0].endpoints[0], "amqps://"), ":5671")
  tags = {
    Terraform = true
  }
}

resource "aws_ssm_parameter" "magento_rabbitmq_username" {
  name  = "/magento_rabbitmq_username"
  type  = "String"
  value = var.rabbitmq_username
  tags = {
    Terraform = true
  }
}

resource "aws_ssm_parameter" "magento_elasticsearch_host" {
  name  = "/magento_elasticsearch_host"
  type  = "String"
  value = aws_elasticsearch_domain.es.endpoint
  tags = {
    Terraform = true
  }
}

resource "aws_ssm_parameter" "magento_efs_id" {
  name  = "/magento_efs_id"
  type  = "String"
  value = aws_efs_file_system.magento_data.id
  tags = {
    Terraform = true
  }
}