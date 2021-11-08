resource "aws_cloudwatch_log_group" "magento-exception-log" {
  name = "/magento-exception-log"
  retention_in_days = "90"

  tags = {
    Application = "magento"
  }
}

resource "aws_cloudwatch_log_group" "magento-system-log" {
  name = "/magento-system-log"
  retention_in_days = "90"

  tags = {
    Application = "magento"
  }
}

resource "aws_cloudwatch_log_group" "magento-debug-log" {
  name = "/magento-debug-log"
  retention_in_days = "90"

  tags = {
    Application = "magento"
  }
}

resource "aws_cloudwatch_log_group" "magento-cron-log" {
  name = "/magento-cron-log"
  retention_in_days = "90"

  tags = {
    Application = "magento"
  }
}
