# ------------------
# | Load balancers |
# ------------------

resource "aws_s3_bucket" "lb_logs" {
  bucket = "${var.project}-lb-logs-bucket"
  acl    = "private"

  tags = {
    Name      = "${var.project}-lb-logs-bucket"
    Terraform = true
  }
}


##
# EXTERNAL Load Balancer
##

resource "aws_alb" "alb_external" {
  name            = "alb-external"
  internal        = false
  security_groups = var.external_lb_sg_ids
  subnets         = [var.public_subnet_id, var.public2_subnet_id]

  # Deletion production should be true in production environment
  enable_deletion_protection = false

  # Enable access logging for production usage
  access_logs {
    bucket  = aws_s3_bucket.lb_logs.bucket
    prefix  = "lb"
    enabled = var.lb_access_logs_enabled
  }

  tags = {
    Name      = "alb-external"
    Role      = "Load balancer for incoming external HTTP traffic"
    Terraform = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_alb_target_group" "alb_tg_external" {
  name     = "alb-tg-external"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    matcher = "200"
    path    = "/health_check_varnish"
  }

  tags = {
    Name      = "alb-external-target-group"
    Role      = "External target group"
    Terraform = true
  }
}

resource "aws_alb_listener" "alb_listener_http" {
  load_balancer_arn = aws_alb.alb_external.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.alb_tg_external.arn
    type             = "forward"
  }

  tags = {
    Name      = "alb-http-listener"
    Role      = "ALB HTTP listener"
    Terraform = true
  }
}

# HTTPS listener 

resource "aws_alb_listener" "alb_listener_https" {
  count             = var.cert_arn ? 1 : 0
  load_balancer_arn = aws_alb.alb_external.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.cert_arn

  default_action {
    target_group_arn = aws_alb_target_group.alb_tg_external.arn
    type             = "forward"
  }

  tags = {
    Name      = "alb-https-listener"
    Role      = "ALB HTTPS listener"
    Terraform = true
  }
}


###
# INTERNAL Load Balancer
###

resource "aws_alb" "alb_internal" {
  name            = "alb-internal"
  internal        = true
  security_groups = [ var.sg_allow_all_out_id,
                      var.sg_bastion_http_in_id,
                      aws_security_group.internal_http_in.id,
                      aws_security_group.internal_ssh_in.id,
                      aws_security_group.internal_ssh_out.id
                    ]
  subnets = [var.private_subnet_id,var.private2_subnet_id]

  # Deletion production should be true in production environment if we don't automatically generate varnish VCL
  enable_deletion_protection = false

  tags = {
    Name        = "alb-internal"
    Description = "Load balancer for incoming internal HTTP traffic"
    Terraform   = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_alb_target_group" "alb_tg_internal" {
  name     = "alb-tg-internal"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    timeout  = "3"
    interval = "5"
    matcher  = "200"
    path     = "/health_check.php"
  }

  tags = {
    Name      = "alb-internal-target-group"
    Role      = "Internal target group"
    Terraform = true
  }
}

resource "aws_alb_listener" "alb_internal_listener_http" {
  load_balancer_arn = aws_alb.alb_internal.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.alb_tg_internal.arn
    type             = "forward"
  }

  tags = {
    Name      = "alb-internal-http-listener"
    Role      = "Internal HTTP listener"
    Terraform = true
  }

}

##
# ALB redirection rules
##

# Always redirect HTTP to HTTPS

resource "aws_lb_listener_rule" "ext_listener_http_to_https" {
  count        = var.cert_arn ? 1 : 0
  listener_arn = aws_alb_listener.alb_listener_http.arn

  action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }

  tags = {
    Name      = "external-http-to-https"
    Role      = "External listener for http to https redirection"
    Terraform = true
  }
}

## 
# Auto scaling groups 
##

# Magento ASG
resource "aws_autoscaling_group" "magento" {
  name              = "magento-asg-${aws_launch_template.magento_launch_template.name}"
  min_size          = var.magento_autoscale_min
  max_size          = var.magento_autoscale_max
  desired_capacity  = var.magento_autoscale_desired
  health_check_type = "EC2"
  launch_template {
    id         = "${aws_launch_template.magento_launch_template.id}"
    version = "${aws_launch_template.magento_launch_template.latest_version}"
  }
  vpc_zone_identifier  = [var.private_subnet_id, var.private2_subnet_id]
  termination_policies = ["NewestInstance"]

  tag {
    key                 = "Name"
    value               = "magento-web-node"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      load_balancers,
      target_group_arns
    ]
  }
}

resource "aws_autoscaling_policy" "autoscaling_magento_up" {
  name                   = "autoscaling_up"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.magento.name
}

resource "aws_autoscaling_policy" "autoscaling_magento_down" {
  name                   = "autoscaling_down"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.magento.name
}

resource "aws_cloudwatch_metric_alarm" "cloudwatch_magento_cpu_high" {
  alarm_name          = "cloudwatch_magento_cpu_high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "90"
  alarm_description   = "Magento CPU over 90%"
  alarm_actions = [
    "${aws_autoscaling_policy.autoscaling_magento_up.arn}"
  ]
  dimensions = {
    AutoScalingGroupName = "${aws_autoscaling_group.magento.name}"
  }
}

resource "aws_cloudwatch_metric_alarm" "cloudwatch_magento_cpu_low" {
  alarm_name          = "cloudwatch_magento_cpu_low"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "70"
  alarm_description   = "Magento CPU under 70%"
  alarm_actions = [
    "${aws_autoscaling_policy.autoscaling_magento_down.arn}"
  ]
  dimensions = {
    AutoScalingGroupName = "${aws_autoscaling_group.magento.name}"
  }
}

# Varnish ASG
resource "aws_autoscaling_group" "varnish" {
  name              = "varnish-asg-${aws_launch_template.varnish_launch_template.name}"
  min_size          = var.varnish_autoscale_min
  max_size          = var.varnish_autoscale_max
  desired_capacity  = var.varnish_autoscale_desired
  health_check_type = "EC2"
  launch_template {
    id         = "${aws_launch_template.varnish_launch_template.id}"
    version = "${aws_launch_template.varnish_launch_template.latest_version}"
  }
  vpc_zone_identifier = [var.private_subnet_id, var.private2_subnet_id]

  tag {
    key                 = "Name"
    value               = "varnish-node"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      load_balancers,
      target_group_arns
    ]
  }
}

##
# Launch configurations
##

# Magento cfg
locals{
  magento_userdata = <<EOF
#!/bin/bash
sleep $[ ( $RANDOM % 10 )  + 1 ]s
sudo -u admin crontab -r
sudo su - magento -c "/opt/ec2_install/scripts/magento-setup.sh"
  EOF

# Varnish cfg
varnish_userdata=<<EOF
#!/bin/bash
sudo -u admin crontab -r
sed -i "s/DNS_RESOLVER/${cidrhost(var.vpc_cidr, "2")}/g" /etc/nginx/conf.d/varnish.conf
sed -i "s/MAGENTO_INTERNAL_ALB/${aws_alb.alb_internal.dns_name}/g" /etc/nginx/conf.d/varnish.conf
sed -i "s/MAGENTO_INTERNAL_ALB/${aws_alb.alb_internal.dns_name}/g" /etc/varnish/backends.vcl
systemctl start nginx
systemctl restart varnish
  EOF

}

resource "aws_launch_template" "magento_launch_template" {
  name_prefix   = "magento-web-"
  image_id      = var.magento_ami
  instance_type = var.ec2_instance_type_magento
  iam_instance_profile {
    name = aws_iam_instance_profile.magento_host_profile.id
  }
  key_name = var.ssh_key_pair_name

  network_interfaces {
    associate_public_ip_address = false
    security_groups = [
      var.sg_allow_all_out_id,
      var.sg_bastion_ssh_in_id,
      aws_security_group.internal_http_in.id,
      aws_security_group.internal_ssh_in.id,
      aws_security_group.internal_ssh_out.id
    ]
  }

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 20
      encrypted = true
    }
  }


  user_data = "${base64encode(local.magento_userdata)}"

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    aws_cloudfront_distribution.alb_distribution
  ]
}

resource "aws_autoscaling_attachment" "asg_attachment_magento_alb" {
  autoscaling_group_name = aws_autoscaling_group.magento.id
  alb_target_group_arn   = aws_alb_target_group.alb_tg_internal.arn
}



resource "aws_launch_template" "varnish_launch_template" {
  name_prefix   = "varnish-"
  image_id      = var.varnish_ami
  instance_type = var.ec2_instance_type_varnish
  key_name      = var.ssh_key_pair_name

  network_interfaces {
    associate_public_ip_address = true
    security_groups = [
      aws_security_group.internal_http_in.id,
      aws_security_group.internal_ssh_in.id,
      aws_security_group.internal_ssh_out.id,
      var.sg_bastion_ssh_in_id,
      var.sg_allow_all_out_id
    ]
  }

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 20
      encrypted = true
    }
  }

  user_data = "${base64encode(local.varnish_userdata)}"

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    aws_cloudfront_distribution.alb_distribution
  ]
}

resource "aws_autoscaling_attachment" "asg_attachment_varnish_alb" {
  autoscaling_group_name = aws_autoscaling_group.varnish.id
  alb_target_group_arn   = aws_alb_target_group.alb_tg_external.arn
}

resource "aws_ssm_parameter" "magento_autoscale_name" {
  name  = "/magento_autoscale_name"
  type  = "String"
  value = "${aws_launch_template.magento_launch_template.name}"
  tags = {
    Terraform = true
  }
}