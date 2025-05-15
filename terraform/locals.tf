##########################
#         LOCALS         #
##########################
locals {
  # Constructs a consistent name used for resources (e.g., ECS service, IAM roles)
  # If an environment is provided, it becomes "env-service", otherwise just "service"
  environmental_name = trim(var.environment) != "" ? "${var.environment}-${var.service_name}" : var.service_name

  # Builds the CloudWatch Logs group path based on environment + service name
  # If environment is set: "/logs/ecs/env/service", else: "/logs/ecs/service"
  log_group_name = trim(var.environment) != "" ? "/logs/ecs/${var.environment}/${var.service_name}" : "/logs/ecs/${var.service_name}"

  # Resolves the ECS cluster ID to use
  # If an existing cluster ID was provided as input, use that; otherwise, reference the cluster created in this module
  cluster_id = var.existing_ecs_cluster_id != "" ? var.existing_ecs_cluster_id : aws_ecs_cluster.ecs_cluster[0].id
}
