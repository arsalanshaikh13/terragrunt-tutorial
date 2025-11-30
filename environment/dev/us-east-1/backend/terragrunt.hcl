

# locals {
#     config = read_terragrunt_config("${get_repo_root()}/configuration/${basename(dirname(dirname(get_terragrunt_dir())))}/${basename(dirname(get_terragrunt_dir()))}/${basename(get_terragrunt_dir())}/backend.hcl")
#     bucket_name    = local.config.locals.bucket_name
#     dynamodb_table = local.config.locals.dynamodb_table
#     region        = local.config.locals.region
# }
terraform {
  # source = "../../../../modules/app"
  # source = "${get_parent_terragrunt_dir()}/modules/app"
  # sourcing from terraform registry gitlab module
  # source = "tfr://gitlab.com/arsalanshaikh13/tf-modules/aws//backend?version=0.0.8"
  # Notice the git:: prefix and the https protocol
  source = "git::https://gitlab.com/arsalanshaikh13/tf-modules.git//modules/backend?ref=main"
  # source = "git::ssh://git@gitlab.com/arsalanshaikh13/tf-modules.git//modules/backend?ref=main"
  

  #  # You can also specify multiple extra arguments for each use case. Here we configure terragrunt to always pass in the
  # # `common.tfvars` var file located by the parent terragrunt config.
  # extra_arguments "custom_vars" {
  #   commands = [
  #     "apply",
  #     "plan",
  #     "import",
  #     "push",
  #     "refresh",
  #     "destroy"      
  #   ]

  #   # required_var_files = ["terraform.tfvars"]
  #   # required_var_files = ["${get_parent_terragrunt_dir()}/configuration/dev/us-east-1/app/app.tfvars"]
  #   # required_var_files = ["${get_parent_terragrunt_dir()}/configuration/${basename(dirname(dirname(get_terragrunt_dir())))}/${basename(dirname(get_terragrunt_dir()))}/${basename(get_terragrunt_dir())}/backend.tfvars"]
  #   required_var_files = ["${get_repo_root()}/configuration/${basename(dirname(dirname(get_terragrunt_dir())))}/${basename(dirname(get_terragrunt_dir()))}/${basename(get_terragrunt_dir())}/backend.tfvars"]
  #   # required_var_files = ["${get_repo_root()}/configuration/${basename(dirname(get_terragrunt_dir()))}/${basename(get_terragrunt_dir())}/backend.tfvars"]
  # }

  ## The following are examples of how to specify hooks

  # Before apply or plan, run "echo Foo".
  before_hook "before_hook_1" {
    commands     = ["apply", "plan"]
    execute      = ["echo", "Foo"]
  }

  # Before apply, run "echo Bar". Note that blocks are ordered, so this hook will run after the previous hook to
  # "echo Foo". In this case, always "echo Bar" even if the previous hook failed.
  before_hook "before_hook_2" {
    commands     = ["apply"]
    execute      = ["echo", "Bar"]
    run_on_error = true
  }
}

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

inputs = {
  region = "${basename(dirname(get_terragrunt_dir()))}"
  bucket_name    = "s3-backend-tutorial-terragrunt-${basename(dirname(get_terragrunt_dir()))}"
  dynamodb_table = "dynanmo-state-lock-${basename(dirname(get_terragrunt_dir()))}"
  # bucket-name-environment-region format
  # dynamodb_table = "dynanmo-state-lock-${basename(dirname(dirname(get_terragrunt_dir())))}-${basename(dirname(get_terragrunt_dir()))}"
  # bucket_name = "s3-backend-tutorial-terragrunt-${basename(dirname(dirname(get_terragrunt_dir())))}-${basename(dirname(get_terragrunt_dir()))}"
}
# TG_PROVIDER_CACHE=1 terragrunt run --non-interactive --all --  plan 
# TG_PROVIDER_CACHE=1 terragrunt run --non-interactive --all --  apply -auto-approve
# TG_PROVIDER_CACHE=1 terragrunt run --non-interactive --all --  destroy -auto-approve