
resource "aws_security_group" "varnish_ami_ssh_in" {
  name        = "varnish_ami_ssh_in"
  description = "Allow incoming connections to the Varnish AMI creation host"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  vpc_id = var.vpc_id

  tags = {
    Name      = "varnish_ami_ssh_in"
    Terraform = "true"
  }

  lifecycle {
    create_before_destroy = true
  }
}