output "badge_url" {
  description = "The URL of the build badge when badge_enabled is enabled"
  value       = "${module.build.badge_url}"
}

output "webhook_id" {
  description = "The CodePipeline webhook's ARN."
  value       = "${join("", aws_codepipeline_webhook.webhook.*.id)}"
}

output "webhook_url" {
  description = "The CodePipeline webhook's URL. POST events to this endpoint to trigger the target"
  value       = "${local.webhook_url}"
  sensitive   = true
}
