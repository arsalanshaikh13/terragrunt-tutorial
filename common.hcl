# remote_state {
#   backend = "s3"
#   config = {
#     bucket         = "s3-backend-tutorial-terragrunt"
#     key            = "tutorial/dev/us-east-1/network.tfstate"
#     region         = "us-east-1"
#     dynamodb_table = "dynanmo-state-lock"
#     encrypt        = true
#     use_lockfile   = true
#   }
# }

locals {
  # path_relative_to_include() returns: "environment/dev/us-east-1/app"
  path_parts = split("/", path_relative_to_include())

  # Index 0 = environment
  # Index 1 = dev
  # Index 2 = us-east-1  <-- TARGET
  # Index 3 = app
#   aws_region = local.path_parts[2] 
#   # This grabs the item at index -2 (second from the end)
#   # It works for "environment/dev/us-east-1/app"
#   # It ALSO works for "my-org/environment/dev/us-east-1/app"
  aws_region = element(split("/", path_relative_to_include()), -2)
  env = element(split("/", path_relative_to_include()), -3)
  
#   aws_region = "us-east-1"
# 2. Detect if the current folder is named "backend"
  module_name = basename(path_relative_to_include())
  is_backend_module = local.module_name == "backend"
  
#     bucket_name = "s3-backend-tutorial-terragrunt"
#     dynamodb_table = "dynanmo-state-lock"

#    provider_version      = {
#         terraform = "~> 1.13.3"
#         aws = "4.67.0"
#   }
}
# #  Automatically generate provider.tf for all subfolders
generate "backend" {
  path      = "backend.tf"
  if_exists = "overwrite_terragrunt"
# 3. The Condition
  # Logic: Is this the backend folder? 
  # YES -> Generate a comment only (Terraform defaults to local state).
  # NO  -> Generate the real S3 backend block.
#   contents  = <<EOF
  contents = local.is_backend_module ? "# Backend module uses local state during bootstrapping" : <<EOF
terraform {
    backend  "s3"{
    bucket         = "s3-backend-tutorial-terragrunt-${local.aws_region}"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "${local.aws_region}"
    dynamodb_table = "dynanmo-state-lock-${local.aws_region}"
    encrypt        = true
    use_lockfile   = true
  }
}
EOF
}
    # bucket         = "s3-backend-tutorial-terragrunt-${local.env}-${local.aws_region}"
        # dynamodb_table = "dynanmo-state-lock-${local.env}-${local.aws_region}"


    # bucket         = "${local.bucket_name}"
    # dynamodb_table = "${local.dynamodb_table}"
    # region         = "us-east-1"

