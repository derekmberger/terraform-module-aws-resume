# terraform-module-aws-resume
# AWS Fargate Service Module

Deploy a **containerised application on AWS Fargate** front‑ended by an Application Load Balancer (ALB) with a single module call.  The module creates (or re‑uses) an ECS cluster, task definition, service, CloudWatch log group, target group, listener rules, security group and the required IAM roles.

## Usage Example

```hcl
provider "aws" {
  region = "us‑east‑1"
}

module "resume_service" {
  source = "./modules/ecs‑fargate‑service"      # update to your module source

  # Core
  aws_region   = "us‑east‑1"
  service_name = "resume"
  environment  = "prod"

  # Networking
  vpc_id      = data.aws_vpc.main.id
  subnet_ids  = data.aws_subnets.private.ids

  alb_securitygroup_id = aws_security_group.alb.id
  http_listener_arn    = aws_lb_listener.http.arn
  https_listener_arn   = aws_lb_listener.https.arn
  domain_name          = "example.com"
  alb_listener_cert_arn = aws_acm_certificate.site.arn

  # Image
  ecr_repo_arn  = aws_ecr_repository.resume.arn
  ecr_repo_url  = aws_ecr_repository.resume.repository_url
  ecr_image_tag = "2025‑05‑15"

  # Capacity
  desired_count       = 2
  ecs_service_cpu     = 512
  ecs_service_memory  = 1024
}
```

## Input Variables

| Name                                  | Description                                        | Type           | Default  | Required |
| ------------------------------------- | -------------------------------------------------- | -------------- | -------- | :------: |
| **aws\_region**                       | AWS region to deploy resources                     | `string`       |  n/a     |  **yes** |
| **service\_name**                     | Logical name of the service (e.g. `resume`)        | `string`       | "resume" |    no    |
| **environment**                       | Deployment environment prefix (e.g. `dev`, `prod`) | `string`       | ""       |    no    |
| **subnet\_ids**                       | Subnets where tasks run                            | `list(string)` |  n/a     |  **yes** |
| **vpc\_id**                           | VPC of the service                                 | `string`       |  n/a     |  **yes** |
| **alb\_securitygroup\_id**            | Security‑group ID of the public ALB                | `string`       |  n/a     |  **yes** |
| **http\_listener\_arn**               | ALB HTTP listener ARN (port 80)                    | `string`       | n/a      |  **yes** |
| **https\_listener\_arn**              | ALB HTTPS listener ARN (port 443)                  | `string`       | n/a      |  **yes** |
| **domain\_name**                      | Root domain – used for the host‑header rule        | `string`       | n/a      |  **yes** |
| alb\_listener\_cert\_arn              | ACM cert ARN to attach to the listener             | `string`       | ""       |    no    |
| existing\_ecs\_cluster\_id            | Provide to re‑use an existing ECS cluster          | `string`       | ""       |    no    |
| ecs\_cluster\_name                    | Name if the module creates a new cluster           | `string`       | ""       |    no    |
| desired\_count                        | Number of tasks                                    | `number`       | `0`      |    no    |
| deployment\_maximum\_percent          | Upper deployment surge                             | `number`       | `100`    |    no    |
| deployment\_minimum\_healthy\_percent | Lower deployment floor                             | `number`       | `0`      |    no    |
| ecs\_service\_cpu                     | CPU units per task                                 | `number`       | `256`    |    no    |
| ecs\_service\_memory                  | Memory (MiB) per task                              | `number`       | `256`    |    no    |
| **ecr\_repo\_arn**                    | ECR repository ARN                                 | `string`       | n/a      |  **yes** |
| **ecr\_repo\_url**                    | ECR repository URL                                 | `string`       | n/a      |  **yes** |
| ecr\_image\_tag                       | Image tag to deploy                                | `string`       | "dev"    |    no    |

> **Tip** – variables marked **yes** are required

## Outside of module scope
- Shared ALB
- Route53 Hosted Zone
- ACM Certificate
- ECR Repository
