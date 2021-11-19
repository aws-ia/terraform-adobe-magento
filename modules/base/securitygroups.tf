#####################
#  Security Groups  #
#####################

# Allow HTTP traffic to port 80 from bastion host
resource "aws_security_group" "from_bastion_http_in" {
  name        = "from_bastion_http_in"
  description = "Allow incoming HTTP traffic from bastion host"
  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = [
      local.public_subnet_cidr_block,
      local.public2_subnet_cidr_block
    ]
  }
  vpc_id = local.vpc_id

  tags = {
    Name      = "from_bastion_http_in"
    Terraform = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Allow SSH from management IP addresses to bastion host
resource "aws_security_group" "management_bastion_ssh_in" {
  name        = "management_bastion_ssh_in"
  description = "Allow incoming connections to the bastion host"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.management_addresses
  }
  vpc_id = local.vpc_id

  tags = {
    Name      = "bastion_ssh_in"
    Terraform = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Allow SSH from bastion host
resource "aws_security_group" "from_bastion_ssh_in" {
  name        = "from_bastion_ssh_in"
  description = "Allow incoming SSH connections from bastion host"
  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = [
      local.public_subnet_cidr_block,
      local.public2_subnet_cidr_block
    ]
  }
  vpc_id = local.vpc_id

  tags = {
    Name      = "from_bastion_ssh_in"
    Terraform = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Allow all outgoing traffic 
resource "aws_security_group" "allow_all_out" {
  name        = "allow_all_out"
  description = "Allow all outbound connections"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  vpc_id = local.vpc_id

  tags = {
    Name      = "allow_all_out"
    Terraform = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Allow HTTP traffic to certain IP addresses
resource "aws_security_group" "restricted_http_in" {
  name        = "restricted_http_in"
  description = "Allow HTTP traffic from limited IP addresses"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = var.management_addresses
  }
  vpc_id = local.vpc_id

  tags = {
    Name      = "restricted_http_in"
    Terraform = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Allow HTTPS traffic to certain IP addresses
resource "aws_security_group" "restricted_https_in" {
  name        = "restricted_https_in"
  description = "Allow HTTPS traffic from limited IP addresses"
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = var.management_addresses
  }
  vpc_id = local.vpc_id

  tags = {
    Name      = "restricted_https_in"
    Terraform = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "all_http_in" {
  name        = "all_http_in"
  description = "Allow incoming HTTP traffic from everywhere"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  vpc_id = local.vpc_id

  tags = {
    Name      = "http-in"
    Terraform = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Allow HTTPS traffic to port 443 from all

resource "aws_security_group" "all_https_in" {
  name        = "all_https_in"
  description = "Allow incoming HTTPS traffic"
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  vpc_id = local.vpc_id

  tags = {
    Name      = "all-https-in"
    Terraform = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "efs_private_in" {
  name        = "efs_private_in"
  description = "Allow NFS from private subnet"
  ingress {
    from_port = 2049
    to_port   = 2049
    protocol  = "TCP"
    cidr_blocks = [
      local.private_subnet_cidr_block,
      local.private2_subnet_cidr_block
    ]
  }
  egress {
    from_port = 0
    to_port   = 0
    protocol  = "TCP"
    cidr_blocks = [
      local.private_subnet_cidr_block,
      local.private2_subnet_cidr_block
    ]
  }
  vpc_id = local.vpc_id

  tags = {
    Name      = "efs-private-in"
    Terraform = true
  }

  lifecycle {
    create_before_destroy = true
  }
}