#!/bin/bash

# Exit on any error
set -e

# #region agent log - Hypothesis A: Check environment variables
echo "[DEBUG-A] Checking AWS_BUCKET environment variable..."
if [ -z "$AWS_BUCKET" ]; then
    echo "[ERROR-A] AWS_BUCKET is not set! Deployment will fail."
    exit 1
else
    echo "[DEBUG-A] AWS_BUCKET is set to: $AWS_BUCKET"
fi

echo "[DEBUG-A] Checking AWS credentials..."
if [ -z "$AWS_ACCESS_KEY_ID" ]; then
    echo "[ERROR-A] AWS_ACCESS_KEY_ID is not set!"
    exit 1
else
    echo "[DEBUG-A] AWS_ACCESS_KEY_ID is set (first 8 chars): ${AWS_ACCESS_KEY_ID:0:8}..."
fi
# #endregion

# #region agent log - Hypothesis B: Check if www directory exists
echo "[DEBUG-B] Checking if www/ directory exists..."
if [ ! -d "./www" ]; then
    echo "[ERROR-B] www/ directory does not exist! Build may have failed."
    exit 1
else
    echo "[DEBUG-B] www/ directory exists"
    echo "[DEBUG-B] Contents of www/ directory:"
    ls -la ./www | head -20
    echo "[DEBUG-B] Total files in www/: $(find ./www -type f | wc -l)"
fi
# #endregion

echo "Deploying frontend to S3 bucket: $AWS_BUCKET"

# #region agent log - Hypothesis C: Test AWS CLI and S3 access
echo "[DEBUG-C] Testing AWS CLI configuration..."
aws --version || echo "[ERROR-C] AWS CLI not installed!"
echo "[DEBUG-C] Testing S3 access to bucket..."
aws s3 ls s3://$AWS_BUCKET/ || echo "[ERROR-C] Cannot list S3 bucket - permission issue?"
# #endregion

# #region agent log - Hypothesis D: Upload with verbose output
echo "[DEBUG-D] Starting recursive upload to S3..."
# Upload all files to S3 bucket
if aws s3 cp --recursive --acl public-read ./www s3://$AWS_BUCKET/ 2>&1; then
    echo "[DEBUG-D] Recursive upload completed successfully"
else
    UPLOAD_EXIT_CODE=$?
    echo "[ERROR-D] Recursive upload failed with exit code: $UPLOAD_EXIT_CODE"
    exit $UPLOAD_EXIT_CODE
fi
# #endregion

# #region agent log - Hypothesis D: Upload index.html
echo "[DEBUG-D] Uploading index.html with cache-control headers..."
# Upload index.html with no-cache headers
if aws s3 cp --acl public-read --cache-control="max-age=0, no-cache, no-store, must-revalidate" ./www/index.html s3://$AWS_BUCKET/ 2>&1; then
    echo "[DEBUG-D] index.html upload completed successfully"
else
    INDEX_EXIT_CODE=$?
    echo "[ERROR-D] index.html upload failed with exit code: $INDEX_EXIT_CODE"
    exit $INDEX_EXIT_CODE
fi
# #endregion

# #region agent log - Verify deployment
echo "[DEBUG-VERIFY] Verifying files were uploaded to S3..."
echo "[DEBUG-VERIFY] Listing files in S3 bucket:"
aws s3 ls s3://$AWS_BUCKET/ --recursive | head -20
echo "[DEBUG-VERIFY] Total files in S3: $(aws s3 ls s3://$AWS_BUCKET/ --recursive | wc -l)"
# #endregion

echo "Frontend deployment completed successfully!"