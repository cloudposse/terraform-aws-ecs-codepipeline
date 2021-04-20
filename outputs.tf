locals {
  codepipeline_resource = try(element(concat(aws_codepipeline.default.*, aws_codepipeline.bitbucket.*), 0), null)
}

output "badge_url" {
  description = "The URL of the build badge when badge_enabled is enabled"
  value       = module.codebuild.badge_url
}

output "webhook_id" {
  description = "The CodePipeline webhook's ID"
  value       = join("", aws_codepipeline_webhook.webhook.*.id)
}

output "webhook_url" {
  description = "The CodePipeline webhook's URL. POST events to this endpoint to trigger the target"
  value       = local.webhook_url
  sensitive   = true
}

output "codebuild_project_name" {
  description = "CodeBuild project name"
  value       = module.codebuild.project_name
}

output "codebuild_project_id" {
  description = "CodeBuild project ID"
  value       = module.codebuild.project_id
}

output "codebuild_role_id" {
  description = "CodeBuild IAM Role ID"
  value       = module.codebuild.role_id
}

output "codebuild_role_arn" {
  description = "CodeBuild IAM Role ARN"
  value       = module.codebuild.role_arn
}

output "codebuild_cache_bucket_name" {
  description = "CodeBuild cache S3 bucket name"
  value       = module.codebuild.cache_bucket_name
}

output "codebuild_cache_bucket_arn" {
  description = "CodeBuild cache S3 bucket ARN"
  value       = module.codebuild.cache_bucket_arn
}

output "codebuild_badge_url" {
  description = "The URL of the build badge when badge_enabled is enabled"
  value       = module.codebuild.badge_url
}

output "codepipeline_id" {
  description = "CodePipeline ID"
  value       = lookup(locals.codepipeline_resource, "id", "")
}

output "codepipeline_arn" {
  description = "CodePipeline ARN"
  value       = lookup(locals.codepipeline_resource, "arn", "")
}

output "codepipeline_resource" {
  description = "CodePipeline resource"
  value       = locals.codepipeline_resource
}
