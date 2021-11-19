package test

import (
	http_helper "github.com/gruntwork-io/terratest/modules/http-helper"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"log"
	"testing"
	"time"
)

const (
	integrationTestPath = "examples/integration_test"
)

var testVars = []map[string]interface{}{
	{"region": "us-east-1", "profile": "aws-quickstart"},
}

var intTestCases = []testCase{
	{name: "not empty outputs", function: validateNotEmptyOutputs},
	{name: "valid email", function: validateEmail},
	{name: "valid RabbitMQ host", function: validateRabbitMQHost},
	{name: "valid magento urls", function: validateUrls},
	{name: "can ping frontend url", function: pingFrontendUrl},
}

func validateNotEmptyOutputs(t *testing.T, tfOpts *terraform.Options) {
	testOutputs := []string{
		"magento_rabbitmq_host", "magento_frontend_url", "magento_admin_url", "magento_admin_email",
		"magento_database_host", "magento_elasticsearch_host", "alb_external_dns_name",
		"magento_cache_host", "magento_session_host", "magento_files_s3",
	}
	for _, name := range testOutputs {
		out := terraform.Output(t, tfOpts, name)
		log.Println(out)
		assert.NotEmpty(t, out, "output %s is empty", name)
	}
}

func validateEmail(t *testing.T, tfOpts *terraform.Options) {
	out := terraform.Output(t, tfOpts, "magento_admin_email")
	assert.Contains(t, out, "@")
}

func validateRabbitMQHost(t *testing.T, tfOpts *terraform.Options) {
	out := terraform.OutputList(t, tfOpts, "magento_rabbitmq_host")
	assert.Equal(t, 1, len(out))
	assert.Contains(t, out[0], "amqps://")
}

func validateUrls(t *testing.T, tfOpts *terraform.Options) {
	url := terraform.Output(t, tfOpts, "magento_frontend_url")
	adminUrl := terraform.Output(t, tfOpts, "magento_admin_url")
	assert.NotContains(t, url, "https://")
	assert.NotEqual(t, url, adminUrl)
	assert.Greater(t, len(url), 10)
	assert.Greater(t, len(adminUrl), 10)
}

func pingFrontendUrl(t *testing.T, tfOpts *terraform.Options) {
	url := terraform.Output(t, tfOpts, "magento_frontend_url")
	http_helper.HttpGetWithRetryWithCustomValidation(t, "https://"+url, nil, 10, 10*time.Second, func(status int, content string) bool {
		return status == 200
	})
}

func TestFull(t *testing.T) {
	// t.Parallel()
	RunTests(t, testVars, intTestCases, integrationTestPath, []string{"../../modules/services/ses.tf", "../../modules/base/asg.tf"})
}
