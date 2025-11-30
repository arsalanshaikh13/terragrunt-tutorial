#!/bin/bash
set -euo pipefail

create_resources () {
  TG_PROVIDER_CACHE=1 terragrunt run --non-interactive --all --  apply -auto-approve --parallelism 1
}

#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR=$(pwd)

ENVIRONMENTS=("dev" "prod")
REGIONS=("us-east-1" "us-east-2")

for env in "${ENVIRONMENTS[@]}"; do
  echo -e "\n===== 🔥 Environment: $env ====="

  for region in "${REGIONS[@]}"; do
    REGION_PATH="$ROOT_DIR/environment/$env/$region"

    echo -e "\n➡️ Entering: $REGION_PATH"
    if [[ $env == "dev" && $region == "us-east-1" ]]; then
      echo "⚠️  Skipping dev/us-east-2 as it's not configured yet"
      continue
    fi
    if [[ ! -d "$REGION_PATH" ]]; then
      echo "⚠️  Skipping missing directory: $REGION_PATH"
      continue
    fi

    cd "$REGION_PATH"

    # run cleanup.sh if present
    echo "▶️ Running startup.sh inside $env / $region"
    create_resources
    # go back to ROOT_DIR
    cd "$ROOT_DIR"
    echo "⬅️ Returned to $ROOT_DIR"
  done

done

echo -e "\n🎉 All environments & regions processed successfully!"


