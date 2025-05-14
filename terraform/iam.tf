#########################
#     IAM RESOURCES     #
#########################
resource "aws_iam_role" "ecs_exec" {
  name                 = "${local.environmental_name}-ecs-exec"
  path                 = "/"
  max_session_duration = 3600
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "TaskAssume"
        Effect    = "Allow"
        Principal = { Service = "ecs-tasks.amazonaws.com" }
        Action    = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "ecr_policy_ecs_exec" {
  name = "ECR"
  role = aws_iam_role.ecs_exec.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid    = "AllowPull",
      Effect = "Allow",
      Action = [
        "ecr:GetAuthorizationToken",
        "ecr:BatchGetImage",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:DescribeRepositories",
        "ecr:DescribeImages",
        "ecr:ListImages"
      ],
      Resource = "*"
    }]
  })
}

resource "aws_iam_role_policy" "log_policy_ecs_exec" {
  name = "Logs"
  role = aws_iam_role.ecs_exec.name
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect   = "Allow",
      Action   = ["logs:CreateLog*", "logs:Put*", "logs:Describe*"],
      Resource = "*"
    }]
  })
}

resource "aws_iam_role" "task_role" {
  name = "${local.environmental_name}-taskrole"
  path = "/"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "ServicesAssume",
        Effect    = "Allow",
        Principal = { Service = ["ecs-tasks.amazonaws.com", "ecs.application-autoscaling.amazonaws.com"] },
        Action    = "sts:AssumeRole"
      },
      {
        Sid       = "ExecRoleAssume",
        Effect    = "Allow",
        Principal = { AWS = aws_iam_role.ecs_exec.arn },
        Action    = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "allow_assume_task_role" {
  name = "allow-assume"
  role = aws_iam_role.task_role.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Sid      = "RestrictToExecRole",
      Effect   = "Allow",
      Action   = "sts:AssumeRole",
      Resource = aws_iam_role.ecs_exec.arn
    }]
  })
}

resource "aws_iam_role_policy" "logs_policy_task_role" {
  name = "logs"
  role = aws_iam_role.task_role.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect   = "Allow",
      Action   = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents", "logs:DescribeLogStreams"],
      Resource = aws_cloudwatch_log_group.logs.arn
    }]
  })
}

resource "aws_iam_role_policy" "exec_policy_task_role" {
  name = "ecsexec"
  role = aws_iam_role.task_role.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = [
        "ssmmessages:CreateControlChannel",
        "ssmmessages:CreateDataChannel",
        "ssmmessages:OpenControlChannel",
        "ssmmessages:OpenDataChannel"
      ],
      Resource = "*"
    }]
  })
}
