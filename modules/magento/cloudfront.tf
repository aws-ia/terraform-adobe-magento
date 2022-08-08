# Cloudfront distribution for main s3 site.
#tfsec:ignore:aws-cloudfront-enable-logging
resource "aws_cloudfront_distribution" "alb_distribution" {
  origin {
    domain_name = aws_alb.alb_external.dns_name
    origin_id   = aws_alb.alb_external.dns_name

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  enabled         = true
  is_ipv6_enabled = false
  price_class     = "PriceClass_100" # Use only North America and Europe

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "PUT", "POST", "PATCH", "OPTIONS", "DELETE"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_alb.alb_external.dns_name

    forwarded_values {
      query_string = true
      headers      = ["Host", "Accept", "Origin"]

      cookies {
        forward = "all"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    compress               = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  web_acl_id = var.acl_id

  viewer_certificate {
    cloudfront_default_certificate = true
    minimum_protocol_version       = "TLSv1.2_2021"
  }

  tags = {
    Terraform = "true"
  }
}

resource "aws_ssm_parameter" "cloudfront_domain" {
  name  = "/cloudfront_domain"
  type  = "String"
  value = aws_cloudfront_distribution.alb_distribution.domain_name
  tags = {
    Terraform = true
  }
}