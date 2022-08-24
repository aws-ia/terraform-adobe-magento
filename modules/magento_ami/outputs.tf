output "magento_ami_id" {
  description = "Magento AMI ID"
  value       = aws_ami_from_instance.magento_ami.id
}