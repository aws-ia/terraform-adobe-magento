resource "aws_ses_email_identity" "ses_email" {
  email = var.magento_admin_email
}

