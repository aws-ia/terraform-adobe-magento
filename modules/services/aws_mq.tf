resource "random_string" "mq_password" {
  length = 16
  special = false
  upper = true
}

/*
data "aws_ssm_parameter" "rabbitmq_password" {
  name = "/rabbitmq_password"
}
*/

resource "aws_mq_broker" "rabbit_mq" {
  broker_name = "rabbitmq"

  #configuration {
  #  id = aws_mq_configuration.rabbit_mq_configuration.id
  #}

  engine_type                = "RabbitMQ"
  engine_version             = var.mq_engine_version
  host_instance_type         = var.mq_instance_type
  auto_minor_version_upgrade = true
  deployment_mode            = "CLUSTER_MULTI_AZ"
  publicly_accessible        = false
  subnet_ids = [
        var.private_subnet_id,
        var.private2_subnet_id
    ]

  security_groups = [
        aws_security_group.allow_awsmq_in.id
    ]

  user {
    username = var.rabbitmq_username
    password = random_string.mq_password.result
  }

  tags = {
      Terraform   = "True"
  }
}

resource "aws_ssm_parameter" "rabbitmq_password" {
  name  = "/rabbitmq_password"
  type  = "SecureString"
  value = random_string.mq_password.result
  tags = {
    Terraform = true
  }
}

#resource "aws_mq_configuration" "rabbit_mq_configuration" {
#  description    = "RabbitMQ ${var.environment} Configuration"
#  name           = "${var.environment}-rabbitmq-configuration"
#  engine_type    = "RabbitMQ"
#  engine_version = "3.8.22"
#}