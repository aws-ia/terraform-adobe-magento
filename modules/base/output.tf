###
# Network
###
output "vpc_id" {
  value = local.vpc_id
}

output "subnet_private_id" {
  value = local.private_subnet_id
}

output "subnet_public_id" {
  value = local.public_subnet_id
}

output "subnet_private2_id" {
  value = local.private2_subnet_id
}

output "subnet_public2_id" {
  value = local.public2_subnet_id
}

output "rds_subnet_id" {
  value = local.rds_subnet_id
}

output "rds_subnet2_id" {
  value = local.rds_subnet2_id
}

###
# Security Groups
###
output "sg_allow_all_out_id" {
  value = aws_security_group.allow_all_out.id
}

output "sg_bastion_ssh_in_id" {
  value = aws_security_group.from_bastion_ssh_in.id
}

output "sg_bastion_http_in_id" {
  value = aws_security_group.from_bastion_http_in.id
}

output "sg_all_http_in_id" {
  value = aws_security_group.all_http_in.id
}

output "sg_all_https_in_id" {
  value = aws_security_group.all_https_in.id
}

output "sg_restricted_http_in_id" {
  value = aws_security_group.restricted_http_in.id
}

output "sg_restricted_https_in_id" {
  value = aws_security_group.restricted_https_in.id
}

output "sg_efs_private_in_id" {
  value = aws_security_group.efs_private_in.id
}

output "nat_gateway_ip1" {
  value = local.nat_gateway_ip1
}

output "nat_gateway_ip2" {
  value = local.nat_gateway_ip2
}