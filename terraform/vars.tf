##########################
#        VARIABLES       #
##########################

variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
}

variable "service_name" {
  description = "Logical name of the service (e.g., resume, blog, api)"
  type        = string
  default     = "resume"
}

variable "environment" {
  description = "Deployment environment (e.g., dev, staging, prod). Leave blank for none"
  type        = string
  default     = ""
}

variable "subnet_ids" {
  description = "List of subnet IDs in which to deploy the ECS service"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID where the ECS service and ALB will be deployed"
  type        = string
}

variable "alb_securitygroup_id" {
  description = "Security group ID of the ALB that will front the ECS service"
  type        = string
}

variable "http_listener_arn" {
  description = "ARN of the ALB HTTP listener (typically port 80)"
  type        = string
}

variable "https_listener_arn" {
  description = "ARN of the ALB HTTPS listener (typically port 443)"
  type        = string
}

variable "domain_name" {
  description = "Root domain name for constructing host-header rules (e.g., example.com)"
  type        = string
}

variable "alb_listener_cert_arn" {
  description = "Optional ACM certificate ARN to attach to the HTTPS listener"
  type        = string
  default     = ""
}

variable "existing_ecs_cluster_id" {
  description = "Optional: if provided, use an existing ECS cluster instead of creating one"
  type        = string
  default     = ""
}

variable "ecs_cluster_name" {
  description = "Name of the ECS cluster to create (ignored if existing_ecs_cluster_id is set)"
  type        = string
  default     = ""
}

variable "desired_count" {
  description = "Desired number of ECS tasks to run"
  type        = number
  default     = 0
}

variable "deployment_maximum_percent" {
  description = "Upper limit (% of desired_count) of running tasks during deployments"
  type        = number
  default     = 100
}

variable "deployment_minimum_healthy_percent" {
  description = "Minimum % of healthy tasks required during deployment"
  type        = number
  default     = 0
}

variable "ecs_service_cpu" {
  description = "Amount of CPU (in units) to allocate to the ECS task"
  type        = number
  default     = 256
}

variable "ecs_service_memory" {
  description = "Amount of memory (in MiB) to allocate to the ECS task"
  type        = number
  default     = 256
}

variable "ecr_repo_arn" {
  description = "ARN of the ECR repository containing the service image"
  type        = string
}

variable "ecr_repo_url" {
  description = "Full repository URL (including registry) for pulling the container image"
  type        = string
}

variable "ecr_image_tag" {
  description = "Tag of the container image to deploy from the ECR repository"
  type        = string
  default     = "dev"
}
