#!/bin/bash

# 🔬 Deploy Simple Real Analysis Version
# Script deploy Lambda function với phân tích ảnh thực tế đơn giản (chỉ dùng PIL + numpy)

echo "🔬 DEPLOY SIMPLE REAL ANALYSIS VERSION"
echo "======================================"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration - Update existing function
FUNCTION_NAME="ImageAnalyzer"
REGION="ap-southeast-1"
ZIP_FILE="lambda-simple-real.zip"

echo -e "${BLUE}📋 Cấu hình Simple Real Analysis:${NC}"
echo "  • Function: $FUNCTION_NAME (cập nhật function hiện tại)"
echo "  • Region: $REGION"
echo "  • Phân tích: Thực tế với PIL + numpy"
echo ""

# Step 1: Prepare deployment package
echo -e "${BLUE}📦 Chuẩn bị Simple Real Analysis package...${NC}"

# Create temp directory
TEMP_DIR=$(mktemp -d)
echo "  • Temp directory: $TEMP_DIR"

# Copy Lambda function
cp "../lambda_function_simple_real.py" "$TEMP_DIR/lambda_function.py"

echo -e "${GREEN}✅ Đã copy Simple Real Analysis code${NC}"

# Step 2: Create deployment package (PIL đã có sẵn trong Lambda)
echo -e "${BLUE}📦 Tạo deployment package...${NC}"
cd "$TEMP_DIR"

# Create ZIP file
zip -r "$ZIP_FILE" . -q

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Package created: $(du -h $ZIP_FILE | cut -f1)${NC}"
else
    echo -e "${RED}❌ Failed to create package${NC}"
    exit 1
fi

# Step 3: Update existing Lambda function
echo -e "${BLUE}🚀 Cập nhật Lambda function với Simple Real Analysis...${NC}"

aws lambda update-function-code \
    --function-name $FUNCTION_NAME \
    --zip-file fileb://$ZIP_FILE \
    --region $REGION \
    --output table

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Function code updated successfully${NC}"
    
    # Update function configuration for better performance
    echo "  • Cập nhật configuration..."
    aws lambda update-function-configuration \
        --function-name $FUNCTION_NAME \
        --timeout 60 \
        --memory-size 1024 \
        --description "AI Image Analyzer v4.0 - Simple Real Analysis with PIL" \
        --region $REGION \
        --output table
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Function configuration updated${NC}"
    fi
else
    echo -e "${RED}❌ Function update failed${NC}"
    exit 1
fi

# Step 4: Test the function
echo -e "${BLUE}🧪 Testing Simple Real Analysis function...${NC}"

# Create test payload with a simple 1x1 pixel image
TEST_PAYLOAD='{
    "httpMethod": "POST",
    "body": "{\"bucket\":\"image-analyzer-workshop-1751722329\",\"image_data\":\"iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChAFfcULOdwAAAABJRU5ErkJggg==\"}"
}'

echo "  • Invoking function với test payload..."
aws lambda invoke \
    --function-name $FUNCTION_NAME \
    --payload "$TEST_PAYLOAD" \
    --region $REGION \
    response-simple-real.json \
    --output table

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Function test successful${NC}"
    
    if [ -f "response-simple-real.json" ]; then
        echo "  • Response preview:"
        head -c 500 response-simple-real.json
        echo ""
        echo "  • Full response saved to response-simple-real.json"
        
        # Check if response contains real analysis
        if grep -q "metrics_thuc_te.*true" response-simple-real.json; then
            echo -e "${GREEN}✅ Real metrics detected in response!${NC}"
        else
            echo -e "${YELLOW}⚠️ Response may be using fallback mode${NC}"
        fi
    fi
else
    echo -e "${RED}❌ Function test failed${NC}"
fi

# Step 5: Get function info
echo -e "${BLUE}📊 Function information:${NC}"
aws lambda get-function \
    --function-name $FUNCTION_NAME \
    --region $REGION \
    --query 'Configuration.[FunctionName,Runtime,Handler,Timeout,MemorySize,LastModified]' \
    --output table

# Cleanup
echo -e "${BLUE}🧹 Cleanup...${NC}"
cd - >/dev/null
rm -rf "$TEMP_DIR"

echo ""
echo -e "${GREEN}🎉 SIMPLE REAL ANALYSIS DEPLOYMENT COMPLETED!${NC}"
echo -e "${BLUE}📋 Summary:${NC}"
echo "  • Function: $FUNCTION_NAME"
echo "  • Version: Simple Real Analysis v4.0"
echo "  • Memory: 1024MB"
echo "  • Timeout: 60s"
echo "  • Status: Updated successfully"
echo ""
echo -e "${GREEN}🔬 REAL ANALYSIS FEATURES:${NC}"
echo "  • ✅ Brightness analysis (thực tế từ PIL ImageStat)"
echo "  • ✅ Contrast calculation (standard deviation)"
echo "  • ✅ Sharpness detection (edge filter)"
echo "  • ✅ Noise estimation (smooth filter comparison)"
echo "  • ✅ Dominant color extraction (pixel counting)"
echo "  • ✅ Color distribution analysis"
echo "  • ✅ Composition metrics (aspect ratio, golden ratio)"
echo "  • ✅ Texture analysis (edge density, emboss)"
echo "  • ✅ Real PSNR/SSIM estimation"
echo ""
echo -e "${BLUE}🌐 Test your REAL analysis at:${NC}"
echo "  http://ai-image-analyzer-web-1751723364.s3-website-ap-southeast-1.amazonaws.com"
echo ""
echo -e "${YELLOW}💡 Improvements over previous version:${NC}"
echo "  • Thay thế hard-coded values bằng calculations thực tế"
echo "  • Sử dụng PIL ImageStat cho metrics chính xác"
echo "  • Color analysis dựa trên pixel counting thực tế"
echo "  • Texture analysis với edge detection"
echo "  • Quality scoring dựa trên metrics thực tế"
echo ""
echo -e "${GREEN}Happy Real Analysis! 🎊${NC}"
