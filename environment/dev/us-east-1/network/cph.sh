#!/usr/bin/env bash
set -euo pipefail

# List of destination folders
# DEST_DIRS=(
#   "../../../prod/us-east-1/app/"
#   "../../us-east-2/network/"
#   "../../us-east-2/app/"
# )

# # Loop through each and copy
# for dir in "${DEST_DIRS[@]}"; do
#   echo "📦 Copying terragrunt.hcl to $dir"
#   cp terragrunt.hcl "$dir"
# done
DEST_DIRS=(
  "../../../prod"
  "../.."
)

for dest_dir in "${DEST_DIRS[@]}"; do

    for region in us-east-2 us-east-1; do
    for env in app; do
        dest="$dest_dir/${region}/${env}/"
        echo "📦 Copying terragrunt.hcl to $dest"
        cp terragrunt.hcl "$dest"
        # if [[ $env == "app" ]]; then
        #     echo "⚙️ Updating $dest/terragrunt.hcl (network → app)"
        #     sed -i "s/network/${env}/g" $dest/terragrunt.hcl
        # fi
    done
    done
done