##########################
#   CLOUDWATCH RESOURCES #
##########################
resource "aws_cloudwatch_log_group" "logs" {
  name              = local.log_group_name
  retention_in_days = 14
}
