region = "us-east-2"

availability_zones = ["us-east-2a", "us-east-2b"]

namespace = "eg"

stage = "test"

name = "ecs-codepipeline"

vpc_cidr_block = "172.16.0.0/16"

github_oauth_token = "test"

github_webhooks_token = "test"

github_webhook_events = ["push", "release"]

repo_owner = "cloudposse"

repo_name = "terraform-aws-ecs-codepipeline"

branch = "master"

build_image = "aws/codebuild/docker:17.09.0"

build_compute_type = "BUILD_GENERAL1_SMALL"

build_timeout = 60

poll_source_changes = false

privileged_mode = false

image_repo_name = "terraform-aws-ecs-codepipeline"

image_tag = "latest"

webhook_enabled = true

webhook_target_action = "Source"

webhook_authentication = "GITHUB_HMAC"

webhook_filter_json_path = "$.ref"

webhook_filter_match_equals = "refs/heads/{Branch}"

s3_bucket_force_destroy = true

environment_variables = [
  {
    name  = "APP_URL"
    value = "https://app.example.com"
  },
  {
    name  = "COMPANY_NAME"
    value = "Cloud Posse"
  },
  {
    name  = "TIME_ZONE"
    value = "America/Los_Angeles"

  }
]
