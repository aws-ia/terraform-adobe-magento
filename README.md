> Note: This module is in beta testing and likely contains bugs. It is not recommended for production use at this time.

# Terraform Adobe Commerce Quick Start
This module uses Terraform Cloud to deploy Magento on the Amazon Web Services (AWS) Cloud.

**Authors**

James Cowie, Pat McManaman, and Mikko Sivula, Shero Commerce

Kenny Rajan, Dan Taoka, and Vikram Mehto, Amazon Web Services

# Install Terraform
See [Install Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli).

# Sign up for Terraform Cloud
Log in to [Terraform Cloud](https://app.terraform.io/signup/account). If you don't have an account, you can sign up for a free tier.

## Configure Terraform Cloud API access

Generate a Terraform Cloud token:

```
terraform login
```

Export the `TERRAFORM_CONFIG` variable:

```
export TERRAFORM_CONFIG="$HOME/.terraform.d/credentials.tfrc.json"
```

# Configure the `tfvars` file

Example path:

```
$HOME/.aws/terraform.tfvars
```

An example of the `tfvars` file contents:

```
AWS_SECRET_ACCESS_KEY = "{insert secret access key}"
AWS_ACCESS_KEY_ID = "{insert access key ID}"
AWS_SESSION_TOKEN = "{insert session token}"
```

> Note: We recommend using Security Token Service (AWS STS)–based credentials.

> Warning: Follow best practices for managing secrets, and ensure that your credentials are not stored in a public repository.

> Note: Before deployment, you must create both an AWS key pair and a Magento deployment key.

# Create an AWS key pair
To create a key pair, see [Prepare an AWS Account](https://docs.aws.amazon.com/quickstart/latest/magento/step1.html).

> Note the key-pair name because you will use it during the deployment.

## Store the private key in AWS Secrets Manager as plaintext

1. Navigate to AWS Secrets Manager in the AWS Management Console.
2. Store a new secret.
3. Choose **Other type of secrets**.
4. Choose **Plaintext"**.
5. Clear the `\{:}` JSON format from the **Plaintext** section.
6. Copy and paste the private-key contents that you previously created.
7. Select the encryption key, and choose **Next**. 
8. Set secret name to `ssh-key-admin`, and choose **Next**.
9. Set **Automatic rotation** to **Disabled**, and choose **Next**.
10. Review and store the key.

# Create Magento deployment keys

To create Magento deployment keys, see [Get your authentication keys](https://devdocs.magento.com/guides/v2.4/install-gde/prereq/connect-auth.html). This deployment uses [Composer](https://getcomposer.org/) to manage Magento components and their dependencies. For more information, see [Magento Composer](https://devdocs.magento.com/guides/v2.4/extension-dev-guide/intro/intro-composer.html).

* Create a Magento public-authentication key for your Composer user name.
* Create a Magento public-authentication key for your Composer password.

> Note these values because you will use them during the deployment.

# Deploy the module (Linux and iOS)

1. Clone the repository.
2. Navigate to the repository's root directory.
3. Navigate to the `setup_workspace` directory:

```
cd setup_workspace
```

Run the following commands in order:

```
terraform init
terraform apply or terraform apply -var-file="$HOME/.aws/terraform.tfvars"
```

You are asked for the following:
* The AWS Region where you want to deploy this module. This must match the Region where you generated the key pair.
* The organization under which Terraform Cloud runs. This can be found in the Terraform Cloud console.
* Setup confirmation.

Terraform Cloud creates the workspace, which contains the Terraform Cloud organization name.

Navigate to the directory to deploy dir (the previous command generates `backend.hcl`).

```
cd ../deploy
```

1. Open, edit, and review all of the variables in the `variables.tf` file.
2. Update the `default=` value for your deployment.
3. The `description=` provides additional context for each variable.

The following items must be edited before deployment:

* Project-specific -> `domain_name`
* Magento information -> `mage_composer_username`
* Magento information -> `mage_composer_password`
* Magento information -> `magento_admin_password`
* Magento information -> `magento_admin_email`
* Database -> `magento_database_password`

> Important: Don't store secret information in a public repository.

After you review and update the `./deploy/variables.tf` file, run one of the following Terraform commands:

```
terraform apply
terraform apply -var-file="$HOME/.aws/terraform.tfvars"
```

Terraform apply runs remotely in Terraform Cloud and takes about 30–60 minutes to deploy.

During the deployment, you should receive an AWS email to allow Amazon SES to send you emails. Verify this before you log in to Magento.

After the Terraform deployment completes, an output shows the relevant information for accessing Magento.

> Important: After Terraform completes, Magento bootstraps the environment, which takes about 15–20 minutes. Various Magento install and configuration commands run during this time, and the site enters maintenance mode. After it exits maintenance mode, images sync with your Amazon Simple Storage Service (Amazon S3) bucket.


# Test the Magento deployment
After Terraform completes, it outputs the frontend and backend URLs. Use the credentials specified in the `variables.tf` file to log in as an administrator. Run the following command to connect to the web node:

```
ssh -i PATH_TO_GENERATED_KEY -J admin@BASTION_PUBLIC_IP admin@WEB_NODE_PRIVATE_IP
```

> Note: Ensure that you have SSH key forwarding enabled.

# Clean up the infrastructure

> Note: If you want to retain the Magento files stored in your Amazon S3 bucket, copy and save the bucket's objects before completing this step.

When you no longer need the infrastructure, run one of the following commands to remove it:

```
terraform destroy
terraform destroy -var-file="$HOME/.aws/terraform.tfvars
```

After you remove the infrastructure, the database is stored as an artifact.
