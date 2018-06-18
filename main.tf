module "codepipeline_label" {
  source     = "github.com/cloudposse/terraform-terraform-label.git?ref=0.1.2"
  attributes = ["${compact(concat(var.attributes, list("codepipeline")))}"]
  delimiter  = "${var.delimiter}"
  name       = "${var.name}"
  namespace  = "${var.namespace}"
  stage      = "${var.stage}"
  tags       = "${var.tags}"
}

resource "aws_s3_bucket" "default" {
  count  = "${var.enabled == "true" ? 1 : 0}"
  bucket = "${module.codepipeline_label.id}"
  acl    = "private"
  tags   = "${module.codepipeline_label.tags}"
}

module "codepipeline_assume_label" {
  source     = "github.com/cloudposse/terraform-terraform-label.git?ref=0.1.2"
  attributes = ["${compact(concat(var.attributes, list("codepipeline", "assume")))}"]
  delimiter  = "${var.delimiter}"
  name       = "${var.name}"
  namespace  = "${var.namespace}"
  stage      = "${var.stage}"
  tags       = "${var.tags}"
}

resource "aws_iam_role" "default" {
  count  = "${var.enabled == "true" ? 1 : 0}"
  name               = "${module.codepipeline_assume_label.id}"
  assume_role_policy = "${data.aws_iam_policy_document.assume.json}"
}

data "aws_iam_policy_document" "assume" {
  statement {
    sid = ""

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }

    effect = "Allow"
  }
}

resource "aws_iam_role_policy_attachment" "default" {
  count  = "${var.enabled == "true" ? 1 : 0}"
  role       = "${aws_iam_role.default.id}"
  policy_arn = "${aws_iam_policy.default.arn}"
}

resource "aws_iam_policy" "default" {
  count  = "${var.enabled == "true" ? 1 : 0}"
  name   = "${module.codepipeline_label.id}"
  policy = "${data.aws_iam_policy_document.default.json}"
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
      "iam:PassRole",
    ]

    resources = ["*"]
    effect    = "Allow"
  }
}

resource "aws_iam_role_policy_attachment" "s3" {
  count  = "${var.enabled == "true" ? 1 : 0}"
  role       = "${aws_iam_role.default.id}"
  policy_arn = "${aws_iam_policy.s3.arn}"
}

module "codepipeline_s3_policy_label" {
  source     = "github.com/cloudposse/terraform-terraform-label.git?ref=0.1.2"
  attributes = ["${compact(concat(var.attributes, list("codepipeline", "s3")))}"]
  delimiter  = "${var.delimiter}"
  name       = "${var.name}"
  namespace  = "${var.namespace}"
  stage      = "${var.stage}"
  tags       = "${var.tags}"
}

resource "aws_iam_policy" "s3" {
  count  = "${var.enabled == "true" ? 1 : 0}"
  name   = "${module.codepipeline_s3_policy_label.id}"
  policy = "${data.aws_iam_policy_document.s3.json}"
}

data "aws_iam_policy_document" "s3" {
  statement {
    sid = ""

    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:GetBucketVersioning",
      "s3:PutObject",
    ]

    resources = [
      "${aws_s3_bucket.default.arn}",
      "${aws_s3_bucket.default.arn}/*",
    ]

    effect = "Allow"
  }
}

resource "aws_iam_role_policy_attachment" "codebuild" {
  count  = "${var.enabled == "true" ? 1 : 0}"
  role       = "${aws_iam_role.default.id}"
  policy_arn = "${aws_iam_policy.codebuild.arn}"
}

module "codebuild_label" {
  source     = "github.com/cloudposse/terraform-terraform-label.git?ref=0.1.2"
  attributes = ["${compact(concat(var.attributes, list("codebuild")))}"]
  delimiter  = "${var.delimiter}"
  name       = "${var.name}"
  namespace  = "${var.namespace}"
  stage      = "${var.stage}"
  tags       = "${var.tags}"
}

resource "aws_iam_policy" "codebuild" {
  count  = "${var.enabled == "true" ? 1 : 0}"
  name   = "${module.codebuild_label.id}"
  policy = "${data.aws_iam_policy_document.codebuild.json}"
}

data "aws_iam_policy_document" "codebuild" {
  statement {
    sid = ""

    actions = [
      "codebuild:*",
    ]

    resources = ["${module.build.project_id}"]
    effect    = "Allow"
  }
}

module "build" {
  source             = "git::https://github.com/cloudposse/terraform-aws-codebuild.git?ref=tags/0.7.1"
  namespace          = "${var.namespace}"
  name               = "${var.name}"
  stage              = "${var.stage}"
  build_image        = "${var.build_image}"
  build_compute_type = "${var.build_compute_type}"
  buildspec          = "${var.buildspec}"
  delimiter          = "${var.delimiter}"
  attributes         = "${concat(var.attributes, list("build"))}"
  tags               = "${var.tags}"
  privileged_mode    = "${var.privileged_mode}"
  aws_region         = "${signum(length(var.aws_region)) == 1 ? var.aws_region : data.aws_region.default.name}"
  aws_account_id     = "${signum(length(var.aws_account_id)) == 1 ? var.aws_account_id : data.aws_caller_identity.default.account_id}"
  image_repo_name    = "${var.image_repo_name}"
  image_tag          = "${var.image_tag}"
  github_token       = "${var.github_oauth_token}"
  enabled            = "${var.enabled}"
}

resource "aws_iam_role_policy_attachment" "codebuild_s3" {
  count  = "${var.enabled == "true" ? 1 : 0}"
  role       = "${module.build.role_arn}"
  policy_arn = "${aws_iam_policy.s3.arn}"
}

resource "aws_codepipeline" "source_build_deploy" {
  count  = "${var.enabled == "true" ? 1 : 0}"
  name     = "${module.codepipeline_label.id}"
  role_arn = "${aws_iam_role.default.arn}"

  artifact_store {
    location = "${aws_s3_bucket.default.bucket}"
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["code"]

      configuration {
        OAuthToken           = "${var.github_oauth_token}"
        Owner                = "${var.repo_owner}"
        Repo                 = "${var.repo_name}"
        Branch               = "${var.branch}"
        PollForSourceChanges = "${var.poll_source_changes}"
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

      configuration {
        ProjectName = "${module.build.project_name}"
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ECS"
      input_artifacts = ["task"]
      version         = "1"

      configuration {
        ClusterName = "${var.ecs_cluster_name}"
        ServiceName = "${var.service_name}"
      }
    }
  }
}

data "aws_caller_identity" "default" {}

data "aws_region" "default" {}
