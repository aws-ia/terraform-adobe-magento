# ------------------------
# | Elastic File System  |
# ------------------------

# Create new EFS storage

resource "aws_efs_file_system" "magento_data" {
  creation_token = "magento_data"
  encrypted = true

  tags = {
    Name = "efs-magento-data"
    Description = "EFS storage for Magento"
    Terraform = "true"
  }

  lifecycle {
    ignore_changes = [ creation_token ]
  }

}

# Mount EFS to private subnets

resource "aws_efs_mount_target" "efs_private_subnet_mount" {
  file_system_id  = aws_efs_file_system.magento_data.id
  subnet_id       = var.private_subnet_id 
  security_groups = [var.sg_efs_private_in_id]
}

resource "aws_efs_mount_target" "efs_private2_subnet_mount" {
  file_system_id  = aws_efs_file_system.magento_data.id
  subnet_id       = var.private2_subnet_id
  security_groups = [var.sg_efs_private_in_id]
}
