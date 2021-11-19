# ------------------
# | RDS            |
# ------------------

resource "aws_db_subnet_group" "magento_rds" {
  name       = "magento-rds"
  subnet_ids = [var.rds_subnet_id, var.rds_subnet2_id]
  tags = {
    Name      = "Subnet group for RDS"
    Terraform = true
  }
}

resource "random_string" "db_suffix" {
  length  = 5
  special = false
  upper   = false
}

resource "aws_db_instance" "magento_db" {
  allocated_storage            = var.magento_db_allocated_storage
  backup_retention_period      = var.magento_db_backup_retention_period
  db_subnet_group_name         = "magento-rds"
  identifier                   = "magento-db"
  engine                       = "mysql"
  engine_version               = "8.0"
  allow_major_version_upgrade  = false
  auto_minor_version_upgrade   = true
  instance_class               = var.ec2_instance_type_rds
  multi_az                     = true
  port                         = 3306
  name                         = var.magento_db_name
  username                     = var.magento_db_username
  password                     = var.magento_database_password
  vpc_security_group_ids       = [aws_security_group.allow_rds_in.id]
  skip_final_snapshot          = var.skip_rds_snapshot_on_destroy
  final_snapshot_identifier    = "magento-final-snapshot-${random_string.db_suffix.result}"
  depends_on                   = [aws_db_subnet_group.magento_rds]
  performance_insights_enabled = var.magento_db_performance_insights_enabled
  storage_encrypted            = true

  timeouts {
    create = "60m"
  }

  tags = {
    Name      = "magento-rds-database"
    Terraform = true
  }

  lifecycle {
    ignore_changes = [
      latest_restorable_time
    ]
  }
}

resource "aws_ssm_parameter" "magento_database_password" {
  name  = "/magento_database_password"
  type  = "SecureString"
  value = var.magento_database_password
  tags = {
    Terraform = true
  }
}