#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <folder>"
  echo "Example: $0 environment"
  echo "Example: $0 configuration"
  exit 1
fi

ROOT_DIR=$(pwd)
FOLDER=${1:-environment}
SOURCE_REGION="dev1"

ENVIRONMENTS=("dev" "prod")
REGIONS=("us-east-1" "us-east-2")

SRC_PATH="$ROOT_DIR/$FOLDER/dev/us-east-1/backend"

update_tfvars() {
  local tfvars_file=$1
  local target_env=$2
  local target_region=$3
  
  if [[ -f "$tfvars_file" ]]; then
    echo "🔧 Updating region values inside $tfvars_file"
    local num="${target_region##*-}"
    sed -i "s/$SOURCE_REGION/${target_env}${num}/g" "$tfvars_file"
  else
    echo "⚠️ backend.tfvars not found: $tfvars_file"
  fi
}

for env in "${ENVIRONMENTS[@]}"; do
  echo "=== Processing environment: $env ==="
  
  for region in "${REGIONS[@]}"; do
    echo "=== Processing region: $region ==="
    
    # Handle dev/us-east-1 special case
    if [[ "$env" == "dev" && "$region" == "us-east-1" ]]; then
      if [[ "$FOLDER" == "environment" ]]; then
        echo "⚠️ backend source already exists for $env / $region, skipping copy."
      elif [[ "$FOLDER" == "configuration" ]]; then
        update_tfvars "$SRC_PATH/backend.tfvars" "$env" "$region"
      fi
      continue
    fi
    
    DEST_PATH="$ROOT_DIR/$FOLDER/$env/$region/backend"
    
    echo "➡️ Copying backend folder from $SOURCE_REGION → $region for $env"
    mkdir -p "$DEST_PATH"
    cp -r "$SRC_PATH/"* "$DEST_PATH/"
    
    # Update tfvars for configuration folder
    [[ "$FOLDER" == "configuration" ]] && update_tfvars "$DEST_PATH/backend.tfvars" "$env" "$region"
    
    echo "✔️ Completed for $env / $region"
  done
done

echo "🎉 All environments processed successfully!"