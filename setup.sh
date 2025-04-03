#!/bin/bash
set -euo pipefail

S3_BUCKET=${S3_BUCKET:-nuxt-demo-s3-bucket}
REGION=${REGION:-us-east-1}

# Check if the S3 bucket exists
if ! aws s3api head-bucket --bucket "$S3_BUCKET" 2>/dev/null; then
    # Create the S3 bucket if it doesn't exist
    echo "Creating S3 bucket: $S3_BUCKET" >&2
    aws s3api create-bucket --bucket "$S3_BUCKET" --region $REGION --create-bucket-configuration LocationConstraint=$REGION
else
    echo "S3 bucket already exists: $S3_BUCKET" >&2
fi
