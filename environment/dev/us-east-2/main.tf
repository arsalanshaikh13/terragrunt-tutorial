terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend  "s3"{
    bucket         = "s3-backend-tutorial-terragrunt"
    key            = "tutorial/dev/us-east-2/network.tfstate"
    region         = "us-east-1"
    dynamodb_table = "dynanmo-state-lock"
    encrypt        = true
    use_lockfile   = true
  }
}

module "network" {
  source = "../../../modules/network"

  vpc_cidr = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  region = var.region

}