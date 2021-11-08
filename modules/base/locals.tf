data "aws_subnet" "public" {
  id = local.public_subnet_id
}

data "aws_subnet" "public2" {
  id = local.public2_subnet_id
}

data "aws_subnet" "private" {
  id = local.private_subnet_id
}

data "aws_subnet" "private2" {
  id = local.private2_subnet_id
}

data "aws_nat_gateway" "public" {
  count = local.vpc_count_nat
  vpc_id = local.vpc_id
  subnet_id = local.public_subnet_id
  state = "available"
}

data "aws_nat_gateway" "public2" {
  count = local.vpc_count_nat
  vpc_id = local.vpc_id
  subnet_id = local.public2_subnet_id
  state = "available"
}

locals {
  vpc_count = var.create_vpc ? 1 : 0
  vpc_count_nat = var.create_vpc ? 0 : 1
  vpc_id = var.create_vpc ? aws_vpc.main[0].id : var.vpc_id
  public_subnet_id = var.create_vpc ? aws_subnet.public[0].id : var.vpc_public_subnet_id
  public2_subnet_id = var.create_vpc ? aws_subnet.public2[0].id : var.vpc_public2_subnet_id
  private_subnet_id = var.create_vpc ? aws_subnet.private[0].id : var.vpc_private_subnet_id
  private2_subnet_id = var.create_vpc ? aws_subnet.private2[0].id : var.vpc_private2_subnet_id
  rds_subnet_id = var.create_vpc ? aws_subnet.rds_subnet[0].id : var.vpc_rds_subnet_id
  rds_subnet2_id = var.create_vpc ? aws_subnet.rds_subnet2[0].id : var.vpc_rds_subnet2_id
  nat_gateway_ip1 = var.create_vpc ? aws_nat_gateway.nat_gw[0].public_ip : data.aws_nat_gateway.public[0].public_ip
  nat_gateway_ip2 = var.create_vpc ? aws_nat_gateway.nat_gw2[0].public_ip : data.aws_nat_gateway.public2[0].public_ip
  public_subnet_cidr_block = data.aws_subnet.public.cidr_block
  public2_subnet_cidr_block = data.aws_subnet.public2.cidr_block
  private_subnet_cidr_block = data.aws_subnet.private.cidr_block
  private2_subnet_cidr_block = data.aws_subnet.private2.cidr_block
}