output "alb_external_dns_name" {
  value       = aws_alb.alb_external.dns_name
  description = "alb_external_dns_name"
}

output "cloudfront_distribution_url" {
  value       = aws_cloudfront_distribution.alb_distribution.domain_name
  description = "cloudfront_distribution_url"
}

output "magento_files_s3" {
  value       = aws_s3_bucket.magento_files.bucket_domain_name
  description = "magento_files_s3"
}
