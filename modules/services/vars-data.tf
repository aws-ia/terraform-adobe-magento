# Variables discovered using input variables

data "aws_subnet" "private_subnet" {
  id = var.private_subnet_id
}

data "aws_subnet" "private2_subnet" {
  id = var.private2_subnet_id
}

data "aws_subnet" "public_subnet" {
  id = var.public_subnet_id
}

data "aws_subnet" "public2_subnet" {
  id = var.public2_subnet_id
}

#data "aws_instance" "bastion" {
#  instance_id = var.bastion_instance_id.0
#}

#data "aws_instance" "bastion2" {
#  instance_id = var.bastion_instance_id.1
#}
