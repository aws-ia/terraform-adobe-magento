> Note: This module is in alpha state and is likely to contain bugs and updates may introduce breaking changes. It is not recommended for production use at this time.

# Terraform Adobe Commerce Quick Start
This module is designed to deploy Magento into your AWS account using Terraform Cloud.  

Authors:   
James Cowie, Pat McManaman, Mikko Sivula - _Shero Commerce_  
Kenny Rajan, Dan Taoka, Vikram Mehto - _Solutions Architects, Amazon Web Services_

    
# Install Terraform
To deploy this module, do the following:

Install Terraform. (See [Install Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli) for a tutorial.) 

# Sign up for Terraform Cloud
Sign up and log into [Terraform Cloud](https://app.terraform.io/signup/account). (There is a free tier available.)

## Configure Terraform Cloud API Access

Generate terraform cloud token

`terraform login` 

Export the TERRAFORM_CONFIG variable

`export TERRAFORM_CONFIG="$HOME/.terraform.d/credentials.tfrc.json"`

# Configure your tfvars file

_Example filepath_ = `$HOME/.aws/terraform.tfvars`

_Example tfvars file contents_ 

```
AWS_SECRET_ACCESS_KEY = "*****************"
AWS_ACCESS_KEY_ID = "*****************"
AWS_SESSION_TOKEN = "*****************"
```
> (replace *** with AKEY and SKEY)

Note: STS-based credentials _are optional_ but *highly recommended*. 

> !!!!CAUTION!!!!: Make sure your credential are secured ourside version control (and follow secrets mangement best practices)

```Prior to deployment, both an AWS key pair and a Magento Deployment key need to be created```

# Create AWS Key Pair
Create a key-pair in AWS Console, ([set up key-pair](https://docs.aws.amazon.com/quickstart/latest/magento/step1.html)). 
> Note the Key Pair name as it will be used during the deployment.

## Store the private key in Secrets Manager in AWS Console as plaintext

Navigate to the AWS Secrets Manager Service in the AWS Console
1. Store a new secret
2. Choose "Other type of secrets"
3. Choose "Plaintext" 
4. Clear the \{:} json format from the Plaintext section
5. Copy and paste in the contents of the private key that was created in the first step
6. Select the Encryption Key (Default if you don't have a specific key) and "Next" 
7. Set secret name to "ssh-key-admin" and "Next"
8. Leave automatic rotation to disabled and "Next"
9. Review and store the key

# Create Magento Keys for Deployment
This deployment use Magento [Composer](https://getcomposer.org/) to manage Magento components and their dependencies. See Adobe documentation to learn about [Magento Composer](https://devdocs.magento.com/guides/v2.4/extension-dev-guide/intro/intro-composer.html), and for [instructions](https://devdocs.magento.com/guides/v2.4/install-gde/prereq/connect-auth.html) on creating the keys. 

1. Create Magento public authentication key for Composer Username
2. Create Magento public authentication key for Composer Password

> Note these values as they are needed for deployment.


# Deploy this module (instruction for linux or mac)

Clone this repository.

Change directory to the root directory.

Change to setup_workspace directory

`cd setup_workspace`. 


Run to following commands in order:

`terraform init`

`terraform apply`  or `terraform apply  -var-file="$HOME/.aws/terraform.tfvars"`. 

You will be asked for the following -
1. The AWS region you plan on deploying to (needs to be the same region as the key pair above was created earlier)
2. The organization in Terraform Cloud the deployment will run under (can be found in the Terraform Cloud Console)
3. Confirmation of setup

Teraform Cloud will create the workspace

The ouputs from terraform will contain the Terraform Cloud Org Name and Workspace

Change directory to deploy dir (previous command auto generates backend.hcl)

`cd ../deploy`

Open, edit, and review all of the variables in the variables.tf file.  
Update the `default=` value for your deployment.  
The `description=` gives additional context on each variable
The items that need be edited prior to deployment are

* Project Specific -> `domain_name`  
* Magento Information -> `mage_composer_username`
* Magento Information -> `mage_composer_password`
* Magento Information -> `magento_admin_password`
* Magento Information -> `magento_admin_email`
* Database -> `magento_database_password`

> Do not store secret information in source control

Once the './deploy/variables.tf' file had been updated and reviewed, run the following Terraform command  
`terraform apply` or `terraform apply  -var-file="$HOME/.aws/terraform.tfvars"`.  

Terraform apply is run remotely in Terraform Cloud and will take 30-60 minutes to deploy. 

During the deployment you should receive an Amazon Web Services email to allow Amazon SES to send emails. Verification should be done prior to logging into the Magento system

Once the Terraform deployment has completed, an output will show the relevant information for accessing Magento
** Note - Please allow about 15-20 minutes for Magento to bootstrap after Terraform completes. Various Magento install and configuration commands will be run during this time and the site will go into maintenance mode.  Once out of maintenance mode, images will be synced to the S3 bucket, and you may see some missing images if using the site while this is in progress.  


# Test Your Magento Deployment
Once Terraform has completed, it will output the frontend and backend URLs.  
Use the credentials specified in the variables.tf file to login to the admin URL.  
You can connect to web node with the following -  
`ssh -i PATH_TO_GENERATED_KEY -J admin@BASTION_PUBLIC_IP admin@WEB_NODE_PRIVATE_IP`

Ensure you have SSH key forwarding enabled.

# Destroy infrastructure
When you no longer need the infrastructure, you can destroy it with  
`terraform destroy` or `terraform destroy  -var-file="$HOME/.aws/terraform.tfvars"`.  

> Before running this command, you will need to copy the objects of the S3 bucket used for the Magento files if you want to retain the content.  

On destroy, the database is backed up and left as an artifact. This can be manually deleleted if not needed.
