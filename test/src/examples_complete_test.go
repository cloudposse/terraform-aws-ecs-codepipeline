package test

import (
	"encoding/json"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

// Test the Terraform module in examples/complete using Terratest.
func TestExamplesComplete(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../../examples/complete",
		Upgrade:      true,
		// Variables to pass to our Terraform code using -var-file options
		VarFiles: []string{"fixtures.us-east-2.tfvars"},
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)

	// Run `terraform output` to get the value of an output variable
	jsonMap := terraform.OutputRequired(t, terraformOptions, "container_definition_json_map")
	// Verify we're getting back the outputs we expect
	var jsonObject map[string]interface{}
	err := json.Unmarshal([]byte(jsonMap), &jsonObject)
	assert.NoError(t, err)
	assert.Equal(t, "geodesic", jsonObject["name"])
	assert.Equal(t, "cloudposse/geodesic", jsonObject["image"])
	assert.Equal(t, 256, int((jsonObject["memory"]).(float64)))
	assert.Equal(t, 128, int((jsonObject["memoryReservation"]).(float64)))
	assert.Equal(t, 256, int((jsonObject["cpu"]).(float64)))
	assert.Equal(t, true, jsonObject["essential"])
	assert.Equal(t, false, jsonObject["readonlyRootFilesystem"])

	// Run `terraform output` to get the value of an output variable
	vpcCidr := terraform.Output(t, terraformOptions, "vpc_cidr")
	// Verify we're getting back the outputs we expect
	assert.Equal(t, "172.16.0.0/16", vpcCidr)

	// Run `terraform output` to get the value of an output variable
	privateSubnetCidrs := terraform.OutputList(t, terraformOptions, "private_subnet_cidrs")
	// Verify we're getting back the outputs we expect
	assert.Equal(t, []string{"172.16.0.0/19", "172.16.32.0/19"}, privateSubnetCidrs)

	// Run `terraform output` to get the value of an output variable
	publicSubnetCidrs := terraform.OutputList(t, terraformOptions, "public_subnet_cidrs")
	// Verify we're getting back the outputs we expect
	assert.Equal(t, []string{"172.16.96.0/19", "172.16.128.0/19"}, publicSubnetCidrs)

	// Run `terraform output` to get the value of an output variable
	ecsClusterId := terraform.Output(t, terraformOptions, "ecs_cluster_id")
	// Verify we're getting back the outputs we expect
	assert.Equal(t, "arn:aws:ecs:us-east-2:126450723953:cluster/eg-test-ecs-codepipeline", ecsClusterId)

	// Run `terraform output` to get the value of an output variable
	ecsClusterArn := terraform.Output(t, terraformOptions, "ecs_cluster_arn")
	// Verify we're getting back the outputs we expect
	assert.Equal(t, "arn:aws:ecs:us-east-2:126450723953:cluster/eg-test-ecs-codepipeline", ecsClusterArn)

	// Run `terraform output` to get the value of an output variable
	ecsExecRolePolicyName := terraform.Output(t, terraformOptions, "ecs_exec_role_policy_name")
	// Verify we're getting back the outputs we expect
	assert.Equal(t, "eg-test-ecs-codepipeline-exec", ecsExecRolePolicyName)

	// Run `terraform output` to get the value of an output variable
	serviceName := terraform.Output(t, terraformOptions, "service_name")
	// Verify we're getting back the outputs we expect
	assert.Equal(t, "eg-test-ecs-codepipeline", serviceName)

	// Run `terraform output` to get the value of an output variable
	serviceRoleArn := terraform.Output(t, terraformOptions, "service_role_arn")
	// Verify we're getting back the outputs we expect
	assert.Equal(t, "arn:aws:iam::126450723953:role/eg-test-ecs-codepipeline-service", serviceRoleArn)

	// Run `terraform output` to get the value of an output variable
	taskDefinitionFamily := terraform.Output(t, terraformOptions, "task_definition_family")
	// Verify we're getting back the outputs we expect
	assert.Equal(t, "eg-test-ecs-codepipeline", taskDefinitionFamily)

	// Run `terraform output` to get the value of an output variable
	taskExecRoleName := terraform.Output(t, terraformOptions, "task_exec_role_name")
	// Verify we're getting back the outputs we expect
	assert.Equal(t, "eg-test-ecs-codepipeline-exec", taskExecRoleName)

	// Run `terraform output` to get the value of an output variable
	taskExecRoleArn := terraform.Output(t, terraformOptions, "task_exec_role_arn")
	// Verify we're getting back the outputs we expect
	assert.Equal(t, "arn:aws:iam::126450723953:role/eg-test-ecs-codepipeline-exec", taskExecRoleArn)

	// Run `terraform output` to get the value of an output variable
	taskRoleName := terraform.Output(t, terraformOptions, "task_role_name")
	// Verify we're getting back the outputs we expect
	assert.Equal(t, "eg-test-ecs-codepipeline-task", taskRoleName)

	// Run `terraform output` to get the value of an output variable
	taskRoleArn := terraform.Output(t, terraformOptions, "task_role_arn")
	// Verify we're getting back the outputs we expect
	assert.Equal(t, "arn:aws:iam::126450723953:role/eg-test-ecs-codepipeline-task", taskRoleArn)

	// Run `terraform output` to get the value of an output variable
	codebuildProjectName := terraform.Output(t, terraformOptions, "codebuild_project_name")
	// Verify we're getting back the outputs we expect
	assert.Equal(t, "eg-test-ecs-codepipeline-build", codebuildProjectName)

	// Run `terraform output` to get the value of an output variable
	codebuildCacheS3BucketName := terraform.Output(t, terraformOptions, "codebuild_cache_bucket_name")
	// Verify we're getting back the outputs we expect
	assert.Contains(t, codebuildCacheS3BucketName, "eg-test-ecs-codepipeline-build")

	// Run `terraform output` to get the value of an output variable
	codepipelineId := terraform.Output(t, terraformOptions, "codepipeline_id")
	// Verify we're getting back the outputs we expect
	assert.Equal(t, "eg-test-ecs-codepipeline-codepipeline", codepipelineId)
}
