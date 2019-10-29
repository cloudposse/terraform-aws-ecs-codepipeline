variable "region" {
  type        = string
  description = "AWS Region for S3 bucket"
}

variable "availability_zones" {
  type        = list(string)
  description = "List of availability zones"
}

variable "vpc_cidr_block" {
  type        = string
  description = "VPC CIDR block"
}

variable "namespace" {
  type        = string
  description = "Namespace (e.g. `eg` or `cp`)"
}

variable "stage" {
  type        = string
  description = "Stage (e.g. `prod`, `dev`, `staging`)"
}

variable "name" {
  type        = string
  description = "Name of the application"
}

variable "delimiter" {
  type        = string
  default     = "-"
  description = "Delimiter between `namespace`, `stage`, `name` and `attributes`"
}

variable "attributes" {
  type        = list(string)
  description = "Additional attributes (_e.g._ \"1\")"
  default     = []
}

variable "tags" {
  type        = map(string)
  description = "Additional tags (_e.g._ { BusinessUnit : ABC })"
  default     = {}
}

variable "github_oauth_token" {
  type        = string
  description = "GitHub OAuth Token with permissions to access private repositories"
}

variable "github_webhooks_token" {
  type        = string
  description = "GitHub OAuth Token with permissions to create webhooks. If not provided, can be sourced from the `GITHUB_TOKEN` environment variable"
}

variable "github_webhook_events" {
  type        = list(string)
  description = "A list of events which should trigger the webhook. See a list of [available events](https://developer.github.com/v3/activity/events/types/)"
}

variable "repo_owner" {
  type        = string
  description = "GitHub Organization or Username"
}

variable "repo_name" {
  type        = string
  description = "GitHub repository name of the application to be built and deployed to ECS"
}

variable "branch" {
  type        = string
  description = "Branch of the GitHub repository, _e.g._ `master`"
}

variable "build_image" {
  type        = string
  description = "Docker image for build environment, _e.g._ `aws/codebuild/docker:docker:17.09.0`"
}

variable "build_compute_type" {
  type        = string
  description = "`CodeBuild` instance size. Possible values are: `BUILD_GENERAL1_SMALL` `BUILD_GENERAL1_MEDIUM` `BUILD_GENERAL1_LARGE`"
}

variable "build_timeout" {
  type        = number
  description = "How long in minutes, from 5 to 480 (8 hours), for AWS CodeBuild to wait until timing out any related build that does not get marked as completed"
}

# https://www.terraform.io/docs/configuration/variables.html
# It is recommended you avoid using boolean values and use explicit strings
variable "poll_source_changes" {
  type        = bool
  description = "Periodically check the location of your source content and run the pipeline if changes are detected"
}

variable "privileged_mode" {
  type        = bool
  description = "If set to true, enables running the Docker daemon inside a Docker container on the CodeBuild instance. Used when building Docker images"
}

variable "image_repo_name" {
  type        = string
  description = "ECR repository name to store the Docker image built by this module. Used as CodeBuild ENV variable when building Docker images. [For more info](http://docs.aws.amazon.com/codebuild/latest/userguide/sample-docker.html)"
}

variable "image_tag" {
  type        = string
  description = "Docker image tag in the ECR repository, e.g. 'latest'. Used as CodeBuild ENV variable when building Docker images. [For more info](http://docs.aws.amazon.com/codebuild/latest/userguide/sample-docker.html)"
}

variable "environment_variables" {
  type = list(object(
    {
      name  = string
      value = string
  }))

  description = "A list of maps, that contain both the key 'name' and the key 'value' to be used as additional environment variables for the build"
}

variable "webhook_enabled" {
  type        = bool
  description = "Set to false to prevent the module from creating any webhook resources"
}

variable "webhook_target_action" {
  type        = string
  description = "The name of the action in a pipeline you want to connect to the webhook. The action must be from the source (first) stage of the pipeline"
}

variable "webhook_authentication" {
  type        = string
  description = "The type of authentication to use. One of IP, GITHUB_HMAC, or UNAUTHENTICATED"
}

variable "webhook_filter_json_path" {
  type        = string
  description = "The JSON path to filter on"
}

variable "webhook_filter_match_equals" {
  type        = string
  description = "The value to match on (e.g. refs/heads/{Branch})"
}

variable "s3_bucket_force_destroy" {
  type        = bool
  description = "A boolean that indicates all objects should be deleted from the CodePipeline artifact store S3 bucket so that the bucket can be destroyed without error"
}
