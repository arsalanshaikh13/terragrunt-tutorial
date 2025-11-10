#!/bin/bash

# Define environments and regions
environments=("dev" "prod")
regions=("us-east-1" "us-east-2")

echo "🚀 Starting terraform.tfvars copy process..."
echo ""

# Loop through all combinations
for env in "${environments[@]}"; do
  for region in "${regions[@]}"; do
    # source_file="environment/${env}/${region}/terraform.tfvars"
    dest_dir="configuration/${env}/${region}/network"
    # dest_dir="environment/${env}/${region}" # only for deleting files from environment folder
    dest_file="${dest_dir}/terraform.tfvars"
    # network_file="${dest_dir}/network.tfvars"
    
    # Check if source file exists
    # if [[ ! -f "$source_file" ]]; then
    #   echo "⚠️  Skipping: Source file not found -> $source_file"
    #   continue
    # fi
    
    # Create destination directory if it doesn't exist
    if [[ ! -d "$dest_dir" ]]; then
      echo "📁 Creating directory: $dest_dir"
      mkdir -p "$dest_dir"
    fi
    
    # Copy the file
    # echo "📋 Copying: $source_file -> $dest_file"
    # cp "$source_file" "$dest_file"

    # echo " Deleting $dest_file"
    # rm -rf "$dest_file" 
    # rm -rf "$dest_file" "$dest_dir/.terraform.lock.hcl" "$dest_dir/.terragrunt-cache"

    # echo " Renaming $dest_file to $network_file
    # mv -v "$dest_file" "$network_file"
    
    if [[ $? -eq 0 ]]; then
      echo "✅ Success: $dest_file"
    else
      echo "❌ Failed: $dest_file"
    fi
    echo ""
  done
done

echo "🎉 Done! Processed all environments and regions."