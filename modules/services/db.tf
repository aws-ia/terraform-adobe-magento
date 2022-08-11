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
  count                        = var.use_aurora ? 0 : 1
  allocated_storage            = var.magento_db_allocated_storage
  backup_retention_period      = var.magento_db_backup_retention_period
  db_subnet_group_name         = "magento-rds"
  identifier                   = "magento-db-${count.index}"
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
    ignore_changes = []
  }
}

#tfsec:ignore:aws-rds-encrypt-cluster-storage-data
resource "aws_rds_cluster" "magento_db_aurora" {
  count                       = var.use_aurora ? 1 : 0
  cluster_identifier          = "magento-db"
  engine                      = "aurora-mysql"
  engine_version              = "8.0.mysql_aurora.3.01.0"
  allow_major_version_upgrade = false
  database_name               = var.magento_db_name
  master_username             = var.magento_db_username
  master_password             = var.magento_database_password
  vpc_security_group_ids      = [aws_security_group.allow_rds_in.id]
  skip_final_snapshot         = var.skip_rds_snapshot_on_destroy
  final_snapshot_identifier   = "magento-final-snapshot-${random_string.db_suffix.result}"
  db_subnet_group_name        = "magento-rds"
  depends_on                  = [aws_db_subnet_group.magento_rds]
  storage_encrypted           = true
  backup_retention_period     = 5

  timeouts {
    create = "60m"
  }

  tags = {
    Name      = "magento-aurora-database"
    Terraform = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

#tfsec:ignore:aws-rds-enable-performance-insights-encryption
resource "aws_rds_cluster_instance" "aurora_cluster_instance" {
  count                        = var.use_aurora ? 1 : 0
  identifier                   = "magento-db-${count.index}"
  cluster_identifier           = aws_rds_cluster.magento_db_aurora[0].id
  engine                       = "aurora-mysql"
  engine_version               = "8.0.mysql_aurora.3.01.0"
  instance_class               = var.ec2_instance_type_rds
  db_subnet_group_name         = "magento-rds"
  publicly_accessible          = false
  performance_insights_enabled = true

  timeouts {
    create = "60m"
  }

  tags = {
    Name      = "magento-aurora-database"
    Terraform = true
  }

  lifecycle {
    create_before_destroy = true
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