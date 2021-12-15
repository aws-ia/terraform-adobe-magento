output "varnish_ami_id" {
  value = aws_ami_from_instance.varnish_ami.id
}