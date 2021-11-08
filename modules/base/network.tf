#########
#  VPC  #
#########

resource "aws_vpc" "main" {
  count = local.vpc_count
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true

  tags = {
    Name = "main_vpc"
    Description = "Main VPC" 
    Terraform = "true"
  }
}

############
# Gateways #
############

resource "aws_internet_gateway" "main" {
  count = local.vpc_count
  vpc_id = aws_vpc.main[count.index].id

  tags = {
    Name = "internet_gw"
    Description = "Internet gateway for main VPC"
    Terraform = "true"
  }
}

resource "aws_nat_gateway" "nat_gw" {
  count = local.vpc_count
  allocation_id = aws_eip.nat_gw[count.index].id
  subnet_id = aws_subnet.public[count.index].id
}

resource "aws_nat_gateway" "nat_gw2" {
  count = local.vpc_count
  allocation_id = aws_eip.nat_gw2[count.index].id
  subnet_id = aws_subnet.public2[count.index].id
}

###############
# Elastic IPs #
###############

resource "aws_eip" "nat_gw" {
  count = local.vpc_count
  vpc = true
  depends_on = [aws_internet_gateway.main]

  tags = {
    Name = "nat_gw"
    Description = "Elastic IP for NAT gateway"
    Terraform = "true"
  }
}


resource "aws_eip" "nat_gw2" {
  count = local.vpc_count
  vpc = true
  depends_on = [aws_internet_gateway.main]

  tags = {
    Name = "nat_gw2"
    Description = "Elastic IP for NAT gateway 2"
    Terraform = "true"
  }
}

#############
#  Subnets  #
#############

resource "aws_subnet" "public" {
  count = local.vpc_count
  vpc_id = aws_vpc.main[count.index].id
  cidr_block = cidrsubnet(var.vpc_cidr, 4, 8) 
  availability_zone = var.az1
  map_public_ip_on_launch = false
  tags = {
    Name = "public-subnet"
    Description = "Public subnet for frontend services"
    Terraform = "true"
  }
}

resource "aws_subnet" "private" {
  count = local.vpc_count
  vpc_id = aws_vpc.main[count.index].id
  cidr_block = cidrsubnet(var.vpc_cidr, 3, 0) 
  availability_zone = var.az1
  map_public_ip_on_launch = false
  tags = {
    Name = "private-subnet"
    Description = "Private subnet for backend services"
    Terraform = "true"
  }
}

# Second public subnet
resource "aws_subnet" "public2" {
  count = local.vpc_count
  vpc_id = aws_vpc.main[count.index].id
  cidr_block = cidrsubnet(var.vpc_cidr, 4, 9) 
  availability_zone = var.az2
  map_public_ip_on_launch = false
  tags = {
    Name = "public-subnet2"
    Description = "Public subnet 2"
    Terraform = "true"
  }
}

# Second private subnet
resource "aws_subnet" "private2" {
  count = local.vpc_count
  vpc_id = aws_vpc.main[count.index].id
  cidr_block = cidrsubnet(var.vpc_cidr, 3, 1) 
  availability_zone = var.az2
  map_public_ip_on_launch = false
  tags = {
    Name = "private-subnet2"
    Description = "Private subnet 2"
    Terraform = "true"
  }
}


####################
# RDS Subnets      #
####################
# RDS Subnet az1
resource "aws_subnet" "rds_subnet" {
  count = local.vpc_count
  vpc_id = aws_vpc.main[count.index].id
  cidr_block = cidrsubnet(var.vpc_cidr, 4, 10)
  availability_zone = var.az1
  map_public_ip_on_launch = false
  tags = {
    Name = "rds-subnet"
    Description = "RDS subnet"
    Terraform = "true"
  }
}

# RDS Subnet az2
resource "aws_subnet" "rds_subnet2" {
  count = local.vpc_count
  vpc_id = aws_vpc.main[count.index].id
  cidr_block = cidrsubnet(var.vpc_cidr, 4, 11)
  availability_zone = var.az2
  map_public_ip_on_launch = false
  tags = {
    Name = "rds-subnet2"
    Description = "RDS subnet 2"
    Terraform = "true"
  }
}

####################
#  Routing tables  #
####################

resource "aws_route_table" "default_to_igw" {
  count = local.vpc_count
  vpc_id = aws_vpc.main[count.index].id
  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.main[count.index].id
  }
  timeouts {
    create = "5m"
  }
  tags = {
    Name = "default_to_igw"
    Description = "Default route to internet gateway"
    Terraform = "true"
  }
}

resource "aws_route_table" "default_to_natgw" {
  count = local.vpc_count
  vpc_id = aws_vpc.main[count.index].id
  route {
      cidr_block = "0.0.0.0/0"
      nat_gateway_id = aws_nat_gateway.nat_gw[count.index].id
  }
  timeouts {
    create = "5m"
  }
  tags = {
    Name = "default_to_natgw"
    Description = "Default route to NAT gateway"
    Terraform = "true"
  }
}

resource "aws_route_table" "default_to_natgw2" {
  count = local.vpc_count
  vpc_id = aws_vpc.main[count.index].id
  route {
      cidr_block = "0.0.0.0/0"
      nat_gateway_id = aws_nat_gateway.nat_gw2[count.index].id
  }
  timeouts {
    create = "5m"
  }
  tags = {
    Name = "default_to_natgw2"
    Description = "Default route to NAT gateway 2"
    Terraform = "true"
  }
}


# Route public to IGW
resource "aws_route_table_association" "public" {
  count = local.vpc_count
  subnet_id = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.default_to_igw[count.index].id
}

# Route private to NAT GW
resource "aws_route_table_association" "private" {
  count = local.vpc_count
  subnet_id = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.default_to_natgw[count.index].id
}

# Route public2 to IGW
resource "aws_route_table_association" "public2" {
  count = local.vpc_count
  subnet_id = aws_subnet.public2[count.index].id
  route_table_id = aws_route_table.default_to_igw[count.index].id
}

# Route private2 to NAT GW
resource "aws_route_table_association" "private2" {
  count = local.vpc_count
  subnet_id = aws_subnet.private2[count.index].id
  route_table_id = aws_route_table.default_to_natgw2[count.index].id
}

# Route RDS subnet to NAT GW #1
resource "aws_route_table_association" "rds_subnet" {
  count = local.vpc_count
  subnet_id = aws_subnet.rds_subnet[count.index].id
  route_table_id = aws_route_table.default_to_natgw[count.index].id
}

# Route RDS subnet to NAT GW #2
resource "aws_route_table_association" "rds_subnet2" {
  count = local.vpc_count
  subnet_id = aws_subnet.rds_subnet2[count.index].id
  route_table_id = aws_route_table.default_to_natgw2[count.index].id
}
