output "varnish_ami_id" {
  description = "Varnish AMI ID"
  value       = aws_ami_from_instance.varnish_ami.id
}