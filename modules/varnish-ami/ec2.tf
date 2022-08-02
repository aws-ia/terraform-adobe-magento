data "aws_secretsmanager_secret" "ssh-key" {
  name = var.ssh_key_name
}

data "aws_secretsmanager_secret_version" "ssh-key" {
  secret_id = data.aws_secretsmanager_secret.ssh-key.id
}


resource "aws_instance" "varnish_instance" {
  ami           = var.base_ami_id
  instance_type = "t3.medium"
  key_name      = var.ssh_key_pair_name
  subnet_id     = var.public_subnet_id
  #user_data     = data.template_file.user_data.rendered
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.varnish_ami_ssh_in.id, var.sg_allow_all_out_id]
  #iam_instance_profile = aws_iam_instance_profile.magento_ami_host_profile.id

  provisioner "file" {
    source      = "${path.module}/scripts/ec2_install"
    destination = "/tmp/"


    connection {
      type        = "ssh"
      host        = self.public_ip
      user        = var.ssh_username
      private_key = data.aws_secretsmanager_secret_version.ssh-key.secret_string
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/ec2_install/scripts/*.sh",
      "/tmp/ec2_install/scripts/install_stack_varnish.sh",
    ]

    connection {
      type        = "ssh"
      host        = self.public_ip
      user        = var.ssh_username
      private_key = data.aws_secretsmanager_secret_version.ssh-key.secret_string
    }

  }

  tags = {
    Name = "varnish-ami-instance"
  }

  metadata_options {
    http_tokens = "required"
  }
}

resource "random_pet" "ami" {
  keepers = {
    # Generate a new pet name each time we switch to a new AMI id
    ami_id = aws_instance.varnish_instance.id
  }
}


resource "aws_ami_from_instance" "varnish_ami" {
  name               = "varnish-ami-${random_pet.ami.id}"
  source_instance_id = aws_instance.varnish_instance.id
  depends_on = [
    aws_instance.varnish_instance
  ]
}