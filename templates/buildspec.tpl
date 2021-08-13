version: 0.2
phases:
  pre_build:
    commands:
      - echo Logging in to Amazon ECR...
      - aws --version
      - export REPOSITORY_URI="$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$IMAGE_REPO_NAME"
      - aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $REPOSITORY_URI
  build:
    on-failure: ABORT
    commands:
      - echo Build started on `date`
      - echo Building image for $REPOSITORY_URI:latest and $REPOSITORY_URI:$IMAGE_TAG...
      - docker pull $REPOSITORY_URI:latest || true
      - docker build --cache-from $REPOSITORY_URI:latest --tag $REPOSITORY_URI:latest --tag $REPOSITORY_URI:$IMAGE_TAG .
  post_build:
    commands:
      - echo Build completed on `date`
      - echo Pushing to $REPOSITORY_URI:latest...
      - docker push $REPOSITORY_URI:latest
      - echo Pushing to $REPOSITORY_URI:$IMAGE_TAG...
      - docker push $REPOSITORY_URI:$IMAGE_TAG
      - echo Writing image detail file...
      - printf '{"ImageURI":"%s"}' $REPOSITORY_URI:$IMAGE_TAG > imageDetail.json
      %{~ if has_taskdef ~}
      - echo Writing task definition file...
      - |
        (
        cat <<EOF
        ${indent(8, taskdef)}
        EOF
        ) > ${taskdef_path}
      %{~ endif ~}
      %{~ if has_appspec ~}
      - echo Writing app spec file...
      - |
        (
        cat <<EOF
        ${indent(8, appspec)}
        EOF
        ) > ${appspec_path}
      %{~ endif ~}
artifacts:
  files: 
    - 'image*.json'
    %{~if has_taskdef ~}
    - '${taskdef_path}'
    %{~ endif ~}
    %{~if has_appspec ~}
    - '${appspec_path}'
    %{~ endif ~}
