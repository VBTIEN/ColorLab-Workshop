#!/bin/bash

echo "🔧 Triển khai hệ thống đã sửa lỗi S3 và Tiếng Việt..."

REGION="ap-southeast-1"
FUNCTION_NAME="ImageAnalyzer"
WEB_BUCKET="ai-image-analyzer-web-1751723364"

# Deploy Lambda function với S3 fix
echo "📦 Triển khai Lambda function đã sửa lỗi..."
cd ../src/lambda

# Create package
rm -rf package
mkdir package
cp lambda_function_fixed.py package/lambda_function.py

cd package
zip -r ../lambda-fixed.zip .
cd ..

# Deploy to Lambda
aws lambda update-function-code \
    --function-name $FUNCTION_NAME \
    --zip-file fileb://lambda-fixed.zip \
    --region $REGION

echo "✅ Lambda function đã được cập nhật"

# Deploy Vietnamese web interface
echo "🌐 Triển khai giao diện tiếng Việt..."
cd ../../web

# Upload Vietnamese interface
aws s3 cp index-tieng-viet.html s3://$WEB_BUCKET/index-tieng-viet.html --region $REGION
aws s3 cp index-tieng-viet.html s3://$WEB_BUCKET/index.html --region $REGION

echo ""
echo "✅ Triển khai hoàn tất!"
echo "🔧 Đã sửa lỗi:"
echo "   • S3 upload với error handling tốt hơn"
echo "   • Toàn bộ giao diện chuyển sang tiếng Việt"
echo "   • Cải thiện xử lý lỗi và logging"
echo ""
echo "🌐 Website Tiếng Việt:"
echo "   http://$WEB_BUCKET.s3-website-$REGION.amazonaws.com"
echo ""
echo "🧪 Hãy test upload ảnh để kiểm tra S3 fix!"

# Cleanup
cd ../src/lambda
rm -rf package lambda-fixed.zip

