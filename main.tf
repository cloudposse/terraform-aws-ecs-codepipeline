module "codepipeline_label" {
  source      = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.17.0"
  enabled     = var.enabled
  attributes  = compact(concat(var.attributes, ["codepipeline"]))
  delimiter   = var.delimiter
  name        = var.name
  namespace   = var.namespace
  environment = var.environment
  stage       = var.stage
  tags        = var.tags
}

resource "aws_s3_bucket" "default" {
  count         = var.enabled ? 1 : 0
  bucket        = module.codepipeline_label.id
  acl           = "private"
  force_destroy = var.s3_bucket_force_destroy
  tags          = module.codepipeline_label.tags
}

module "codepipeline_assume_role_label" {
  source      = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.17.0"
  enabled     = var.enabled
  attributes  = compact(concat(var.attributes, ["codepipeline", "assume"]))
  delimiter   = var.delimiter
  name        = var.name
  namespace   = var.namespace
  environment = var.environment
  stage       = var.stage
  tags        = var.tags
}

resource "aws_iam_role" "default" {
  count              = var.enabled ? 1 : 0
  name               = module.codepipeline_assume_role_label.id
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    sid = ""

    actions = [
      "sts:AssumeRole"
    ]

    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }

    effect = "Allow"
  }
}

resource "aws_iam_role_policy_attachment" "default" {
  count      = var.enabled ? 1 : 0
  role       = join("", aws_iam_role.default.*.id)
  policy_arn = join("", aws_iam_policy.default.*.arn)
}

resource "aws_iam_policy" "default" {
  count  = var.enabled ? 1 : 0
  name   = module.codepipeline_label.id
  policy = data.aws_iam_policy_document.default.json
}

data "aws_iam_policy_document" "default" {
  statement {
    sid = ""

    actions = [
      "ec2:*",
      "elasticloadbalancing:*",
      "autoscaling:*",
      "cloudwatch:*",
      "s3:*",
      "sns:*",
      "cloudformation:*",
      "rds:*",
      "sqs:*",
      "ecs:*",
      "iam:PassRole"
    ]

    resources = ["*"]
    effect    = "Allow"
  }
}

resource "aws_iam_role_policy_attachment" "s3" {
  count      = var.enabled ? 1 : 0
  role       = join("", aws_iam_role.default.*.id)
  policy_arn = join("", aws_iam_policy.s3.*.arn)
}

module "codepipeline_s3_policy_label" {
  source      = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.17.0"
  enabled     = var.enabled
  attributes  = compact(concat(var.attributes, ["codepipeline", "s3"]))
  delimiter   = var.delimiter
  name        = var.name
  namespace   = var.namespace
  environment = var.environment
  stage       = var.stage
  tags        = var.tags
}

resource "aws_iam_policy" "s3" {
  count  = var.enabled ? 1 : 0
  name   = module.codepipeline_s3_policy_label.id
  policy = join("", data.aws_iam_policy_document.s3.*.json)
}

data "aws_iam_policy_document" "s3" {
  count = var.enabled ? 1 : 0

  statement {
    sid = ""

    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:GetBucketVersioning",
      "s3:PutObject"
    ]

    resources = [
      join("", aws_s3_bucket.default.*.arn),
      "${join("", aws_s3_bucket.default.*.arn)}/*"
    ]

    effect = "Allow"
  }
}

resource "aws_iam_role_policy_attachment" "codebuild" {
  count      = var.enabled ? 1 : 0
  role       = join("", aws_iam_role.default.*.id)
  policy_arn = join("", aws_iam_policy.codebuild.*.arn)
}

module "codebuild_label" {
  source      = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.17.0"
  enabled     = var.enabled
  attributes  = compact(concat(var.attributes, ["codebuild"]))
  delimiter   = var.delimiter
  name        = var.name
  namespace   = var.namespace
  environment = var.environment
  stage       = var.stage
  tags        = var.tags
}

resource "aws_iam_policy" "codebuild" {
  count  = var.enabled ? 1 : 0
  name   = module.codebuild_label.id
  policy = data.aws_iam_policy_document.codebuild.json
}

data "aws_iam_policy_document" "codebuild" {
  statement {
    sid = ""

    actions = [
      "codebuild:*"
    ]

    resources = [module.codebuild.project_id]
    effect    = "Allow"
  }
}

# https://docs.aws.amazon.com/codepipeline/latest/userguide/connections-permissions.html
resource "aws_iam_role_policy_attachment" "codestar" {
  count      = var.enabled && var.codestar_connection_arn != "" ? 1 : 0
  role       = join("", aws_iam_role.default.*.id)
  policy_arn = join("", aws_iam_policy.codestar.*.arn)
}

module "codestar_label" {
  source      = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.17.0"
  enabled     = var.enabled && var.codestar_connection_arn != ""
  attributes  = compact(concat(var.attributes, ["codestar"]))
  delimiter   = var.delimiter
  name        = var.name
  namespace   = var.namespace
  environment = var.environment
  stage       = var.stage
  tags        = var.tags
}

resource "aws_iam_policy" "codestar" {
  count  = var.enabled && var.codestar_connection_arn != "" ? 1 : 0
  name   = module.codestar_label.id
  policy = join("", data.aws_iam_policy_document.codestar.*.json)
}

data "aws_iam_policy_document" "codestar" {
  count = var.enabled && var.codestar_connection_arn != "" ? 1 : 0
  statement {
    sid = ""

    actions = [
      "codestar-connections:UseConnection"
    ]

    condition {
      test     = "StringLike"
      variable = "codestar-connections:FullRepositoryId"
      values = [
        format("%s/%s", var.repo_owner, var.repo_name)
      ]
    }

    resources = [var.codestar_connection_arn]
    effect    = "Allow"

  }
}

data "aws_caller_identity" "default" {
}

data "aws_region" "default" {
}

module "codebuild" {
  source                = "git::https://github.com/cloudposse/terraform-aws-codebuild.git?ref=tags/0.23.0"
  enabled               = var.enabled
  namespace             = var.namespace
  name                  = var.name
  stage                 = var.stage
  build_image           = var.build_image
  build_compute_type    = var.build_compute_type
  build_timeout         = var.build_timeout
  buildspec             = var.buildspec
  delimiter             = var.delimiter
  attributes            = concat(var.attributes, ["build"])
  tags                  = var.tags
  privileged_mode       = var.privileged_mode
  aws_region            = var.region != "" ? var.region : data.aws_region.default.name
  aws_account_id        = var.aws_account_id != "" ? var.aws_account_id : data.aws_caller_identity.default.account_id
  image_repo_name       = var.image_repo_name
  image_tag             = var.image_tag
  github_token          = var.github_oauth_token
  environment_variables = var.environment_variables
  badge_enabled         = var.badge_enabled
  cache_type            = var.cache_type
  local_cache_modes     = var.local_cache_modes
}

resource "aws_iam_role_policy_attachment" "codebuild_s3" {
  count      = var.enabled ? 1 : 0
  role       = module.codebuild.role_id
  policy_arn = join("", aws_iam_policy.s3.*.arn)
}

resource "aws_codepipeline" "default" {
  count    = var.enabled && var.github_oauth_token != "" ? 1 : 0
  name     = module.codepipeline_label.id
  role_arn = join("", aws_iam_role.default.*.arn)

  artifact_store {
    location = join("", aws_s3_bucket.default.*.bucket)
    type     = "S3"
  }

  depends_on = [
    aws_iam_role_policy_attachment.default,
    aws_iam_role_policy_attachment.s3,
    aws_iam_role_policy_attachment.codebuild,
    aws_iam_role_policy_attachment.codebuild_s3
  ]

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["code"]

      configuration = {
        OAuthToken           = var.github_oauth_token
        Owner                = var.repo_owner
        Repo                 = var.repo_name
        Branch               = var.branch
        PollForSourceChanges = var.poll_source_changes
      }
    }
  }

  stage {
    name = "Build"

    action {
      name     = "Build"
      category = "Build"
      owner    = "AWS"
      provider = "CodeBuild"
      version  = "1"

      input_artifacts  = ["code"]
      output_artifacts = ["task"]

      configuration = {
        ProjectName = module.codebuild.project_name
      }
    }
  }

  stage {
    name = "Deploy"

    dynamic "action" {
      for_each = local.service_names

      content {
        name            = "Deploy-${action.value}"
        category        = "Deploy"
        owner           = "AWS"
        provider        = "ECS"
        input_artifacts = ["task"]
        version         = "1"

        configuration = {
          ServiceName = action.value
          ClusterName = var.ecs_cluster_name
        }
      }
    }
  }

  lifecycle {
    # prevent github OAuthToken from causing updates, since it's removed from state file
    ignore_changes = [stage[0].action[0].configuration]
  }

}

# https://docs.aws.amazon.com/codepipeline/latest/userguide/action-reference-CodestarConnectionSource.html#action-reference-CodestarConnectionSource-example
resource "aws_codepipeline" "bitbucket" {
  count    = var.enabled && var.codestar_connection_arn != "" ? 1 : 0
  name     = module.codepipeline_label.id
  role_arn = join("", aws_iam_role.default.*.arn)

  artifact_store {
    location = join("", aws_s3_bucket.default.*.bucket)
    type     = "S3"
  }

  depends_on = [
    aws_iam_role_policy_attachment.default,
    aws_iam_role_policy_attachment.s3,
    aws_iam_role_policy_attachment.codebuild,
    aws_iam_role_policy_attachment.codebuild_s3,
    aws_iam_role_policy_attachment.codestar
  ]

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["code"]

      configuration = {
        ConnectionArn        = var.codestar_connection_arn
        FullRepositoryId     = format("%s/%s", var.repo_owner, var.repo_name)
        BranchName           = var.branch
        OutputArtifactFormat = "CODE_ZIP"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name     = "Build"
      category = "Build"
      owner    = "AWS"
      provider = "CodeBuild"
      version  = "1"

      input_artifacts  = ["code"]
      output_artifacts = ["task"]

      configuration = {
        ProjectName = module.codebuild.project_name
      }
    }
  }

  stage {
    name = "Deploy"

    dynamic "action" {
      for_each = local.service_names

      content {
        name            = "Deploy ${action.value}"
        category        = "Deploy"
        owner           = "AWS"
        provider        = "ECS"
        input_artifacts = ["task"]
        version         = "1"

        configuration = {
          ServiceName = action.value
          ClusterName = var.ecs_cluster_name
        }
      }
    }
  }
}

resource "random_string" "webhook_secret" {
  count  = var.enabled && var.webhook_enabled ? 1 : 0
  length = 32

  # Special characters are not allowed in webhook secret (AWS silently ignores webhook callbacks)
  special = false
}

locals {
  service_names  = compact(concat(var.service_names, [var.service_name]))
  webhook_secret = join("", random_string.webhook_secret.*.result)
  webhook_url    = join("", aws_codepipeline_webhook.webhook.*.url)
}

resource "aws_codepipeline_webhook" "webhook" {
  count           = var.enabled && var.webhook_enabled ? 1 : 0
  name            = module.codepipeline_label.id
  authentication  = var.webhook_authentication
  target_action   = var.webhook_target_action
  target_pipeline = join("", aws_codepipeline.default.*.name)

  authentication_configuration {
    secret_token = local.webhook_secret
  }

  filter {
    json_path    = var.webhook_filter_json_path
    match_equals = var.webhook_filter_match_equals
  }
}

module "github_webhooks" {
  source               = "git::https://github.com/cloudposse/terraform-github-repository-webhooks.git?ref=tags/0.10.0"
  enabled              = var.enabled && var.webhook_enabled ? true : false
  github_anonymous     = var.github_anonymous
  github_organization  = var.repo_owner
  github_repositories  = [var.repo_name]
  github_token         = var.github_webhooks_token
  webhook_url          = local.webhook_url
  webhook_secret       = local.webhook_secret
  webhook_content_type = "json"
  events               = var.github_webhook_events
}
