version: 0.2
phases:
  pre_build:
    commands:
      - echo Logging in to Amazon ECR...
      - aws --version
      - aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $IMAGE_REPO_NAME
  build:
    commands:
      - echo Build started on `date`
      - echo Building image for $IMAGE_REPO_NAME:latest and $IMAGE_REPO_NAME:$IMAGE_TAG...
      - docker pull $IMAGE_REPO_NAME:latest || true
      - docker build --cache-from $IMAGE_REPO_NAME:latest --tag $IMAGE_REPO_NAME:latest --tag $IMAGE_REPO_NAME:$IMAGE_TAG .
  post_build:
    commands:
      - echo Build completed on `date`
      - echo Pushing to $IMAGE_REPO_NAME:latest...
      - docker push $IMAGE_REPO_NAME:latest
      - echo Pushing to $IMAGE_REPO_NAME:$IMAGE_TAG...
      - docker push $IMAGE_REPO_NAME:$IMAGE_TAG
      - echo Writing image detail file...
      - printf '{"ImageURI":"%s"}' $REPOSITORY_URI:$IMAGE_TAG > imageDetail.json
      %{ if has_taskdef ~}
      - echo Writing task definition file...
      - echo "${taskdef}" > ${taskdef_path}
      %{~ endif }
      %{if has_appspec ~}
      - echo Writing app spec file...
      - echo "${appspec}" > ${appspec_path}
      %{~ endif }
artifacts:
  files: 
    - 'image*.json'
    %{if has_taskdef}- '${taskdef_path}'%{ endif }
    %{if has_appspec}- '${appspec_path}'%{ endif }
