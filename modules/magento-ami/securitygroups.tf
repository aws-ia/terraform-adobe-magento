
resource "aws_security_group" "management_ssh_in" {
  name        = "management_ssh_in"
  description = "Allow incoming connections to the Magento AMI creation host"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  vpc_id = var.vpc_id

  tags = {
    Name      = "magento_ami_ssh_in"
    Terraform = true
  }

  lifecycle {
    create_before_destroy = true
  }
}