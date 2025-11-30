# # remote_state {
# #   backend = "s3"
# #   config = {
# #     bucket         = "s3-backend-tutorial-terragrunt"
# #     key            = "tutorial/dev/us-east-1/network.tfstate"
# #     region         = "us-east-1"
# #     dynamodb_table = "dynanmo-state-lock"
# #     encrypt        = true
# #     use_lockfile   = true
# #   }
# # }
# include "global_mocks" {
#   path   = find_in_parent_folders("global-mocks.hcl")
#   expose = true
# }
locals {
    # config = read_terragrunt_config("${get_repo_root()}/configuration/${basename(dirname(dirname(get_terragrunt_dir())))}/${basename(dirname(get_terragrunt_dir()))}/${basename(get_terragrunt_dir())}/backend.hcl")
    config = read_terragrunt_config(find_in_parent_folders("common.hcl"))
    region        = local.config.locals.region
    # region = basename(get_terragrunt_dir())
    # bucket_name    = local.config.locals.bucket_name
    # dynamodb_table = local.config.locals.dynamodb_table
    # provider_version        = local.config.locals.provider_version
}

# # #  Automatically generate provider.tf for all subfolders
# generate "backend" {
#   path      = "backend.tf"
#   if_exists = "overwrite_terragrunt"
#   contents  = <<EOF
# terraform {
#     backend  "s3"{
#     bucket         = "${local.bucket_name}"
#     key            = "${path_relative_to_include()}/terraform.tfstate"
#     region         = "${local.region}"
#     dynamodb_table = "${local.dynamodb_table}"
#     encrypt        = true
#     use_lockfile   = true
#   }
# }
# EOF
# }

# Automatically generate provider.tf for all subfolders
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  required_version = "${local.provider_version["terraform"]}"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "${local.provider_version["aws"]}"
    }
  }
}

provider "aws" {
  region = "${local.region}"
}
EOF
}

#     # bucket         = "s3-backend-tutorial-terragrunt"
#     # dynamodb_table = "dynanmo-state-lock"
#     # region         = "us-east-1"

