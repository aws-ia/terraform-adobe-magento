resource "aws_route53_zone" "project_zone" {
  count   = var.domain_name != null ? 1 : 0
  name    = var.domain_name
  comment = "DNS Zone ${var.domain_name}"
  tags = {
    Terraform = "true"
  }
}
