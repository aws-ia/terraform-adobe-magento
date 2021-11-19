data "aws_secretsmanager_secret" "ssh-key" {
  name = var.ssh_key_name
}

data "aws_secretsmanager_secret_version" "ssh-key" {
  secret_id = data.aws_secretsmanager_secret.ssh-key.id
}


resource "aws_instance" "magento_instance" {
  ami                         = var.base_ami_id
  instance_type               = "t3.medium"
  key_name                    = var.ssh_key_pair_name
  subnet_id                   = var.public_subnet_id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.management_ssh_in.id, var.sg_allow_all_out_id]
  iam_instance_profile        = aws_iam_instance_profile.magento_ami_host_profile.id

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
      "sed -i \"s/MAGE_COMPOSER_USERNAME/${var.mage_composer_username}/g\" /tmp/ec2_install/configs/auth.json",
      "sed -i \"s/MAGE_COMPOSER_PASSWORD/${var.mage_composer_password}/g\" /tmp/ec2_install/configs/auth.json",
      "chmod +x /tmp/ec2_install/scripts/*.sh",
      "/tmp/ec2_install/scripts/install_stack.sh",
    ]

    connection {
      type        = "ssh"
      host        = self.public_ip
      user        = var.ssh_username
      private_key = data.aws_secretsmanager_secret_version.ssh-key.secret_string
    }

  }


  tags = {
    Name        = "magento-ami-instance"
    Description = "EC2 for creating the Magento AMI"
    Terraform   = true
  }
}

resource "random_pet" "ami" {
  keepers = {
    # Generate a new pet name each time we switch to a new AMI id
    ami_id = aws_instance.magento_instance.id
  }
}


resource "aws_ami_from_instance" "magento_ami" {
  name               = "magento-ami-${random_pet.ami.id}"
  source_instance_id = aws_instance.magento_instance.id
  depends_on = [
    aws_instance.magento_instance
  ]
}