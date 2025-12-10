#!/bin/bash

# Exit on any error
set -e

echo "Deploying frontend to S3 bucket: $AWS_BUCKET"

# Upload all files to S3 bucket
aws s3 cp --recursive --acl public-read ./www s3://$AWS_BUCKET/

# Upload index.html with no-cache headers
aws s3 cp --acl public-read --cache-control="max-age=0, no-cache, no-store, must-revalidate" ./www/index.html s3://$AWS_BUCKET/

echo "Frontend deployment completed successfully!"