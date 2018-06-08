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
  description = "Enable ``CodePipeline`` creation"
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
  description = "GitHub Oauth Token with permissions to access private repositories"
}

variable "repo_owner" {
  description = "GitHub Organization or Username."
}

variable "repo_name" {
  description = "GitHub repository name of the application to be built and deployed to ECS."
}

variable "branch" {
  description = "Branch of the GitHub repository, _e.g._ ``master``"
}

variable "build_image" {
  default     = "aws/codebuild/docker:17.09.0"
  description = "Docker image for build environment, _e.g._ `aws/codebuild/docker:docker:17.09.0`"
}

variable "build_compute_type" {
  default     = "BUILD_GENERAL1_SMALL"
  description = "`CodeBuild` instance size. Possible values are: ```BUILD_GENERAL1_SMALL``` ```BUILD_GENERAL1_MEDIUM``` ```BUILD_GENERAL1_LARGE```"
}

variable "buildspec" {
  default     = ""
  description = "Declaration to use for building the project. [For more info](http://docs.aws.amazon.com/codebuild/latest/userguide/build-spec-ref.html)"
}

# https://www.terraform.io/docs/configuration/variables.html
# It is recommended you avoid using boolean values and use explicit strings
variable "poll_source_changes" {
  type        = "string"
  default     = "true"
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
