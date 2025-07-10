#!/bin/bash

# Image Analysis Workshop Setup Script
echo "🚀 Setting up Image Analysis Workshop..."

# Variables
BUCKET_NAME="image-analyzer-workshop-$(date +%s)"
REGION="ap-southeast-1"
ACCOUNT_ID="741448948262"

echo "📋 Configuration:"
echo "   Region: $REGION"
echo "   Account: $ACCOUNT_ID"
echo "   Bucket: $BUCKET_NAME"
echo ""

# Create S3 bucket for storing images
echo "📦 Creating S3 bucket: $BUCKET_NAME"
aws s3 mb s3://$BUCKET_NAME --region $REGION

if [ $? -eq 0 ]; then
    echo "✅ S3 bucket created successfully"
else
    echo "❌ Failed to create S3 bucket"
    exit 1
fi

# Configure bucket for public read (for demo purposes)
echo "🔓 Configuring bucket permissions..."
aws s3api put-public-access-block \
    --bucket $BUCKET_NAME \
    --public-access-block-configuration \
    "BlockPublicAcls=false,IgnorePublicAcls=false,BlockPublicPolicy=false,RestrictPublicBuckets=false"

# Create bucket policy for public read
aws s3api put-bucket-policy --bucket $BUCKET_NAME --policy '{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::'$BUCKET_NAME'/*"
        }
    ]
}'

# Create IAM role for Lambda
echo "🔐 Creating IAM role for Lambda..."
aws iam create-role --role-name ImageAnalyzerLambdaRole --assume-role-policy-document '{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "lambda.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}' --region $REGION

if [ $? -eq 0 ]; then
    echo "✅ IAM role created successfully"
else
    echo "⚠️  IAM role might already exist, continuing..."
fi

# Attach policies to Lambda role
echo "🔗 Attaching policies to Lambda role..."
aws iam attach-role-policy --role-name ImageAnalyzerLambdaRole --policy-arn arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole
aws iam attach-role-policy --role-name ImageAnalyzerLambdaRole --policy-arn arn:aws:iam::aws:policy/AmazonRekognitionFullAccess
aws iam attach-role-policy --role-name ImageAnalyzerLambdaRole --policy-arn arn:aws:iam::aws:policy/AmazonS3FullAccess
aws iam attach-role-policy --role-name ImageAnalyzerLambdaRole --policy-arn arn:aws:iam::aws:policy/AmazonBedrockFullAccess

# Wait for role to be ready
echo "⏳ Waiting for IAM role to be ready..."
sleep 10

echo "✅ Setup completed!"
echo "📝 Resources created:"
echo "   S3 Bucket: $BUCKET_NAME"
echo "   IAM Role: ImageAnalyzerLambdaRole"
echo "   Region: $REGION"
echo ""
echo "🔗 Next: Deploy Lambda function with ./deploy-lambda.sh"

# Save bucket name for later use
mkdir -p ../output
echo $BUCKET_NAME > ../output/bucket-name.txt
echo $REGION > ../output/region.txt
echo "✅ Configuration saved to output/ directory"
