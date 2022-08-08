#tfsec:ignore:aws-cloudwatch-log-group-customer-key
resource "aws_cloudwatch_log_group" "magento_exception_log" {
  name              = "/magento-exception-log"
  retention_in_days = "90"

  tags = {
    Application = "magento"
    Terraform   = true
  }
}

#tfsec:ignore:aws-cloudwatch-log-group-customer-key
resource "aws_cloudwatch_log_group" "magento_system_log" {
  name              = "/magento-system-log"
  retention_in_days = "90"

  tags = {
    Application = "magento"
    Terraform   = true
  }
}

#tfsec:ignore:aws-cloudwatch-log-group-customer-key
resource "aws_cloudwatch_log_group" "magento_debug_log" {
  name              = "/magento-debug-log"
  retention_in_days = "90"

  tags = {
    Application = "magento"
    Terraform   = true
  }
}

#tfsec:ignore:aws-cloudwatch-log-group-customer-key
resource "aws_cloudwatch_log_group" "magento_cron_log" {
  name              = "/magento-cron-log"
  retention_in_days = "90"

  tags = {
    Application = "magento"
    Terraform   = true
  }
}
