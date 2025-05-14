##########################
#         LOCALS         #
##########################
locals {
  environmental_name = trim(var.environment) != "" ? "${var.environment}-${var.service_name}" : var.service_name
  log_group_name     = trim(var.environment) != "" ? "/logs/ecs/${var.environment}/${var.service_name}" : "/logs/ecs/${var.service_name}"
  ecr_repo_name      = element(split("/", var.ecr_repo_arn), length(split("/", var.ecr_repo_arn)) - 1)
  cluster_id         = var.existing_ecs_cluster_id != "" ? var.existing_ecs_cluster_id : aws_ecs_cluster.ecs_cluster[0].id
}
