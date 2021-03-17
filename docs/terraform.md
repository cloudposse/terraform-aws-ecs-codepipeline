<!-- markdownlint-disable -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13.0 |
| aws | >= 2.0 |
| local | >= 1.2 |
| null | >= 2.0 |
| random | >= 2.1 |
| template | >= 2.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 2.0 |
| random | >= 2.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| codebuild | cloudposse/codebuild/aws | 0.35.0 |
| codebuild_label | cloudposse/label/null | 0.24.1 |
| codepipeline_assume_role_label | cloudposse/label/null | 0.24.1 |
| codepipeline_label | cloudposse/label/null | 0.24.1 |
| codepipeline_s3_policy_label | cloudposse/label/null | 0.24.1 |
| codestar_label | cloudposse/label/null | 0.24.1 |
| github_webhooks | cloudposse/repository-webhooks/github | 0.12.0 |
| this | cloudposse/label/null | 0.24.1 |

## Resources

| Name |
|------|
| [aws_caller_identity](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) |
| [aws_codepipeline](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codepipeline) |
| [aws_codepipeline_webhook](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codepipeline_webhook) |
| [aws_iam_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) |
| [aws_iam_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) |
| [aws_iam_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) |
| [aws_iam_role_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) |
| [aws_region](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) |
| [aws_s3_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) |
| [random_string](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| additional\_tag\_map | Additional tags for appending to tags\_as\_list\_of\_maps. Not added to `tags`. | `map(string)` | `{}` | no |
| attributes | Additional attributes (e.g. `1`) | `list(string)` | `[]` | no |
| aws\_account\_id | AWS Account ID. Used as CodeBuild ENV variable when building Docker images. [For more info](http://docs.aws.amazon.com/codebuild/latest/userguide/sample-docker.html) | `string` | `""` | no |
| badge\_enabled | Generates a publicly-accessible URL for the projects build badge. Available as badge\_url attribute when enabled | `bool` | `false` | no |
| branch | Branch of the GitHub repository, _e.g._ `master` | `string` | n/a | yes |
| build\_compute\_type | `CodeBuild` instance size. Possible values are: `BUILD_GENERAL1_SMALL` `BUILD_GENERAL1_MEDIUM` `BUILD_GENERAL1_LARGE` | `string` | `"BUILD_GENERAL1_SMALL"` | no |
| build\_image | Docker image for build environment, _e.g._ `aws/codebuild/docker:docker:17.09.0` | `string` | `"aws/codebuild/docker:17.09.0"` | no |
| build\_timeout | How long in minutes, from 5 to 480 (8 hours), for AWS CodeBuild to wait until timing out any related build that does not get marked as completed | `number` | `60` | no |
| buildspec | Declaration to use for building the project. [For more info](http://docs.aws.amazon.com/codebuild/latest/userguide/build-spec-ref.html) | `string` | `""` | no |
| cache\_bucket\_suffix\_enabled | The cache bucket generates a random 13 character string to generate a unique bucket name. If set to false it uses terraform-null-label's id value. It only works when cache\_type is 'S3' | `bool` | `true` | no |
| cache\_type | The type of storage that will be used for the AWS CodeBuild project cache. Valid values: NO\_CACHE, LOCAL, and S3.  Defaults to S3.  If cache\_type is S3, it will create an S3 bucket for storing codebuild cache inside | `string` | `"S3"` | no |
| codestar\_connection\_arn | CodeStar connection ARN required for Bitbucket integration with CodePipeline | `string` | `""` | no |
| context | Single object for setting entire context at once.<br>See description of individual variables for details.<br>Leave string and numeric variables as `null` to use default value.<br>Individual variable settings (non-null) override settings in context object,<br>except for attributes, tags, and additional\_tag\_map, which are merged. | `any` | <pre>{<br>  "additional_tag_map": {},<br>  "attributes": [],<br>  "delimiter": null,<br>  "enabled": true,<br>  "environment": null,<br>  "id_length_limit": null,<br>  "label_key_case": null,<br>  "label_order": [],<br>  "label_value_case": null,<br>  "name": null,<br>  "namespace": null,<br>  "regex_replace_chars": null,<br>  "stage": null,<br>  "tags": {}<br>}</pre> | no |
| delimiter | Delimiter to be used between `namespace`, `environment`, `stage`, `name` and `attributes`.<br>Defaults to `-` (hyphen). Set to `""` to use no delimiter at all. | `string` | `null` | no |
| ecs\_cluster\_name | ECS Cluster Name | `string` | n/a | yes |
| enabled | Set to false to prevent the module from creating any resources | `bool` | `null` | no |
| environment | Environment, e.g. 'uw2', 'us-west-2', OR 'prod', 'staging', 'dev', 'UAT' | `string` | `null` | no |
| environment\_variables | A list of maps, that contain both the key 'name' and the key 'value' to be used as additional environment variables for the build | <pre>list(object(<br>    {<br>      name  = string<br>      value = string<br>  }))</pre> | `[]` | no |
| github\_oauth\_token | GitHub OAuth Token with permissions to access private repositories | `string` | `""` | no |
| github\_webhook\_events | A list of events which should trigger the webhook. See a list of [available events](https://developer.github.com/v3/activity/events/types/) | `list(string)` | <pre>[<br>  "push"<br>]</pre> | no |
| github\_webhooks\_token | GitHub OAuth Token with permissions to create webhooks. If not provided, can be sourced from the `GITHUB_TOKEN` environment variable | `string` | `""` | no |
| id\_length\_limit | Limit `id` to this many characters (minimum 6).<br>Set to `0` for unlimited length.<br>Set to `null` for default, which is `0`.<br>Does not affect `id_full`. | `number` | `null` | no |
| image\_repo\_name | ECR repository name to store the Docker image built by this module. Used as CodeBuild ENV variable when building Docker images. [For more info](http://docs.aws.amazon.com/codebuild/latest/userguide/sample-docker.html) | `string` | n/a | yes |
| image\_tag | Docker image tag in the ECR repository, e.g. 'latest'. Used as CodeBuild ENV variable when building Docker images. [For more info](http://docs.aws.amazon.com/codebuild/latest/userguide/sample-docker.html) | `string` | `"latest"` | no |
| label\_key\_case | The letter case of label keys (`tag` names) (i.e. `name`, `namespace`, `environment`, `stage`, `attributes`) to use in `tags`.<br>Possible values: `lower`, `title`, `upper`.<br>Default value: `title`. | `string` | `null` | no |
| label\_order | The naming order of the id output and Name tag.<br>Defaults to ["namespace", "environment", "stage", "name", "attributes"].<br>You can omit any of the 5 elements, but at least one must be present. | `list(string)` | `null` | no |
| label\_value\_case | The letter case of output label values (also used in `tags` and `id`).<br>Possible values: `lower`, `title`, `upper` and `none` (no transformation).<br>Default value: `lower`. | `string` | `null` | no |
| local\_cache\_modes | Specifies settings that AWS CodeBuild uses to store and reuse build dependencies. Valid values: LOCAL\_SOURCE\_CACHE, LOCAL\_DOCKER\_LAYER\_CACHE, and LOCAL\_CUSTOM\_CACHE | `list(string)` | `[]` | no |
| name | Solution name, e.g. 'app' or 'jenkins' | `string` | `null` | no |
| namespace | Namespace, which could be your organization name or abbreviation, e.g. 'eg' or 'cp' | `string` | `null` | no |
| poll\_source\_changes | Periodically check the location of your source content and run the pipeline if changes are detected | `bool` | `false` | no |
| privileged\_mode | If set to true, enables running the Docker daemon inside a Docker container on the CodeBuild instance. Used when building Docker images | `bool` | `false` | no |
| regex\_replace\_chars | Regex to replace chars with empty string in `namespace`, `environment`, `stage` and `name`.<br>If not set, `"/[^a-zA-Z0-9-]/"` is used to remove all characters other than hyphens, letters and digits. | `string` | `null` | no |
| region | AWS Region, e.g. us-east-1. Used as CodeBuild ENV variable when building Docker images. [For more info](http://docs.aws.amazon.com/codebuild/latest/userguide/sample-docker.html) | `string` | n/a | yes |
| repo\_name | GitHub repository name of the application to be built and deployed to ECS | `string` | n/a | yes |
| repo\_owner | GitHub Organization or Username | `string` | n/a | yes |
| s3\_bucket\_force\_destroy | A boolean that indicates all objects should be deleted from the CodePipeline artifact store S3 bucket so that the bucket can be destroyed without error | `bool` | `false` | no |
| secondary\_artifact\_bucket\_id | Optional bucket for secondary artifact deployment. If specified, the buildspec must include a secondary artifacts section which controls the artifacts deployed to the bucket [For more info](http://docs.aws.amazon.com/codebuild/latest/userguide/build-spec-ref.html) | `string` | `null` | no |
| secondary\_artifact\_encryption\_enabled | If set to true, enable encryption on the secondary artifact bucket | `bool` | `false` | no |
| secondary\_artifact\_identifier | Identifier for optional secondary artifact deployment. If specified, the identifier must appear in the buildspec as the name of the section which controls the artifacts deployed to the secondary artifact bucket [For more info](http://docs.aws.amazon.com/codebuild/latest/userguide/build-spec-ref.html) | `string` | `null` | no |
| service\_name | ECS Service Name | `string` | n/a | yes |
| stage | Stage, e.g. 'prod', 'staging', 'dev', OR 'source', 'build', 'test', 'deploy', 'release' | `string` | `null` | no |
| tags | Additional tags (e.g. `map('BusinessUnit','XYZ')` | `map(string)` | `{}` | no |
| webhook\_authentication | The type of authentication to use. One of IP, GITHUB\_HMAC, or UNAUTHENTICATED | `string` | `"GITHUB_HMAC"` | no |
| webhook\_enabled | Set to false to prevent the module from creating any webhook resources | `bool` | `true` | no |
| webhook\_filter\_json\_path | The JSON path to filter on | `string` | `"$.ref"` | no |
| webhook\_filter\_match\_equals | The value to match on (e.g. refs/heads/{Branch}) | `string` | `"refs/heads/{Branch}"` | no |
| webhook\_target\_action | The name of the action in a pipeline you want to connect to the webhook. The action must be from the source (first) stage of the pipeline | `string` | `"Source"` | no |

## Outputs

| Name | Description |
|------|-------------|
| badge\_url | The URL of the build badge when badge\_enabled is enabled |
| codebuild\_badge\_url | The URL of the build badge when badge\_enabled is enabled |
| codebuild\_cache\_bucket\_arn | CodeBuild cache S3 bucket ARN |
| codebuild\_cache\_bucket\_name | CodeBuild cache S3 bucket name |
| codebuild\_project\_id | CodeBuild project ID |
| codebuild\_project\_name | CodeBuild project name |
| codebuild\_role\_arn | CodeBuild IAM Role ARN |
| codebuild\_role\_id | CodeBuild IAM Role ID |
| codepipeline\_arn | CodePipeline ARN |
| codepipeline\_id | CodePipeline ID |
| webhook\_id | The CodePipeline webhook's ID |
| webhook\_url | The CodePipeline webhook's URL. POST events to this endpoint to trigger the target |
<!-- markdownlint-restore -->
