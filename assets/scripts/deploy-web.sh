#!/bin/bash

# Deploy Web Interface to S3 Static Website Hosting
echo "🌐 Deploying Web Interface to AWS S3..."

# Variables
WEB_BUCKET_NAME="ai-image-analyzer-web-$(date +%s)"
REGION="ap-southeast-1"
ACCOUNT_ID="741448948262"

echo "📋 Configuration:"
echo "   Web Bucket: $WEB_BUCKET_NAME"
echo "   Region: $REGION"
echo "   Account: $ACCOUNT_ID"
echo ""

# Create S3 bucket for web hosting
echo "📦 Creating S3 bucket for web hosting: $WEB_BUCKET_NAME"
aws s3 mb s3://$WEB_BUCKET_NAME --region $REGION

if [ $? -eq 0 ]; then
    echo "✅ Web bucket created successfully"
else
    echo "❌ Failed to create web bucket"
    exit 1
fi

# Configure bucket for static website hosting
echo "🌐 Configuring static website hosting..."
aws s3 website s3://$WEB_BUCKET_NAME --index-document index.html --error-document error.html

# Remove public access block
echo "🔓 Configuring bucket for public access..."
aws s3api put-public-access-block \
    --bucket $WEB_BUCKET_NAME \
    --public-access-block-configuration \
    "BlockPublicAcls=false,IgnorePublicAcls=false,BlockPublicPolicy=false,RestrictPublicBuckets=false"

# Create bucket policy for public read
echo "📜 Setting bucket policy for public read..."
aws s3api put-bucket-policy --bucket $WEB_BUCKET_NAME --policy '{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::'$WEB_BUCKET_NAME'/*"
        }
    ]
}'

# Upload web files
echo "📤 Uploading web files to S3..."
aws s3 sync ../web/ s3://$WEB_BUCKET_NAME/ --delete

# Create error page
echo "❌ Creating error page..."
cat > ../web/error.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>Error - AI Image Analyzer</title>
    <style>
        body { font-family: Arial, sans-serif; text-align: center; padding: 50px; }
        .error { color: #f44336; font-size: 24px; margin-bottom: 20px; }
        .message { font-size: 16px; color: #666; }
        .btn { background: #4ECDC4; color: white; padding: 10px 20px; text-decoration: none; border-radius: 5px; }
    </style>
</head>
<body>
    <div class="error">❌ Page Not Found</div>
    <div class="message">The page you're looking for doesn't exist.</div>
    <br>
    <a href="/" class="btn">🏠 Go Home</a>
</body>
</html>
EOF

# Upload error page
aws s3 cp ../web/error.html s3://$WEB_BUCKET_NAME/error.html

# Get website URL
WEBSITE_URL="http://${WEB_BUCKET_NAME}.s3-website-${REGION}.amazonaws.com"

echo ""
echo "✅ Web deployment completed!"
echo "🌐 Website URL: $WEBSITE_URL"
echo "📝 Bucket: $WEB_BUCKET_NAME"
echo "🌍 Region: $REGION"
echo ""
echo "🔗 You can now access your website at:"
echo "   $WEBSITE_URL"

# Save website URL
mkdir -p ../output
echo $WEBSITE_URL > ../output/website-url.txt
echo $WEB_BUCKET_NAME > ../output/web-bucket-name.txt

echo ""
echo "✅ Website URL saved to output/website-url.txt"
echo "🎯 Next: Test your live website!"
