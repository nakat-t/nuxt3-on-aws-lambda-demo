#!/bin/bash
set -euo pipefail

S3_BUCKET=${S3_BUCKET:-nuxt-demo-s3-bucket}
S3_PREFIX=${S3_PREFIX:-package-storage}
STACK_NAME=${STACK_NAME:-nuxt-demo-test-stack}

aws cloudformation package \
	--template-file cfn.yaml \
	--s3-bucket $S3_BUCKET \
	--s3-prefix $S3_PREFIX \
	--output-template-file .packaged.cfn.yaml

aws cloudformation validate-template \
	--template-body file://.packaged.cfn.yaml \
	--no-cli-pager

aws cloudformation deploy \
	--stack-name $STACK_NAME \
	--template-file .packaged.cfn.yaml \
	--capabilities CAPABILITY_NAMED_IAM

aws s3 rm --recursive "s3://$S3_BUCKET/$S3_PREFIX"

# Show CloudFront distribution URL
CLOUDFRONT_DOMAIN=$(aws cloudformation describe-stacks \
    --stack-name $STACK_NAME \
    --query "Stacks[0].Outputs[?OutputKey=='NuxtDistributionDomainName'].OutputValue" \
    --output text)

echo "CloudFront distribution URL: https://$CLOUDFRONT_DOMAIN"

aws s3 sync ./.output/public s3://nuxt-demo-public-bucket/ --delete
