# -------------------
# | Security groups |
# -------------------

# Allow internal HTTP connections from public and private subnets
resource aws_security_group "internal_http_in" {
  name          = "internal_http_in"
  description   = "Allow HTTP traffic from private and public subnets"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = [
      data.aws_subnet.private_subnet.cidr_block,
      data.aws_subnet.public_subnet.cidr_block,
      data.aws_subnet.private2_subnet.cidr_block,
      data.aws_subnet.public2_subnet.cidr_block
      ]
  }
  vpc_id        = var.vpc_id

  tags = {
    Name = "internal-http-in"
    Terraform = "true"
  }

  lifecycle {
    create_before_destroy = true
  }
}
