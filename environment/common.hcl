
#  Automatically generate provider.tf for all subfolders
generate "backend" {
  path      = "backend.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
    backend  "s3"{
    bucket         = "s3-backend-tutorial-terragrunt"
    key            = "${path_relative_to_include()}/network.tfstate"
    region         = "us-east-1"
    dynamodb_table = "dynanmo-state-lock"
    encrypt        = true
    use_lockfile   = true
  }
}
EOF
}

