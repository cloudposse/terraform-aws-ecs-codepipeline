variable "namespace" {
  default     = "global"
  description = "Namespace, which could be your organization name, e.g. 'cp' or 'cloudposse'"
}

variable "stage" {
  default     = "default"
  description = "Stage, e.g. 'prod', 'staging', 'dev', or 'test'"
}

variable "name" {
  default     = "app"
  description = "Solution name, e.g. 'app' or 'jenkins'"
}

variable "enabled" {
  default     = "true"
  description = "Enable `CodePipeline` creation"
}

variable "ecs_cluster_name" {
  type        = "string"
  description = "ECS Cluster Name"
}

variable "service_name" {
  type        = "string"
  description = "ECS Service Name"
}

variable "github_oauth_token" {
  type        = "string"
  description = "GitHub OAuth Token with permissions to access private repositories"
}

variable "github_webhooks_token" {
  type        = "string"
  default     = ""
  description = "GitHub OAuth Token with permissions to create webhooks. If not provided, can be sourced from the `GITHUB_TOKEN` environment variable"
}

variable "github_webhook_events" {
  description = "A list of events which should trigger the webhook. See a list of [available events](https://developer.github.com/v3/activity/events/types/)"
  type        = "list"
  default     = ["push"]
}

variable "repo_owner" {
  description = "GitHub Organization or Username."
}

variable "repo_name" {
  description = "GitHub repository name of the application to be built and deployed to ECS."
}

variable "branch" {
  description = "Branch of the GitHub repository, _e.g._ `master`"
}

variable "badge_enabled" {
  type        = "string"
  default     = "false"
  description = "Generates a publicly-accessible URL for the projects build badge. Available as badge_url attribute when enabled."
}

variable "build_image" {
  default     = "aws/codebuild/docker:17.09.0"
  description = "Docker image for build environment, _e.g._ `aws/codebuild/docker:docker:17.09.0`"
}

variable "build_compute_type" {
  default     = "BUILD_GENERAL1_SMALL"
  description = "`CodeBuild` instance size. Possible values are: `BUILD_GENERAL1_SMALL` `BUILD_GENERAL1_MEDIUM` `BUILD_GENERAL1_LARGE`"
}

variable "build_timeout" {
  type        = "string"
  default     = "60"
  description = "How long in minutes, from 5 to 480 (8 hours), for AWS CodeBuild to wait until timing out any related build that does not get marked as completed."
}

variable "buildspec" {
  default     = ""
  description = "Declaration to use for building the project. [For more info](http://docs.aws.amazon.com/codebuild/latest/userguide/build-spec-ref.html)"
}

# https://www.terraform.io/docs/configuration/variables.html
# It is recommended you avoid using boolean values and use explicit strings
variable "poll_source_changes" {
  type        = "string"
  default     = "false"
  description = "Periodically check the location of your source content and run the pipeline if changes are detected"
}

variable "delimiter" {
  type        = "string"
  default     = "-"
  description = "Delimiter to be used between `name`, `namespace`, `stage`, etc."
}

variable "attributes" {
  type        = "list"
  default     = []
  description = "Additional attributes (e.g. `policy` or `role`)"
}

variable "tags" {
  type        = "map"
  default     = {}
  description = "Additional tags (e.g. `map('BusinessUnit', 'XYZ')`"
}

variable "privileged_mode" {
  default     = "false"
  description = "If set to true, enables running the Docker daemon inside a Docker container on the CodeBuild instance. Used when building Docker images"
}

variable "aws_region" {
  type        = "string"
  default     = ""
  description = "AWS Region, e.g. us-east-1. Used as CodeBuild ENV variable when building Docker images. [For more info](http://docs.aws.amazon.com/codebuild/latest/userguide/sample-docker.html)"
}

variable "aws_account_id" {
  type        = "string"
  default     = ""
  description = "AWS Account ID. Used as CodeBuild ENV variable when building Docker images. [For more info](http://docs.aws.amazon.com/codebuild/latest/userguide/sample-docker.html)"
}

variable "image_repo_name" {
  type        = "string"
  default     = "UNSET"
  description = "ECR repository name to store the Docker image built by this module. Used as CodeBuild ENV variable when building Docker images. [For more info](http://docs.aws.amazon.com/codebuild/latest/userguide/sample-docker.html)"
}

variable "image_tag" {
  type        = "string"
  default     = "latest"
  description = "Docker image tag in the ECR repository, e.g. 'latest'. Used as CodeBuild ENV variable when building Docker images. [For more info](http://docs.aws.amazon.com/codebuild/latest/userguide/sample-docker.html)"
}

variable "environment_variables" {
  type = "list"

  default = [{
    "name"  = "NO_ADDITIONAL_BUILD_VARS"
    "value" = "TRUE"
  }]

  description = "A list of maps, that contain both the key 'name' and the key 'value' to be used as additional environment variables for the build."
}

variable "webhook_enabled" {
  description = "Set to false to prevent the module from creating any webhook resources"
  default     = "true"
}

variable "webhook_target_action" {
  description = "The name of the action in a pipeline you want to connect to the webhook. The action must be from the source (first) stage of the pipeline."
  default     = "Source"
}

variable "webhook_authentication" {
  description = "The type of authentication to use. One of IP, GITHUB_HMAC, or UNAUTHENTICATED."
  default     = "GITHUB_HMAC"
}

variable "webhook_filter_json_path" {
  description = "The JSON path to filter on."
  default     = "$.ref"
}

variable "webhook_filter_match_equals" {
  description = "The value to match on (e.g. refs/heads/{Branch})"
  default     = "refs/heads/{Branch}"
}

variable "s3_bucket_force_destroy" {
  description = "A boolean that indicates all objects should be deleted from the CodePipeline artifact store S3 bucket so that the bucket can be destroyed without error"
  default     = false
}
