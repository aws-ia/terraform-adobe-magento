> Note: This module is in beta testing and likely contains bugs. It is not recommended for production use at this time.

# Terraform Adobe Commerce Quick Start
This module uses Terraform Cloud to deploy Magento on the Amazon Web Services (AWS) Cloud.

**Authors**

*James Cowie, Pat McManaman, and Mikko Sivula, Shero Commerce*

*Kenny Rajan, Dan Taoka, and Vikram Mehto, Amazon Web Services*

# Install Terraform
See [Install Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli).

# Sign up for Terraform Cloud
Sign up and log in to [Terraform Cloud](https://app.terraform.io/signup/account). A free tier is available if you don't have an account.

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

Example filepath:

`$HOME/.aws/terraform.tfvars`

Example tfvars file contents:
```
AWS_SECRET_ACCESS_KEY = "*****************"
AWS_ACCESS_KEY_ID = "*****************"
AWS_SESSION_TOKEN = "*****************"
```
> (Replace *** with AKEY and SKEY)

Note: Security Token Service (AWS STS)–based credentials are optional but recommended.

> WARNING: Follow best practices for managing secrets, and ensure that your credentials are not stored in a public repository.

> NOTE: Before deployment, you must create both an AWS key pair and a Magento deployment key.

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
9. Set **automatic rotation** to **Disabled**, and choose **Next**.
10. Review and store the key.

# Create Magento deployment keys
To create Magento deployment keys, see [Get your authentication keys](https://devdocs.magento.com/guides/v2.4/install-gde/prereq/connect-auth.html). This deployment uses [Composer](https://getcomposer.org/) to manage Magento components and their dependencies. For more information, see [Magento Composer](https://devdocs.magento.com/guides/v2.4/extension-dev-guide/intro/intro-composer.html).

1. Create a Magento public-authentication key for your Composer user name.
2. Create a Magento public-authentication key for your Composer password.

> Note these values because you will use them during the deployment.

# Deploy the module (Linux and iOS)

1. Clone the repository.
2. Navigate to the repository's root directory.
3. Navigate to the `setup_workspace` directory:
`cd setup_workspace`


Run the following commands in order:

```
terraform init
terraform apply or terraform apply -var-file="$HOME/.aws/terraform.tfvars"
```

You are asked for the following:
* The AWS Region where you want to deploy this module. This must match the Region where you generated the key pair.
* The organization under which Terraform Cloud runs. This can be found in the Terraform Cloud console.
* Setup confirmation.

Teraform Cloud creates the workspace, which contains the Terraform Cloud organization name and workspace.

Navigate to the directory to deploy dir (the previous command generates `backend.hcl`).

`cd ../deploy`

1. Open, edit, and review all of the variables in the `variables.tf` file.
2. Update the `default=` value for your deployment.
3. The `description=` gives additional context for each variable.

The following items must be edited before deployment:

* Project specific -> `domain_name`
* Magento information -> `mage_composer_username`
* Magento information -> `mage_composer_password`
* Magento information -> `magento_admin_password`
* Magento information -> `magento_admin_email`
* Database -> `magento_database_password`

> IMPORTANT: Don't store secret information in source control.

After you review and update the `./deploy/variables.tf` file, run the following Terraform command:
`terraform apply` or `terraform apply -var-file="$HOME/.aws/terraform.tfvars"`.

Terraform apply runs remotely in Terraform Cloud and takes about 30–60 minutes to deploy.

During the deployment, you should receive an AWS email to allow Amazon SES to send you emails. Verify this before you log in to Magento.

After the Terraform deployment completes, an output shows the relevant information for accessing Magento.
** IMPORTANT: Allow about 15–20 minutes for Magento to bootstrap after Terraform completes. Various Magento install and configuration commands run during this time, and the site enters maintenance mode. After it exits maintenance mode, images are synced to the Amazon S3 bucket, and you may see some missing images if you used the site while this is in progress.


# Test the Magento deployment
After Terraform completes, it outputs the frontend and backend URLs. Use the credentials specified in the `variables.tf` file to log in to the administrator's URL. Run the following command to connect to web node:
`ssh -i PATH_TO_GENERATED_KEY -J admin@BASTION_PUBLIC_IP admin@WEB_NODE_PRIVATE_IP`

Ensure you have SSH key forwarding enabled.

# Remove infrastructure
> NOTE: If you want to retain the Magento files stored in your Amazon S3 bucket, copy and save the bucket's objects before completing this step.

When you no longer need the infrastructure, run the following command to remove it:
`terraform destroy` or `terraform destroy -var-file="$HOME/.aws/terraform.tfvars"`.

After you remove the infrastructure, the database is stored as an artifact.
