##########################
#        VARIABLES       #
##########################
variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
}

variable "service_name" {
  description = "Logical name of the service"
  type        = string
  default     = "resume"
}

variable "environment" {
  description = "Deployment environment (e.g., dev, staging, prod). Leave blank for none"
  type        = string
  default     = ""
}

variable "subnet_ids" {
  description = "Subnets for the ECS service"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC Id hosting the service"
  type        = string
}

variable "alb_securitygroup_id" {
  description = "Security‑group id of the ALB fronting the service"
  type        = string
}

variable "http_listener_arn" {
  description = "ARN of the ALB **HTTP** listener (port 80)"
  type        = string
}

variable "https_listener_arn" {
  description = "ARN of the ALB **HTTPS** listener (port 443)"
  type        = string
}

variable "domain_name" {
  description = "Root DNS name used for host‑header rules (e.g. example.com)"
  type        = string
}

variable "alb_listener_cert_arn" {
  description = "Optional ACM certificate ARN to attach to the HTTPS listener"
  type        = string
  default     = ""
}

variable "existing_ecs_cluster_id" {
  description = "Use an existing ECS cluster instead of creating a new one"
  type        = string
  default     = ""
}

variable "ecs_cluster_name" {
  description = "Name for a new ECS cluster (ignored when existing_ecs_cluster_id is set)"
  type        = string
  default     = ""
}

variable "desired_count" {
  description = "Number of desired tasks"
  type        = number
  default     = 0
}

variable "deployment_maximum_percent" {
  type    = number
  default = 100
}

variable "deployment_minimum_healthy_percent" {
  type    = number
  default = 0
}

variable "ecs_service_cpu" {
  type    = number
  default = 256
}

variable "ecs_service_memory" {
  type    = number
  default = 256
}

variable "ecr_repo_arn" {
  description = "ARN of ECR repository"
  type        = string
}

variable "ecr_repo_url" {
  description = "URL of ECR repository"
  type        = string
}

variable "ecr_image_tag" {
  type    = string
  default = "dev"
}
