#!/usr/bin/env bash
aws cloudformation deploy --template-file ../templates/website.yaml --stack-name axisbot

# get S3 bucket location and https based url
echo $'\nS3 Bucket: '; aws cloudformation describe-stacks --stack-name axisbot --query "Stacks[0].Outputs[?OutputKey=='S3Bucket'].OutputValue" --no-paginate --output text
export S3Bucket=`aws cloudformation describe-stacks --stack-name axisbot --query "Stacks[0].Outputs[?OutputKey=='S3Bucket'].OutputValue" --no-paginate --output text`
export WEBSITEURL=`aws cloudformation describe-stacks --stack-name axisbot --query "Stacks[0].Outputs[?OutputKey=='WebSiteUrl'].OutputValue" --no-paginate --output text`
export PARENTORIGIN=`aws cloudformation describe-stacks --stack-name axisbot --query "Stacks[0].Outputs[?OutputKey=='ParentOriginForLexWebUi'].OutputValue" --no-paginate --output text`

echo $'\nLEX WEB UI PARENT ORIGIN: '
echo $PARENTORIGIN
echo $'\nWebsite URL:'
echo $WEBSITEURL
echo

# copy in the content to the S3 bucket with public read access
aws s3 cp ../web/index.html s3://$S3Bucket/index.html --acl public-read
aws s3 cp ../web/axis.png s3://$S3Bucket/axis.png --acl public-read
