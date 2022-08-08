data "aws_iam_instance_profile" "bastion_host_profile" {
  name = "BastionHostProfile"
}

## 
# Auto scaling groups 
##

resource "aws_autoscaling_group" "bastion" {
  name                 = "bastion-asg-${aws_launch_configuration.bastion_launch_cfg.name}"
  min_size             = var.bastion_autoscale_min
  max_size             = var.bastion_autoscale_max
  desired_capacity     = var.bastion_autoscale_desired
  health_check_type    = "EC2"
  launch_configuration = aws_launch_configuration.bastion_launch_cfg.name
  vpc_zone_identifier  = [local.public_subnet_id, local.public2_subnet_id]

  tag {
    key                 = "Name"
    value               = "bastion-host"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      target_group_arns
    ]
  }
}

#tfsec:ignore:aws-ec2-enforce-launch-config-http-token-imds
resource "aws_launch_configuration" "bastion_launch_cfg" {
  name_prefix                 = "bastion-host-"
  image_id                    = var.base_ami_id
  security_groups             = [aws_security_group.management_bastion_ssh_in.id, aws_security_group.allow_all_out.id]
  instance_type               = var.ec2_instance_type_bastion
  iam_instance_profile        = data.aws_iam_instance_profile.bastion_host_profile.name
  associate_public_ip_address = true #tfsec:ignore:aws-ec2-no-public-ip
  key_name                    = var.ssh_key_pair_name
  root_block_device {
    encrypted = true
  }

  lifecycle {
    create_before_destroy = true
  }
}