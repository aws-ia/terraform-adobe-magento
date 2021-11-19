package test

import (
	"context"
	"github.com/aws/aws-sdk-go-v2/service/ec2"
	"github.com/gruntwork-io/terratest/modules/logger"
	"github.com/gruntwork-io/terratest/modules/terraform"
	testStruct "github.com/gruntwork-io/terratest/modules/test-structure"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
	"log"
	"os"
	"path/filepath"
	"testing"
)

const (
	baseTestPath = "modules/base"
)

var baseVars = []map[string]interface{}{
	{"region": "us-east-1", "profile": "aws-quickstart"},
}

var baseTestCases = []testCase{
	{name: "validate subnet ids", function: validateSubnetIds},
	{name: "validate allow_all_out SecurityGroup", function: validateAllOut},
	{name: "use existing VPC", function: useExistingVPC},
}

func validateSubnetIds(t *testing.T, tfOpts *terraform.Options) {
	testIds := []string{
		"vpc_id", "subnet_private_id", "subnet_public_id", "subnet_private2_id",
		"subnet_public2_id", "rds_subnet_id", "rds_subnet2_id",
	}
	for _, name := range testIds {
		id := terraform.Output(t, tfOpts, name)
		assert.NotEmpty(t, id, "%s is empty", name)
		assert.Contains(t, id, "-", "%s (%s) does not contain a dash ('-')", name, id)
	}
}

func validateAllOut(t *testing.T, tfOpts *terraform.Options) {
	allOutId := terraform.Output(t, tfOpts, "sg_allow_all_out_id")
	assert.NotEmpty(t, allOutId)

	allOutGroup := securityGroups(t, []string{allOutId}, tfOpts)
	assert.NotNil(t, allOutGroup)

	egress := allOutGroup.SecurityGroups[0].IpPermissionsEgress
	assert.Equal(t, len(egress), 1)
}

// Run terraform plan with the output values of the VPC we just created.
// Assert that the existing VPC actually gets used and exist in the plan output.
func useExistingVPC(t *testing.T, exTfOpts *terraform.Options) {
	testDir, err := os.Getwd()
	require.Nil(t, err)
	tmpDir := testStruct.CopyTerraformFolderToTemp(t, "../", "modules/base")

	exclude := filepath.Join(tmpDir, "asg.tf")
	require.Nil(t, os.Remove(exclude))

	vars := map[string]interface{}{
		"region":                 "us-east-1",
		"profile":                "aws-quickstart",
		"create_vpc":             false,
		"vpc_cidr":               "10.0.0.0/16",
		"vpc_id":                 terraform.Output(t, exTfOpts, "vpc_id"),
		"vpc_public_subnet_id":   terraform.Output(t, exTfOpts, "subnet_public_id"),
		"vpc_public2_subnet_id":  terraform.Output(t, exTfOpts, "subnet_public2_id"),
		"vpc_private_subnet_id":  terraform.Output(t, exTfOpts, "subnet_private_id"),
		"vpc_private2_subnet_id": terraform.Output(t, exTfOpts, "subnet_private2_id"),
		"vpc_rds_subnet_id":      terraform.Output(t, exTfOpts, "rds_subnet_id"),
		"vpc_rds_subnet2_id":     terraform.Output(t, exTfOpts, "rds_subnet2_id"),
	}
	newTfOpts := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: tmpDir,
		VarFiles:     []string{testDir + "/no_vpc_create.tfvars"}, // FIXME: override test file variables if possible
		Vars:         vars,
		PlanFilePath: tmpDir + "/plan_useExistingVPC",
		EnvVars:      map[string]string{"AWS_DEFAULT_REGION": vars["region"].(string)},
		Logger:       logger.Discard,
	})

	plan := terraform.InitAndPlanAndShowWithStruct(t, newTfOpts)
	changes := plan.RawPlan.OutputChanges

	testOutputs := []string{
		"vpc_id", "nat_gateway_ip1", "nat_gateway_ip2", "rds_subnet2_id", "rds_subnet_id",
		"subnet_private2_id", "subnet_private_id", "subnet_public2_id",
		"subnet_public_id",
	}
	for _, name := range testOutputs {
		oldVal := terraform.Output(t, exTfOpts, name)
		newVal := changes[name].After
		log.Printf("Assert old output of %s (%s) is used in new plan\n", name, oldVal)
		assert.Equal(t, oldVal, newVal, "new plan output value (%s) is not old output value (%s)", newVal, oldVal)
	}

}

func securityGroups(t *testing.T, ids []string, tfOpts *terraform.Options) *ec2.DescribeSecurityGroupsOutput {
	svc := getEc2Client(tfOpts.Vars["profile"].(string), tfOpts.Vars["region"].(string))
	res, err := svc.DescribeSecurityGroups(
		context.TODO(),
		&ec2.DescribeSecurityGroupsInput{
			GroupIds: ids,
		},
	)
	assert.Nil(t, err)
	return res
}

func TestBase(t *testing.T) {
	RunTests(t, baseVars, baseTestCases, baseTestPath, []string{"asg.tf"})
}
