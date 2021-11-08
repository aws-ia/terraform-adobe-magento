# Cloudfront distribution for main s3 site.
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

  enabled             = true
  is_ipv6_enabled     = true
  price_class = "PriceClass_100" # Use only North America and Europe

  #custom_error_response {
  #  error_caching_min_ttl = 0
  #  error_code            = 404
  #  response_code         = 200
  #  response_page_path    = "/404.html"
  #}

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
#    min_ttl                = 31536000
#    default_ttl            = 31536000
#    max_ttl                = 31536000
    compress               = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  web_acl_id = var.acl_id

  # UNCOMMENT TO REGISTER CUSTOM DOMAIN

//  aliases = [var.domain_name]
//
//  viewer_certificate {
//    acm_certificate_arn      = aws_acm_certificate_validation.cert_validation.certificate_arn
//    ssl_support_method       = "sni-only"
//    minimum_protocol_version = "TLSv1.1_2016"
//  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  tags = {
      Terraform   = "true"
  }
}

resource "aws_ssm_parameter" "cloudfront_domain" {
  name  = "/cloudfront_domain"
  type  = "String"
  value = "${aws_cloudfront_distribution.alb_distribution.domain_name}"
  tags = {
    Terraform = true
  }
}