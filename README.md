<!-- 














  ** DO NOT EDIT THIS FILE
  ** 
  ** This file was automatically generated by the `build-harness`. 
  ** 1) Make all changes to `README.yaml` 
  ** 2) Run `make init` (you only need to do this once)
  ** 3) Run`make readme` to rebuild this file. 
  **
  ** (We maintain HUNDREDS of open source projects. This is how we maintain our sanity.)
  **















  -->
[![README Header][readme_header_img]][readme_header_link]

[![Cloud Posse][logo]](https://cpco.io/homepage)

# terraform-aws-ecs-codepipeline [![GitHub Action Tests](https://github.com/cloudposse/terraform-aws-ecs-codepipeline/workflows/test/badge.svg?branch=master)](https://github.com/cloudposse/terraform-aws-ecs-codepipeline/actions) [![Latest Release](https://img.shields.io/github/release/cloudposse/terraform-aws-ecs-codepipeline.svg)](https://github.com/cloudposse/terraform-aws-ecs-codepipeline/releases/latest) [![Slack Community](https://slack.cloudposse.com/badge.svg)](https://slack.cloudposse.com)


Terraform Module for CI/CD with AWS Code Pipeline using GitHub webhook triggers and Code Build for ECS.


---

This project is part of our comprehensive ["SweetOps"](https://cpco.io/sweetops) approach towards DevOps. 
[<img align="right" title="Share via Email" src="https://docs.cloudposse.com/images/ionicons/ios-email-outline-2.0.1-16x16-999999.svg"/>][share_email]
[<img align="right" title="Share on Google+" src="https://docs.cloudposse.com/images/ionicons/social-googleplus-outline-2.0.1-16x16-999999.svg" />][share_googleplus]
[<img align="right" title="Share on Facebook" src="https://docs.cloudposse.com/images/ionicons/social-facebook-outline-2.0.1-16x16-999999.svg" />][share_facebook]
[<img align="right" title="Share on Reddit" src="https://docs.cloudposse.com/images/ionicons/social-reddit-outline-2.0.1-16x16-999999.svg" />][share_reddit]
[<img align="right" title="Share on LinkedIn" src="https://docs.cloudposse.com/images/ionicons/social-linkedin-outline-2.0.1-16x16-999999.svg" />][share_linkedin]
[<img align="right" title="Share on Twitter" src="https://docs.cloudposse.com/images/ionicons/social-twitter-outline-2.0.1-16x16-999999.svg" />][share_twitter]


[![Terraform Open Source Modules](https://docs.cloudposse.com/images/terraform-open-source-modules.svg)][terraform_modules]



It's 100% Open Source and licensed under the [APACHE2](LICENSE).







We literally have [*hundreds of terraform modules*][terraform_modules] that are Open Source and well-maintained. Check them out! 







## Usage


**IMPORTANT:** The `master` branch is used in `source` just as an example. In your code, do not pin to `master` because there may be breaking changes between releases.
Instead pin to the release tag (e.g. `?ref=tags/x.y.z`) of one of our [latest releases](https://github.com/cloudposse/terraform-aws-ecs-codepipeline/releases).



For a complete example, see [examples/complete](examples/complete).

For automated tests of the complete example using `bats` and `Terratest`, see [test](test).

### Trigger on GitHub Push

In this example, we'll trigger the pipeline anytime the `master` branch is updated.
```hcl
module "ecs_push_pipeline" {
  source                = "git::https://github.com/cloudposse/terraform-aws-ecs-codepipeline.git?ref=master"
  name                  = "app"
  namespace             = "eg"
  stage                 = "staging"
  github_oauth_token    = "xxxxxxxxxxxxxx"
  github_webhooks_token = "xxxxxxxxxxxxxx"
  repo_owner            = "cloudposse"
  repo_name             = "example"
  branch                = "master"
  service_name          = "example"
  ecs_cluster_name      = "eg-staging-example-cluster"
  privileged_mode       = "true"
}
```

### Trigger on GitHub Releases

In this example, we'll trigger anytime a new GitHub release is cut by setting the even type to `release` and using the `json_path` to *exactly* match an `action` of `published`.

```hcl
module "ecs_release_pipeline" {
  source                      = "git::https://github.com/cloudposse/terraform-aws-ecs-codepipeline.git?ref=master"
  name                        = "app"
  namespace                   = "eg"
  stage                       = "staging"
  github_oauth_token          = "xxxxxxxxxxxxxx"
  github_webhooks_token       = "xxxxxxxxxxxxxx"
  repo_owner                  = "cloudposse"
  repo_name                   = "example"
  branch                      = "master"
  service_name                = "example"
  ecs_cluster_name            = "eg-staging-example-cluster"
  privileged_mode             = "true"
  github_webhook_events       = ["release"]
  webhook_filter_json_path    = "$.action"
  webhook_filter_match_equals = "published"
}
```

(Thanks to [Stack Overflow](https://stackoverflow.com/questions/52516087/trigger-aws-codepipeline-by-github-release-webhook#comment91997146_52524711))




## Examples

Complete usage can be seen in the [terraform-aws-ecs-web-app](https://github.com/cloudposse/terraform-aws-ecs-web-app/blob/master/main.tf) module.

## Example Buildspec

Here's an example `buildspec.yaml`. Stick this in the root of your project repository.

```yaml
version: 0.2
phases:
  pre_build:
    commands:
      - echo Logging in to Amazon ECR...
      - aws --version
      - eval $(aws ecr get-login --region $AWS_DEFAULT_REGION --no-include-email)
      - REPOSITORY_URI=$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$IMAGE_REPO_NAME
      - IMAGE_TAG=$(echo $CODEBUILD_RESOLVED_SOURCE_VERSION | cut -c 1-7)
  build:
    commands:
      - echo Build started on `date`
      - echo Building the Docker image...
      - REPO_URI=$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$IMAGE_REPO_NAME
      - docker pull $REPO_URI:latest || true
      - docker build --cache-from $REPO_URI:latest --tag $REPO_URI:latest --tag $REPO_URI:$IMAGE_TAG .
  post_build:
    commands:
      - echo Build completed on `date`
      - echo Pushing the Docker images...
      - REPO_URI=$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$IMAGE_REPO_NAME
      - docker push $REPO_URI:latest
      - docker push $REPO_URI:$IMAGE_TAG
      - echo Writing image definitions file...
      - printf '[{"name":"%s","imageUri":"%s"}]' "$CONTAINER_NAME" "$REPO_URI:$IMAGE_TAG" | tee imagedefinitions.json
artifacts:
  files: imagedefinitions.json
```



## Makefile Targets
```
Available targets:

  help                                Help screen
  help/all                            Display help for all targets
  help/short                          This help short screen

```
## Requirements

| Name | Version |
|------|---------|
| terraform | ~> 0.12.0 |
| aws | ~> 2.0 |
| local | ~> 1.2 |
| null | ~> 2.0 |
| random | ~> 2.1 |
| template | ~> 2.0 |

## Providers

| Name | Version |
|------|---------|
| aws | ~> 2.0 |
| random | ~> 2.1 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| attributes | Additional attributes (\_e.g.\_ "1") | `list(string)` | `[]` | no |
| aws\_account\_id | AWS Account ID. Used as CodeBuild ENV variable when building Docker images. [For more info](http://docs.aws.amazon.com/codebuild/latest/userguide/sample-docker.html) | `string` | `""` | no |
| badge\_enabled | Generates a publicly-accessible URL for the projects build badge. Available as badge\_url attribute when enabled | `bool` | `false` | no |
| branch | Branch of the GitHub repository, _e.g._ `master` | `string` | n/a | yes |
| build\_compute\_type | `CodeBuild` instance size. Possible values are: `BUILD_GENERAL1_SMALL` `BUILD_GENERAL1_MEDIUM` `BUILD_GENERAL1_LARGE` | `string` | `"BUILD_GENERAL1_SMALL"` | no |
| build\_image | Docker image for build environment, _e.g._ `aws/codebuild/docker:docker:17.09.0` | `string` | `"aws/codebuild/docker:17.09.0"` | no |
| build\_timeout | How long in minutes, from 5 to 480 (8 hours), for AWS CodeBuild to wait until timing out any related build that does not get marked as completed | `number` | `60` | no |
| buildspec | Declaration to use for building the project. [For more info](http://docs.aws.amazon.com/codebuild/latest/userguide/build-spec-ref.html) | `string` | `""` | no |
| cache\_type | The type of storage that will be used for the AWS CodeBuild project cache. Valid values: NO\_CACHE, LOCAL, and S3.  Defaults to NO\_CACHE.  If cache\_type is S3, it will create an S3 bucket for storing codebuild cache inside | `string` | `"S3"` | no |
| delimiter | Delimiter between `namespace`, `stage`, `name` and `attributes` | `string` | `"-"` | no |
| ecs\_cluster\_name | ECS Cluster Name | `string` | n/a | yes |
| enabled | Enable `CodePipeline` creation | `bool` | `true` | no |
| environment\_variables | A list of maps, that contain both the key 'name' and the key 'value' to be used as additional environment variables for the build | <pre>list(object(<br>    {<br>      name  = string<br>      value = string<br>  }))</pre> | `[]` | no |
| github\_oauth\_token | GitHub OAuth Token with permissions to access private repositories | `string` | n/a | yes |
| github\_webhook\_events | A list of events which should trigger the webhook. See a list of [available events](https://developer.github.com/v3/activity/events/types/) | `list(string)` | <pre>[<br>  "push"<br>]</pre> | no |
| github\_webhooks\_token | GitHub OAuth Token with permissions to create webhooks. If not provided, can be sourced from the `GITHUB_TOKEN` environment variable | `string` | `""` | no |
| image\_repo\_name | ECR repository name to store the Docker image built by this module. Used as CodeBuild ENV variable when building Docker images. [For more info](http://docs.aws.amazon.com/codebuild/latest/userguide/sample-docker.html) | `string` | n/a | yes |
| image\_tag | Docker image tag in the ECR repository, e.g. 'latest'. Used as CodeBuild ENV variable when building Docker images. [For more info](http://docs.aws.amazon.com/codebuild/latest/userguide/sample-docker.html) | `string` | `"latest"` | no |
| name | Name of the application | `string` | n/a | yes |
| namespace | Namespace (e.g. `eg` or `cp`) | `string` | `""` | no |
| poll\_source\_changes | Periodically check the location of your source content and run the pipeline if changes are detected | `bool` | `false` | no |
| privileged\_mode | If set to true, enables running the Docker daemon inside a Docker container on the CodeBuild instance. Used when building Docker images | `bool` | `false` | no |
| region | AWS Region, e.g. us-east-1. Used as CodeBuild ENV variable when building Docker images. [For more info](http://docs.aws.amazon.com/codebuild/latest/userguide/sample-docker.html) | `string` | n/a | yes |
| repo\_name | GitHub repository name of the application to be built and deployed to ECS | `string` | n/a | yes |
| repo\_owner | GitHub Organization or Username | `string` | n/a | yes |
| s3\_bucket\_force\_destroy | A boolean that indicates all objects should be deleted from the CodePipeline artifact store S3 bucket so that the bucket can be destroyed without error | `bool` | `false` | no |
| service\_name | ECS Service Name | `string` | n/a | yes |
| stage | Stage (e.g. `prod`, `dev`, `staging`) | `string` | `""` | no |
| tags | Additional tags (\_e.g.\_ { BusinessUnit : ABC }) | `map(string)` | `{}` | no |
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




## Share the Love 

Like this project? Please give it a ★ on [our GitHub](https://github.com/cloudposse/terraform-aws-ecs-codepipeline)! (it helps us **a lot**) 

Are you using this project or any of our other projects? Consider [leaving a testimonial][testimonial]. =)


## Related Projects

Check out these related projects.

- [terraform-aws-alb](https://github.com/cloudposse/terraform-aws-alb) - Terraform module to provision a standard ALB for HTTP/HTTP traffic
- [terraform-aws-alb-ingress](https://github.com/cloudposse/terraform-aws-alb-ingress) - Terraform module to provision an HTTP style ingress rule based on hostname and path for an ALB
- [terraform-aws-codebuild](https://github.com/cloudposse/terraform-aws-codebuild) - Terraform Module to easily leverage AWS CodeBuild for Continuous Integration
- [terraform-aws-ecr](https://github.com/cloudposse/terraform-aws-ecr) - Terraform Module to manage Docker Container Registries on AWS ECR
- [terraform-aws-ecs-alb-service-task](https://github.com/cloudposse/terraform-aws-ecs-alb-service-task) - Terraform module which implements an ECS service which exposes a web service via ALB.
- [terraform-aws-ecs-container-definition](https://github.com/cloudposse/terraform-aws-ecs-container-definition) - Terraform module to generate well-formed JSON documents that are passed to the aws_ecs_task_definition Terraform resource
- [terraform-aws-lb-s3-bucket](https://github.com/cloudposse/terraform-aws-lb-s3-bucket) - Terraform module to provision an S3 bucket with built in IAM policy to allow AWS Load Balancers to ship access logs.




## References

For additional context, refer to some of these links. 

- [aws_codepipeline_webhook](https://www.terraform.io/docs/providers/aws/r/codepipeline_webhook.html) - Provides a CodePipeline Webhook


## Help

**Got a question?** We got answers. 

File a GitHub [issue](https://github.com/cloudposse/terraform-aws-ecs-codepipeline/issues), send us an [email][email] or join our [Slack Community][slack].

[![README Commercial Support][readme_commercial_support_img]][readme_commercial_support_link]

## DevOps Accelerator for Startups


We are a [**DevOps Accelerator**][commercial_support]. We'll help you build your cloud infrastructure from the ground up so you can own it. Then we'll show you how to operate it and stick around for as long as you need us. 

[![Learn More](https://img.shields.io/badge/learn%20more-success.svg?style=for-the-badge)][commercial_support]

Work directly with our team of DevOps experts via email, slack, and video conferencing.

We deliver 10x the value for a fraction of the cost of a full-time engineer. Our track record is not even funny. If you want things done right and you need it done FAST, then we're your best bet.

- **Reference Architecture.** You'll get everything you need from the ground up built using 100% infrastructure as code.
- **Release Engineering.** You'll have end-to-end CI/CD with unlimited staging environments.
- **Site Reliability Engineering.** You'll have total visibility into your apps and microservices.
- **Security Baseline.** You'll have built-in governance with accountability and audit logs for all changes.
- **GitOps.** You'll be able to operate your infrastructure via Pull Requests.
- **Training.** You'll receive hands-on training so your team can operate what we build.
- **Questions.** You'll have a direct line of communication between our teams via a Shared Slack channel.
- **Troubleshooting.** You'll get help to triage when things aren't working.
- **Code Reviews.** You'll receive constructive feedback on Pull Requests.
- **Bug Fixes.** We'll rapidly work with you to fix any bugs in our projects.

## Slack Community

Join our [Open Source Community][slack] on Slack. It's **FREE** for everyone! Our "SweetOps" community is where you get to talk with others who share a similar vision for how to rollout and manage infrastructure. This is the best place to talk shop, ask questions, solicit feedback, and work together as a community to build totally *sweet* infrastructure.

## Discourse Forums

Participate in our [Discourse Forums][discourse]. Here you'll find answers to commonly asked questions. Most questions will be related to the enormous number of projects we support on our GitHub. Come here to collaborate on answers, find solutions, and get ideas about the products and services we value. It only takes a minute to get started! Just sign in with SSO using your GitHub account.

## Newsletter

Sign up for [our newsletter][newsletter] that covers everything on our technology radar.  Receive updates on what we're up to on GitHub as well as awesome new projects we discover. 

## Office Hours

[Join us every Wednesday via Zoom][office_hours] for our weekly "Lunch & Learn" sessions. It's **FREE** for everyone! 

[![zoom](https://img.cloudposse.com/fit-in/200x200/https://cloudposse.com/wp-content/uploads/2019/08/Powered-by-Zoom.png")][office_hours]

## Contributing

### Bug Reports & Feature Requests

Please use the [issue tracker](https://github.com/cloudposse/terraform-aws-ecs-codepipeline/issues) to report any bugs or file feature requests.

### Developing

If you are interested in being a contributor and want to get involved in developing this project or [help out](https://cpco.io/help-out) with our other projects, we would love to hear from you! Shoot us an [email][email].

In general, PRs are welcome. We follow the typical "fork-and-pull" Git workflow.

 1. **Fork** the repo on GitHub
 2. **Clone** the project to your own machine
 3. **Commit** changes to your own branch
 4. **Push** your work back up to your fork
 5. Submit a **Pull Request** so that we can review your changes

**NOTE:** Be sure to merge the latest changes from "upstream" before making a pull request!


## Copyright

Copyright © 2017-2020 [Cloud Posse, LLC](https://cpco.io/copyright)



## License 

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0) 

See [LICENSE](LICENSE) for full details.

    Licensed to the Apache Software Foundation (ASF) under one
    or more contributor license agreements.  See the NOTICE file
    distributed with this work for additional information
    regarding copyright ownership.  The ASF licenses this file
    to you under the Apache License, Version 2.0 (the
    "License"); you may not use this file except in compliance
    with the License.  You may obtain a copy of the License at

      https://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing,
    software distributed under the License is distributed on an
    "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
    KIND, either express or implied.  See the License for the
    specific language governing permissions and limitations
    under the License.









## Trademarks

All other trademarks referenced herein are the property of their respective owners.

## About

This project is maintained and funded by [Cloud Posse, LLC][website]. Like it? Please let us know by [leaving a testimonial][testimonial]!

[![Cloud Posse][logo]][website]

We're a [DevOps Professional Services][hire] company based in Los Angeles, CA. We ❤️  [Open Source Software][we_love_open_source].

We offer [paid support][commercial_support] on all of our projects.  

Check out [our other projects][github], [follow us on twitter][twitter], [apply for a job][jobs], or [hire us][hire] to help with your cloud strategy and implementation.



### Contributors

|  [![Erik Osterman][osterman_avatar]][osterman_homepage]<br/>[Erik Osterman][osterman_homepage] | [![Igor Rodionov][goruha_avatar]][goruha_homepage]<br/>[Igor Rodionov][goruha_homepage] | [![Andriy Knysh][aknysh_avatar]][aknysh_homepage]<br/>[Andriy Knysh][aknysh_homepage] | [![Sarkis Varozian][sarkis_avatar]][sarkis_homepage]<br/>[Sarkis Varozian][sarkis_homepage] |
|---|---|---|---|

  [osterman_homepage]: https://github.com/osterman
  [osterman_avatar]: https://img.cloudposse.com/150x150/https://github.com/osterman.png
  [goruha_homepage]: https://github.com/goruha
  [goruha_avatar]: https://img.cloudposse.com/150x150/https://github.com/goruha.png
  [aknysh_homepage]: https://github.com/aknysh
  [aknysh_avatar]: https://img.cloudposse.com/150x150/https://github.com/aknysh.png
  [sarkis_homepage]: https://github.com/sarkis
  [sarkis_avatar]: https://img.cloudposse.com/150x150/https://github.com/sarkis.png

[![README Footer][readme_footer_img]][readme_footer_link]
[![Beacon][beacon]][website]

  [logo]: https://cloudposse.com/logo-300x69.svg
  [docs]: https://cpco.io/docs?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-ecs-codepipeline&utm_content=docs
  [website]: https://cpco.io/homepage?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-ecs-codepipeline&utm_content=website
  [github]: https://cpco.io/github?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-ecs-codepipeline&utm_content=github
  [jobs]: https://cpco.io/jobs?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-ecs-codepipeline&utm_content=jobs
  [hire]: https://cpco.io/hire?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-ecs-codepipeline&utm_content=hire
  [slack]: https://cpco.io/slack?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-ecs-codepipeline&utm_content=slack
  [linkedin]: https://cpco.io/linkedin?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-ecs-codepipeline&utm_content=linkedin
  [twitter]: https://cpco.io/twitter?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-ecs-codepipeline&utm_content=twitter
  [testimonial]: https://cpco.io/leave-testimonial?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-ecs-codepipeline&utm_content=testimonial
  [office_hours]: https://cloudposse.com/office-hours?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-ecs-codepipeline&utm_content=office_hours
  [newsletter]: https://cpco.io/newsletter?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-ecs-codepipeline&utm_content=newsletter
  [discourse]: https://ask.sweetops.com/?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-ecs-codepipeline&utm_content=discourse
  [email]: https://cpco.io/email?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-ecs-codepipeline&utm_content=email
  [commercial_support]: https://cpco.io/commercial-support?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-ecs-codepipeline&utm_content=commercial_support
  [we_love_open_source]: https://cpco.io/we-love-open-source?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-ecs-codepipeline&utm_content=we_love_open_source
  [terraform_modules]: https://cpco.io/terraform-modules?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-ecs-codepipeline&utm_content=terraform_modules
  [readme_header_img]: https://cloudposse.com/readme/header/img
  [readme_header_link]: https://cloudposse.com/readme/header/link?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-ecs-codepipeline&utm_content=readme_header_link
  [readme_footer_img]: https://cloudposse.com/readme/footer/img
  [readme_footer_link]: https://cloudposse.com/readme/footer/link?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-ecs-codepipeline&utm_content=readme_footer_link
  [readme_commercial_support_img]: https://cloudposse.com/readme/commercial-support/img
  [readme_commercial_support_link]: https://cloudposse.com/readme/commercial-support/link?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-ecs-codepipeline&utm_content=readme_commercial_support_link
  [share_twitter]: https://twitter.com/intent/tweet/?text=terraform-aws-ecs-codepipeline&url=https://github.com/cloudposse/terraform-aws-ecs-codepipeline
  [share_linkedin]: https://www.linkedin.com/shareArticle?mini=true&title=terraform-aws-ecs-codepipeline&url=https://github.com/cloudposse/terraform-aws-ecs-codepipeline
  [share_reddit]: https://reddit.com/submit/?url=https://github.com/cloudposse/terraform-aws-ecs-codepipeline
  [share_facebook]: https://facebook.com/sharer/sharer.php?u=https://github.com/cloudposse/terraform-aws-ecs-codepipeline
  [share_googleplus]: https://plus.google.com/share?url=https://github.com/cloudposse/terraform-aws-ecs-codepipeline
  [share_email]: mailto:?subject=terraform-aws-ecs-codepipeline&body=https://github.com/cloudposse/terraform-aws-ecs-codepipeline
  [beacon]: https://ga-beacon.cloudposse.com/UA-76589703-4/cloudposse/terraform-aws-ecs-codepipeline?pixel&cs=github&cm=readme&an=terraform-aws-ecs-codepipeline
