BUCKET_NAME="s3-backend-tutorial-terragrunt"
if aws s3api head-bucket --bucket "$BUCKET_NAME" 2>/dev/null; then
    echo "Deleting S3 bucket: $BUCKET_NAME"
    # first delete all the version of the objects in the bucket
    aws s3api delete-objects \
      --bucket $BUCKET_NAME \
      --delete "$(aws s3api list-object-versions \
      --bucket $BUCKET_NAME \
      --query='{Objects: Versions[].{Key:Key,VersionId:VersionId}}')"

    
    aws s3api delete-objects \
      --bucket $BUCKET_NAME \
      --delete "$(aws s3api list-object-versions \
      --bucket $BUCKET_NAME \
      --query='{Objects: DeleteMarkers[].{Key:Key,VersionId:VersionId}}' \
      --output json)"



    # First, remove all objects in the bucket
    aws s3 rm "s3://$BUCKET_NAME" --recursive || true
    # Then delete the bucket
    aws s3 rb "s3://$BUCKET_NAME" --force || true

  
else
    echo "S3 bucket $BUCKET_NAME does not exist, skipping deletion"
fi

# # 7. Delete dynamodb table
echo "Cleaning up dyanmodb table"
# # Check if Tables exists
TABLE_NAME="dynanmo-state-lock"
if aws dynamodb describe-table --table-name $TABLE_NAME 2>/dev/null ; then
    echo "Deleting dyanmodb table: $TABLE_NAME"
    aws dynamodb delete-table --table-name $TABLE_NAME
else
    echo "dyanmodb table $TABLE_NAME does not exist, skipping deletion"
fi
