# -------------------
# | ElasticSearch    |
# -------------------
data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

resource "aws_elasticsearch_domain" "es" {
  domain_name           = var.elasticsearch_domain
  elasticsearch_version = var.es_version

  cluster_config {
    instance_count         = 2
    instance_type          = var.es_instance_type
    zone_awareness_enabled = true
  }

  vpc_options {
    subnet_ids = [
      var.private_subnet_id,
      var.private2_subnet_id,
    ]

    security_group_ids = [
      var.sg_bastion_ssh_in_id,
      var.sg_allow_all_out_id,
      aws_security_group.internal_es_http_in.id
    ]
  }

  encrypt_at_rest {
    enabled = true
  }

  node_to_node_encryption {
    enabled = true
  }

  ebs_options {
    ebs_enabled = true
    volume_size = 10
  }

  advanced_options = {
    "rest.action.multi.allow_explicit_index" = "true",
    override_main_response_version           = false
  }

  access_policies = <<CONFIG
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowES",
            "Action": "es:*",
            "Principal": "*",
            "Effect": "Allow",
            "Resource": "arn:aws:es:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:domain/${var.elasticsearch_domain}/*"
        }
    ]
}
CONFIG

  tags = {
    Domain    = var.elasticsearch_domain
    Terraform = true
  }

  depends_on = [aws_iam_service_linked_role.es]

  lifecycle {
    ignore_changes = [
      tags,
      tags_all
    ]
  }
}