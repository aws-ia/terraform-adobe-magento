#tfsec:ignore:aws-s3-block-public-acls tfsec:ignore:aws-s3-block-public-policy tfsec:ignore:aws-s3-enable-bucket-encryption tfsec:ignore:aws-s3-ignore-public-acls tfsec:ignore:aws-s3-no-public-buckets tfsec:ignore:aws-s3-encryption-customer-key tfsec:ignore:aws-s3-enable-bucket-logging tfsec:ignore:aws-s3-specify-public-access-block
resource "aws_s3_bucket" "magento_files" {
  bucket_prefix = "${var.project}-magento-files-"
  acl           = "private"
  force_destroy = true

  versioning {
    enabled = true
  }

  tags = {
    Name        = "Magento Files"
    Description = "S3 bucket for Magento"
    Terraform   = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}


resource "aws_s3_bucket_policy" "magento_files" {
  bucket = aws_s3_bucket.magento_files.id

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowEC2toS3",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:*",
            "Resource": "arn:aws:s3:::${aws_s3_bucket.magento_files.bucket}/*",
            "Condition": {
                "IpAddress": {
                    "aws:SourceIp": [
                        "${var.nat_gateway_ip1}",
                        "${var.nat_gateway_ip2}"
                    ]
                }
            }
        }
    ]
}
POLICY
}


resource "aws_ssm_parameter" "magento_files_s3" {
  name  = "/magento_files_s3"
  type  = "String"
  value = aws_s3_bucket.magento_files.id
  tags = {
    Terraform = true
  }
}
