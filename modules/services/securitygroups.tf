# -------------------
# | Security groups |
# -------------------
resource "aws_security_group" "allow_redis_in" {
  name        = "allow_redis_in"
  description = "Allow redis connections from private subnet"
  vpc_id      = var.vpc_id
  ingress {
    description = "Allow redis connections from private subnet"
    from_port   = 6379
    to_port     = 6379
    protocol    = "TCP"
    cidr_blocks = [
      data.aws_subnet.private_subnet.cidr_block,
      data.aws_subnet.private2_subnet.cidr_block
    ]
  }
  egress {
    description = "Allow redis connections from private subnet"
    from_port   = 6379
    to_port     = 6379
    protocol    = "TCP"
    cidr_blocks = [
      data.aws_subnet.private_subnet.cidr_block,
      data.aws_subnet.private2_subnet.cidr_block
    ]
  }

  tags = {
    Name      = "allow-redis-in"
    Terraform = true
  }
}

resource "aws_security_group" "allow_awsmq_in" {
  name        = "allow_awsmq_in"
  description = "Allow rabbitmq connections from private subnet"
  vpc_id      = var.vpc_id
  ingress {
    description = "Allow rabbitmq connections from private subnet"
    from_port   = 5671
    to_port     = 5671
    protocol    = "TCP"
    cidr_blocks = [
      data.aws_subnet.private_subnet.cidr_block,
      data.aws_subnet.private2_subnet.cidr_block
    ]
  }
  egress {
    description = "Allow rabbitmq connections from private subnet"
    from_port   = 5671
    to_port     = 5671
    protocol    = "TCP"
    cidr_blocks = [
      data.aws_subnet.private_subnet.cidr_block,
      data.aws_subnet.private2_subnet.cidr_block
    ]
  }

  tags = {
    Name      = "allow-rabbitmq-in"
    Terraform = true
  }
}

resource "aws_security_group" "allow_rds_in" {
  name        = "allow_rds_in"
  description = "Allow incoming MySQL traffic from private subnet and bastion host"
  vpc_id      = var.vpc_id
  ingress {
    description = "Allow incoming MySQL traffic from private subnet and bastion host"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [
      data.aws_subnet.private_subnet.cidr_block,
      data.aws_subnet.private2_subnet.cidr_block,
      data.aws_subnet.public_subnet.cidr_block,
      data.aws_subnet.public2_subnet.cidr_block
    ]
  }
  egress {
    description = "Allow incoming MySQL traffic from private subnet and bastion host"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [
      data.aws_subnet.private_subnet.cidr_block,
      data.aws_subnet.private2_subnet.cidr_block,
      data.aws_subnet.public_subnet.cidr_block,
      data.aws_subnet.public2_subnet.cidr_block
    ]
  }
  tags = {
    Name      = "allow-rds"
    Terraform = true
  }
  lifecycle {
    create_before_destroy = true
  }
}

# Allow HTTP to ElasticSearch port 443 from private subnets and bastion hosts

resource "aws_security_group" "internal_es_http_in" {
  name        = "internal_es_http_in"
  description = "Allow Elasticsearch HTTP traffic from private and public subnets"
  ingress {
    description = "Allow Elasticsearch HTTP traffic from private and public subnets"
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = [
      data.aws_subnet.private_subnet.cidr_block,
      data.aws_subnet.private2_subnet.cidr_block,
      data.aws_subnet.public_subnet.cidr_block,
      data.aws_subnet.public2_subnet.cidr_block
    ]
  }

  vpc_id = var.vpc_id

  tags = {
    Name      = "internal-es-http-in"
    Terraform = true
  }

  lifecycle {
    create_before_destroy = true
  }
}
