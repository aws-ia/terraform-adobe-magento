package test

import (
	"context"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/ec2"
	"github.com/gruntwork-io/terratest/modules/logger"
	"github.com/gruntwork-io/terratest/modules/terraform"
	testStruct "github.com/gruntwork-io/terratest/modules/test-structure"
	"github.com/stretchr/testify/require"
	"log"
	"os"
	"path/filepath"
	"testing"
)

type testCase struct {
	name     string
	function func(*testing.T, *terraform.Options)
}

func RunTests(t *testing.T, testVars []map[string]interface{}, testCases []testCase, testPath string, excludeFiles []string) {
	for _, testVar := range testVars {
		testVar := testVar
		region := testVar["region"].(string)
		t.Run("region_"+region, func(t *testing.T) {
			// t.Parallel()
			testDir, err := os.Getwd()
			require.Nil(t, err)
			tmpDir := testStruct.CopyTerraformFolderToTemp(t, "../", testPath)

			log.Printf("Test dir: %s\n", tmpDir)

			for _, f := range excludeFiles {
				rel := filepath.Join(tmpDir, f)
				if _, err := os.Stat(rel); err == nil {
					require.Nil(t, os.Remove(rel))
				} else {
					log.Fatalf("Excluded file %s does not exist", rel)
				}
			}

			tfOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
				TerraformDir: tmpDir,
				Vars:         testVar,
				VarFiles:     []string{testDir + "/test.tfvars"},
				EnvVars: map[string]string{
					// "TF_LOG":             "DEBUG",
					"AWS_DEFAULT_REGION": region,
				},
			})

			if os.Getenv("TERRATEST_QUIET") == "1" {
				tfOptions.Logger = logger.Discard
			}

			defer terraform.Destroy(t, tfOptions)
			terraform.Init(t, tfOptions)
			terraform.ApplyAndIdempotent(t, tfOptions)

			for _, testCase := range testCases {
				t.Run(testCase.name, func(t *testing.T) {
					testCase.function(t, tfOptions)
				})
			}
		})
	}
}

func getEc2Client(profile string, region string) *ec2.Client {
	conf, err := config.LoadDefaultConfig(
		context.TODO(),
		config.WithSharedConfigProfile(profile),
		config.WithRegion(region),
	)
	if err != nil {
		log.Fatalf("Failed to load AWS config, %v", err)
	}
	conf.Region = region
	return ec2.NewFromConfig(conf)
}
