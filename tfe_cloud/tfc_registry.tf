#####################
#   REGISTRY MODULE #
#####################

resource "tfe_registry_module" "ecs_service_module" {
  organization  = var.tfc_organization
  name          = var.module_name
  provider      = "aws"
  registry_name = "private"
  description   = "Reusable ECS Fargate service with ALB, ECR, IAM, CloudWatch, and optional TFC-managed ALB listener rules."

  vcs_repo {
    identifier     = var.vcs_repo_identifier
    oauth_token_id = data.tfe_oauth_client.vcs.oauth_token_id
    branch         = var.vcs_branch
  }

  visibility = "private"
}
