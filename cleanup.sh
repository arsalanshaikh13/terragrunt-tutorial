#!/bin/bash
set -euo pipefail

destroy_resources () {

    # destroy_order=(
    # "app"
    # "network" 
    # "backend"
    # )


    # echo "🔥 Destroying stacks sequentially..."

    # for dir in "${destroy_order[@]}"; do
    # echo "🧨 Destroying $dir..."
    
    # TG_PROVIDER_CACHE=1 terragrunt run \
    #     --non-interactive \
    #     --working-dir "$dir" \
    #     -- destroy -auto-approve --parallelism 20 
    # done

    rm -rf app/.terragrunt-cache app/.terraform.lock.hcl
    rm -rf network/.terragrunt-cache network/.terraform.lock.hcl
    rm -rf backend/.terragrunt-cache backend/.terraform.lock.hcl
}

#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR=$(pwd)

ENVIRONMENTS=("prod" "dev" )
REGIONS=("us-east-1" "us-east-2")

for env in "${ENVIRONMENTS[@]}"; do
  echo -e "\n===== 🔥 Environment: $env ====="

  for region in "${REGIONS[@]}"; do
    # if [[ $env == "prod"  ]]; then
    #   echo "⚠️  Skipping dev/us-east-2 as it's not configured yet"
    #   continue
    # fi
    REGION_PATH="$ROOT_DIR/environment/$env/$region"

    echo -e "\n➡️ Entering: $REGION_PATH"

    if [[ ! -d "$REGION_PATH" ]]; then
      echo "⚠️  Skipping missing directory: $REGION_PATH"
      continue
    fi

    cd "$REGION_PATH"

    # run cleanup.sh if present
    echo "▶️ Running cleanup.sh inside $env / $region"
    destroy_resources
    # go back to ROOT_DIR
    cd "$ROOT_DIR"
    echo "⬅️ Returned to $ROOT_DIR"
  done

done

# echo "removing backend stack separately"

# cd environment/dev/us-east-1 
#   TG_PROVIDER_CACHE=1 terragrunt run \
#         --non-interactive \
#         --working-dir "backend" \
#         -- destroy -auto-approve --parallelism 20 
#     done

#     rm -rf backend/.terragrunt-cache backend/.terraform.lock.hcl

echo -e "\n🎉 All environments & regions processed successfully!"


