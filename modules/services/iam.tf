##
# ElasticSearch
##
resource "aws_iam_service_linked_role" "es" {
  aws_service_name = "es.amazonaws.com"
}