package test

import (
	"fmt"
	"testing"

	http_helper "github.com/gruntwork-io/terratest/modules/http-helper"
	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestTerraform(t *testing.T) {
	t.Parallel()

	// Construct the terraform options with default retryable errors to handle the most common retryable errors in
	// terraform testing.
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../terraform",

		// Variables to pass to our Terraform code using -var options
		Vars: map[string]interface{}{
			"bucket_name": "comcast-challenge.jack.com",
			"index_document_path": "./index.html",
		},
	})

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)

	// Run `terraform output` to get the value of an output variable
	bucketID := terraform.Output(t, terraformOptions, "bucket_id")

	// Verify that our Bucket has a policy attached
	aws.AssertS3BucketPolicyExists(t, "us-east-1", bucketID)

	domainName := terraform.Output(t, terraformOptions, "domain")

	// For testing if static page is reachable and HTTP to HTTPS testing
	httpUrl := fmt.Sprintf("http://%s", domainName)
	httpsUrl := fmt.Sprintf("https://%s", domainName)

	// Test redirect to https
	httpStatusCode, httpBody := http_helper.HttpGet(t, httpUrl, nil)
	expectedStatus := 200
	assert.Equal(t, expectedStatus, httpStatusCode)

	// Test regular https connection
	httpsStatusCode, httpsBody := http_helper.HttpGet(t, httpsUrl, nil)
	assert.Equal(t, expectedStatus, httpsStatusCode)
	
	// Rreturn body of http and https requests should be identical
	assert.ObjectsAreEqual(httpBody, httpsBody)
}