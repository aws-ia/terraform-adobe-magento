output "route53_zone_id" {
  value       = aws_route53_zone.project_zone[0].id
  description = "R53 zone ID"
}