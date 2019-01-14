output "badge_url" {
  description = "The URL of the build badge when badge_enabled is enabled"
  value       = "${module.build.badge_url}"
}
