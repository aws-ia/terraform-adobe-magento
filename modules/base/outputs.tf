###
# Network
###
output "vpc_id" {
  value       = local.vpc_id
  description = "VPC ID"
}

output "subnet_private_id" {
  value       = local.private_subnet_id
  description = "VPC private subnet ID 1"
}

output "subnet_public_id" {
  value       = local.public_subnet_id
  description = "VPC public subnet ID 1"
}

output "subnet_private2_id" {
  value       = local.private2_subnet_id
  description = "VPC private subnet ID 2"
}

output "subnet_public2_id" {
  value       = local.public2_subnet_id
  description = "VPC public subnet ID 2"
}

output "rds_subnet_id" {
  value       = local.rds_subnet_id
  description = "VPC RDS private subnet ID 1"
}

output "rds_subnet2_id" {
  value       = local.rds_subnet2_id
  description = "VPC RDS private subnet ID 1"
}

###
# Security Groups
###
output "sg_allow_all_out_id" {
  value       = aws_security_group.allow_all_out.id
  description = "All out"
}

output "sg_bastion_ssh_in_id" {
  value       = aws_security_group.from_bastion_ssh_in.id
  description = "Bashtion SSH"
}

output "sg_bastion_http_in_id" {
  value       = aws_security_group.from_bastion_http_in.id
  description = "Bastion HTTP in"
}

output "sg_all_http_in_id" {
  value       = aws_security_group.all_http_in.id
  description = "HTTP all in"
}

output "sg_all_https_in_id" {
  value       = aws_security_group.all_https_in.id
  description = "HTTPS all in"
}

output "sg_restricted_http_in_id" {
  value       = aws_security_group.restricted_http_in.id
  description = "Restricted HTTP"
}

output "sg_restricted_https_in_id" {
  value       = aws_security_group.restricted_https_in.id
  description = "Restricted HTTPS"
}

output "sg_efs_private_in_id" {
  value       = aws_security_group.efs_private_in.id
  description = "EFS in"
}

output "nat_gateway_ip1" {
  value       = local.nat_gateway_ip1
  description = "NAT gateway IP 1"
}

output "nat_gateway_ip2" {
  value       = local.nat_gateway_ip2
  description = "NAT gateway IP 2"
}