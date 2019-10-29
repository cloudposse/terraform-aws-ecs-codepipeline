provider "aws" {
  region = var.region
}

module "ecs_codepipeline" {
  source                = "../../"
  namespace             = var.namespace
  stage                 = var.stage
  name                  = var.name
  region                = var.region
  github_oauth_token    = var.github_oauth_token
  repo_owner            = var.repo_owner
  repo_name             = var.repo_name
  branch                = var.branch
  poll_source_changes   = var.poll_source_changes
  environment_variables = var.environment_variables
  ecs_cluster_name      = ""
  service_name          = ""
}
