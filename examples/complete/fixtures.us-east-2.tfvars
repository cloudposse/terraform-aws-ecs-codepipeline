region = "us-east-2"

namespace = "eg"

stage = "test"

name = "ecs-codepipeline"

github_oauth_token = "test"

repo_owner = "cloudposse"

repo_name = "terraform-aws-ecs-codepipeline"

branch = "master"

poll_source_changes = false

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
