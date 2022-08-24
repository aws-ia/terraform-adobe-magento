<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 3.66.0 |
| <a name="requirement_awscc"></a> [awscc](#requirement\_awscc) | ~> 0.8.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 3.66.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_account"></a> [account](#module\_account) | ./modules/account | n/a |
| <a name="module_acm"></a> [acm](#module\_acm) | ./modules/acm | n/a |
| <a name="module_base"></a> [base](#module\_base) | ./modules/base | n/a |
| <a name="module_magento"></a> [magento](#module\_magento) | ./modules/magento | n/a |
| <a name="module_magento_ami"></a> [magento\_ami](#module\_magento\_ami) | ./modules/magento_ami | n/a |
| <a name="module_services"></a> [services](#module\_services) | ./modules/services | n/a |
| <a name="module_ssm"></a> [ssm](#module\_ssm) | ./modules/ssm | n/a |
| <a name="module_varnish_ami"></a> [varnish\_ami](#module\_varnish\_ami) | ./modules/varnish_ami | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_ami.selected](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_base_ami_os"></a> [base\_ami\_os](#input\_base\_ami\_os) | OS for base AMI | `string` | n/a | yes |
| <a name="input_create_vpc"></a> [create\_vpc](#input\_create\_vpc) | Create VPC or not | `bool` | n/a | yes |
| <a name="input_elasticsearch_domain"></a> [elasticsearch\_domain](#input\_elasticsearch\_domain) | ElasticSearch domain | `string` | n/a | yes |
| <a name="input_mage_composer_password"></a> [mage\_composer\_password](#input\_mage\_composer\_password) | Magento auth.json password | `string` | n/a | yes |
| <a name="input_mage_composer_username"></a> [mage\_composer\_username](#input\_mage\_composer\_username) | Magento auth.json username | `string` | n/a | yes |
| <a name="input_magento_admin_email"></a> [magento\_admin\_email](#input\_magento\_admin\_email) | Email address for Magento admin. | `string` | n/a | yes |
| <a name="input_magento_admin_firstname"></a> [magento\_admin\_firstname](#input\_magento\_admin\_firstname) | Firstname for Magento admin. | `string` | n/a | yes |
| <a name="input_magento_admin_lastname"></a> [magento\_admin\_lastname](#input\_magento\_admin\_lastname) | Lastname for Magento admin. | `string` | n/a | yes |
| <a name="input_magento_admin_password"></a> [magento\_admin\_password](#input\_magento\_admin\_password) | Password for Magento admin. | `string` | n/a | yes |
| <a name="input_magento_admin_username"></a> [magento\_admin\_username](#input\_magento\_admin\_username) | Username for Magento admin. | `string` | n/a | yes |
| <a name="input_magento_database_password"></a> [magento\_database\_password](#input\_magento\_database\_password) | Password for Magento DB. | `string` | n/a | yes |
| <a name="input_management_addresses"></a> [management\_addresses](#input\_management\_addresses) | Whitelisted IP addresses for e.g. Security Groups | `list(string)` | n/a | yes |
| <a name="input_profile"></a> [profile](#input\_profile) | AWS profile | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | Name of the project. | `string` | n/a | yes |
| <a name="input_rabbitmq_username"></a> [rabbitmq\_username](#input\_rabbitmq\_username) | Username for RabbitMQ | `string` | n/a | yes |
| <a name="input_ssh_key_name"></a> [ssh\_key\_name](#input\_ssh\_key\_name) | SSH key name | `string` | n/a | yes |
| <a name="input_ssh_key_pair_name"></a> [ssh\_key\_pair\_name](#input\_ssh\_key\_pair\_name) | SSH keypair name | `string` | n/a | yes |
| <a name="input_ssh_username"></a> [ssh\_username](#input\_ssh\_username) | SSH username | `string` | n/a | yes |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | VPC CIDR | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID | `string` | n/a | yes |
| <a name="input_vpc_private2_subnet_id"></a> [vpc\_private2\_subnet\_id](#input\_vpc\_private2\_subnet\_id) | VPC private subnet 1 | `string` | n/a | yes |
| <a name="input_vpc_private_subnet_id"></a> [vpc\_private\_subnet\_id](#input\_vpc\_private\_subnet\_id) | VPC private subnet 1 | `string` | n/a | yes |
| <a name="input_vpc_public2_subnet_id"></a> [vpc\_public2\_subnet\_id](#input\_vpc\_public2\_subnet\_id) | VPC public subnet 1 | `string` | n/a | yes |
| <a name="input_vpc_public_subnet_id"></a> [vpc\_public\_subnet\_id](#input\_vpc\_public\_subnet\_id) | VPC public subnet 1 | `string` | n/a | yes |
| <a name="input_vpc_rds_subnet2_id"></a> [vpc\_rds\_subnet2\_id](#input\_vpc\_rds\_subnet2\_id) | RDS private subnet 2 | `string` | n/a | yes |
| <a name="input_vpc_rds_subnet_id"></a> [vpc\_rds\_subnet\_id](#input\_vpc\_rds\_subnet\_id) | RDS private subnet 1 | `string` | n/a | yes |
| <a name="input_az1"></a> [az1](#input\_az1) | AZ 1 | `string` | `"us-east-1a"` | no |
| <a name="input_az2"></a> [az2](#input\_az2) | AZ 2 | `string` | `"us-east-1b"` | no |
| <a name="input_cert"></a> [cert](#input\_cert) | TLS certificate | `string` | `false` | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Add domain name for the project. | `string` | `null` | no |
| <a name="input_lb_access_logs_enabled"></a> [lb\_access\_logs\_enabled](#input\_lb\_access\_logs\_enabled) | Enable load balancer accesslogs to s3 bucket | `bool` | `false` | no |
| <a name="input_magento_db_allocated_storage"></a> [magento\_db\_allocated\_storage](#input\_magento\_db\_allocated\_storage) | DB allocated storage space | `number` | `60` | no |
| <a name="input_magento_db_backup_retention_period"></a> [magento\_db\_backup\_retention\_period](#input\_magento\_db\_backup\_retention\_period) | Backup retention period for DB | `number` | `3` | no |
| <a name="input_magento_db_performance_insights_enabled"></a> [magento\_db\_performance\_insights\_enabled](#input\_magento\_db\_performance\_insights\_enabled) | DB performance insights | `bool` | `true` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region | `string` | `"us-east-1"` | no |
| <a name="input_skip_rds_snapshot_on_destroy"></a> [skip\_rds\_snapshot\_on\_destroy](#input\_skip\_rds\_snapshot\_on\_destroy) | Take a final snapshot on RDS destroy? | `bool` | `false` | no |
| <a name="input_use_aurora"></a> [use\_aurora](#input\_use\_aurora) | Use Aurora or RDS | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alb_external_dns_name"></a> [alb\_external\_dns\_name](#output\_alb\_external\_dns\_name) | ALB DNS hostname |
| <a name="output_magento_admin_email"></a> [magento\_admin\_email](#output\_magento\_admin\_email) | Magento admin email address |
| <a name="output_magento_admin_password"></a> [magento\_admin\_password](#output\_magento\_admin\_password) | Magento admin password |
| <a name="output_magento_admin_url"></a> [magento\_admin\_url](#output\_magento\_admin\_url) | Magento admin URL |
| <a name="output_magento_cache_host"></a> [magento\_cache\_host](#output\_magento\_cache\_host) | Magento cache hostname |
| <a name="output_magento_database_host"></a> [magento\_database\_host](#output\_magento\_database\_host) | Magento DB hostname |
| <a name="output_magento_elasticsearch_host"></a> [magento\_elasticsearch\_host](#output\_magento\_elasticsearch\_host) | Magento ES hostname |
| <a name="output_magento_files_s3"></a> [magento\_files\_s3](#output\_magento\_files\_s3) | Magento files S3 |
| <a name="output_magento_frontend_url"></a> [magento\_frontend\_url](#output\_magento\_frontend\_url) | Magento frontend URL |
| <a name="output_magento_rabbitmq_host"></a> [magento\_rabbitmq\_host](#output\_magento\_rabbitmq\_host) | Magento rabbitmq hostname |
| <a name="output_magento_session_host"></a> [magento\_session\_host](#output\_magento\_session\_host) | Magento session hostname |
<!-- END_TF_DOCS -->