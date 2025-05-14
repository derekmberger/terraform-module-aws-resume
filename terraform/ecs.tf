##########################
#       ECS CLUSTER      #
##########################
resource "aws_ecs_cluster" "ecs_cluster" {
  count = var.existing_ecs_cluster_id == "" ? 1 : 0

  name = var.ecs_cluster_name != "" ? var.ecs_cluster_name : "${local.environmental_name}-ecs-fargate"
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_cluster_capacity_providers" "cluster_capacity" {
  count = var.existing_ecs_cluster_id == "" ? 1 : 0

  cluster_name       = aws_ecs_cluster.ecs_cluster[0].name
  capacity_providers = ["FARGATE", "FARGATE_SPOT"]
}

##########################
#    TASK DEFINITION     #
##########################
resource "aws_ecs_task_definition" "task_def" {
  family                   = local.environmental_name
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.ecs_service_cpu
  memory                   = var.ecs_service_memory
  task_role_arn            = aws_iam_role.task_role.arn
  execution_role_arn       = aws_iam_role.ecs_exec.arn

  container_definitions = jsonencode([{
    name      = var.service_name
    image     = "${var.ecr_repo_url}:${var.ecr_image_tag}" #The tag deployed could be managed in a variety of ways. Variable Input, SSM Param, Terraform Module Constant, etc
    command   = ["/bin/sh", "-c", "npx next start -p 3000"]
    essential = true
    portMappings = [{
      containerPort = 3000
      protocol      = "tcp"
    }]
    linuxParameters = {
      initProcessEnabled = true
    }
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-create-group  = "true"
        awslogs-group         = aws_cloudwatch_log_group.logs.name
        awslogs-region        = var.aws_region
        awslogs-stream-prefix = "ecs"
      }
    }
  }])
}

##########################
#        SERVICE         #
##########################
resource "aws_ecs_service" "service" {
  name                               = local.environmental_name
  cluster                            = local.cluster_id
  task_definition                    = aws_ecs_task_definition.task_def.arn
  desired_count                      = var.desired_count
  deployment_maximum_percent         = var.deployment_maximum_percent
  deployment_minimum_healthy_percent = var.deployment_minimum_healthy_percent
  platform_version                   = "1.4.0"
  launch_type                        = "FARGATE"
  propagate_tags                     = "SERVICE"
  enable_ecs_managed_tags            = true
  health_check_grace_period_seconds  = 5
  enable_execute_command             = true

  network_configuration {
    security_groups = [aws_security_group.service.id]
    subnets         = var.subnet_ids
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.tg.arn
    container_name   = var.service_name
    container_port   = 3000
  }

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  deployment_controller {
    type = "ECS"
  }

  lifecycle {
    ignore_changes = [task_definition, desired_count]
  }

  depends_on = [aws_alb_target_group.tg]
}
