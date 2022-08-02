# -------------------
# | Security groups |
# -------------------

# Allow internal HTTP connections from public and private subnets
resource "aws_security_group" "internal_http_in" {
  name        = "internal_http_in"
  description = "Allow HTTP traffic from private and public subnets"
  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "TCP"
    cidr_blocks = [
      data.aws_subnet.private_subnet.cidr_block,
      data.aws_subnet.public_subnet.cidr_block,
      data.aws_subnet.private2_subnet.cidr_block,
      data.aws_subnet.public2_subnet.cidr_block
    ]
  }
  vpc_id = var.vpc_id

  tags = {
    Name      = "internal-http-in"
    Terraform = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Allow internal SSH connections from private subnets
resource "aws_security_group" "internal_ssh_in" {
  name        = "internal_ssh_in"
  description = "Allow SSH traffic from private subnets"
  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "TCP"
    cidr_blocks = [
      data.aws_subnet.private_subnet.cidr_block,
      data.aws_subnet.private2_subnet.cidr_block
    ]
  }

  vpc_id = var.vpc_id

  tags = {
    Name      = "internal-ssh-in"
    Terraform = "true"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "internal_ssh_out" {
  name        = "internal_ssh_out"
  description = "Allow SSH traffic from private subnets"
  egress {
    from_port = 22
    to_port   = 22
    protocol  = "TCP"
    cidr_blocks = [
      data.aws_subnet.private_subnet.cidr_block,
      data.aws_subnet.private2_subnet.cidr_block
    ]
  }
  vpc_id = var.vpc_id

  tags = {
    Name      = "internal-ssh-out"
    Terraform = "true"
  }

  lifecycle {
    create_before_destroy = true
  }
}
