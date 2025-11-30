locals {
    bucket_name = "s3-backend-tutorial-terragrunt-dev1"
    dynamodb_table = "dynanmo-state-lock-dev1"
    region              = "us-east-1"
    provider_version      = {
        terraform = "~> 1.13.3"
        aws = "4.67.0"
  }
}

