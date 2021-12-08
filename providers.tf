provider "awscc" {
  region = var.region
  user_agent = [
    {
      product_name    = "terraform-adobe-magento"
      product_version = "0.0.1"
      comment         = "V1/AWS-D69B4015/406115080"

    }
  ]
}

provider "aws" {
  region  = var.region
  profile = var.profile
}
