#!/bin/bash
set -euo pipefail

S3_BUCKET=${S3_BUCKET:-nuxt-demo-s3-bucket}
STACK_NAME=${STACK_NAME:-nuxt-demo-test-stack}
REGION=${REGION:-us-east-1}

# Destroy the S3 bucket if exists
if aws s3api head-bucket --bucket "$S3_BUCKET" 2>/dev/null; then
    echo "Deleting S3 bucket: $S3_BUCKET" >&2
    aws s3 rm --recursive "s3://$S3_BUCKET/"
    aws s3api delete-bucket --bucket "$S3_BUCKET" --region $REGION
else
    echo "S3 bucket does not exist: $S3_BUCKET" >&2
fi
if aws s3api head-bucket --bucket "nuxt-demo-public-bucket" 2>/dev/null; then
    echo "Deleting S3 bucket: nuxt-demo-public-bucket" >&2
    aws s3 rm --recursive "s3://nuxt-demo-public-bucket/"
    aws s3api delete-bucket --bucket "nuxt-demo-public-bucket"
else
    echo "S3 bucket does not exist: $S3_BUCKET" >&2
fi

# Delete the CloudFormation stack
echo "Deleting CloudFormation stack: $STACK_NAME" >&2
aws cloudformation delete-stack --stack-name $STACK_NAME
aws cloudformation wait stack-delete-complete --stack-name $STACK_NAME

# Delete build artifacts
npx nuxi cleanup
rm -f lambda.zip
rm -f .packaged.cfn.yaml
