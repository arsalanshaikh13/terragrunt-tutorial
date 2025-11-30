

include "root" {
  path = find_in_parent_folders("common.hcl")
}

terraform {
  # source = "../../../../modules/app"
  # source = "${get_parent_terragrunt_dir()}/modules/app"
    # sourcing from terraform registry gitlab module
  # source = "tfr://gitlab.com/arsalanshaikh13/tf-modules/aws//app?version=0.0.8"

    # source = "git::https://gitlab.com/arsalanshaikh13/tf-modules.git//modules/app?ref=main"
    source = "git::ssh://git@gitlab.com/arsalanshaikh13/tf-modules.git//modules/app?ref=main"


   # You can also specify multiple extra arguments for each use case. Here we configure terragrunt to always pass in the
  # `common.tfvars` var file located by the parent terragrunt config.
  extra_arguments "custom_vars" {
    commands = [
      "apply",
      "plan",
      "import",
      "push",
      "refresh",
      "destroy"      
    ]

    # required_var_files = ["terraform.tfvars"]
    # required_var_files = ["${get_parent_terragrunt_dir()}/configuration/dev/us-east-1/app/app.tfvars"]
    required_var_files = ["${get_parent_terragrunt_dir()}/configuration/${basename(dirname(dirname(get_terragrunt_dir())))}/${basename(dirname(get_terragrunt_dir()))}/${basename(get_terragrunt_dir())}/app.tfvars"]
  }

  # The following are examples of how to specify hooks

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

dependency "network" {
  config_path                             = "../network"
  mock_outputs                            = { app_subnet_id = "subnet-3a1234abcd5678ef" }
  mock_outputs_allowed_terraform_commands = ["plan"]
}
inputs = {
  app_subnet_id = dependency.network.outputs.app_subnet_id
}
# TG_PROVIDER_CACHE=1 terragrunt run --non-interactive --all --  plan 
# TG_PROVIDER_CACHE=1 terragrunt run --non-interactive --all --  apply -auto-approve
# TG_PROVIDER_CACHE=1 terragrunt run --non-interactive --all --  destroy -auto-approve