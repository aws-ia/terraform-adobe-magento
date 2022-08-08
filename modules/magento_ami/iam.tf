# ------------------
# | IAM Policies   |
# ------------------

# Allow Magento hosts to fetch EC2 tags

resource "aws_iam_role" "magento_ami_host_role" {
  name               = "MagentoAMIHostRole"
  assume_role_policy = file("${path.module}/iam_policies/magento-ami-host-role.json")
}

resource "aws_iam_role_policy" "magento_ami_instance_role_policy" {
  name   = "MagentoAMIHostPolicy"
  policy = file("${path.module}/iam_policies/magento-ami-iam-policy.json")
  role   = aws_iam_role.magento_ami_host_role.id
}

resource "aws_iam_instance_profile" "magento_ami_host_profile" {
  name = "MagentoAMIHostProfile"
  role = aws_iam_role.magento_ami_host_role.name
}


