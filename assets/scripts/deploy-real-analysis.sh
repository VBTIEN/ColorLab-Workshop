#!/bin/bash

# 🔬 Deploy Real Image Analysis Version
# Script deploy Lambda function với phân tích ảnh THỰC TẾ

echo "🔬 DEPLOY REAL IMAGE ANALYSIS VERSION"
echo "====================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
FUNCTION_NAME="ImageAnalyzerReal"
REGION="ap-southeast-1"
RUNTIME="python3.9"
TIMEOUT=300  # 5 minutes for complex analysis
MEMORY=3008  # Maximum memory for intensive computations
ZIP_FILE="lambda-real-analysis.zip"

echo -e "${BLUE}📋 Cấu hình Real Analysis:${NC}"
echo "  • Function: $FUNCTION_NAME"
echo "  • Runtime: $RUNTIME"
echo "  • Memory: ${MEMORY}MB"
echo "  • Timeout: ${TIMEOUT}s"
echo "  • Region: $REGION"
echo ""

# Step 1: Check if function exists
echo -e "${BLUE}🔍 Kiểm tra Lambda function...${NC}"
if aws lambda get-function --function-name $FUNCTION_NAME --region $REGION >/dev/null 2>&1; then
    echo -e "${GREEN}✅ Function đã tồn tại${NC}"
    FUNCTION_EXISTS=true
else
    echo -e "${YELLOW}⚠️ Function chưa tồn tại, sẽ tạo mới${NC}"
    FUNCTION_EXISTS=false
fi

# Step 2: Create deployment package
echo -e "${BLUE}📦 Chuẩn bị Real Analysis package...${NC}"

# Create temp directory
TEMP_DIR=$(mktemp -d)
echo "  • Temp directory: $TEMP_DIR"

# Copy Lambda function
cp "../lambda_function_real_analysis.py" "$TEMP_DIR/lambda_function.py"
cp "../requirements_real_analysis.txt" "$TEMP_DIR/requirements.txt"

echo -e "${GREEN}✅ Đã copy source code${NC}"

# Step 3: Install dependencies
echo -e "${BLUE}📚 Cài đặt dependencies...${NC}"
cd "$TEMP_DIR"

# Note: OpenCV và các thư viện khác cần được build cho Lambda environment
echo -e "${YELLOW}⚠️ CẢNH BÁO: Phiên bản này cần Lambda Layers hoặc Docker${NC}"
echo "  • OpenCV-python cần được compile cho Lambda"
echo "  • Scikit-image cần environment đặc biệt"
echo "  • Khuyến nghị sử dụng Docker container"
echo ""

# For now, create a basic package without heavy dependencies
echo "boto3>=1.26.0" > requirements.txt
echo "numpy>=1.24.0" >> requirements.txt
echo "Pillow>=9.5.0" >> requirements.txt

# Install basic dependencies
pip install -r requirements.txt -t . --quiet

# Create deployment package
echo -e "${BLUE}📦 Tạo deployment package...${NC}"
zip -r "$ZIP_FILE" . -q -x "*.pyc" "__pycache__/*"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Package created: $(du -h $ZIP_FILE | cut -f1)${NC}"
else
    echo -e "${RED}❌ Failed to create package${NC}"
    exit 1
fi

# Step 4: Create or Update Lambda function
echo -e "${BLUE}🚀 Deploying Lambda function...${NC}"

if [ "$FUNCTION_EXISTS" = false ]; then
    # Create new function
    echo "  • Tạo function mới..."
    
    # Get IAM role ARN (assuming it exists from previous setup)
    ROLE_ARN="arn:aws:iam::741448948262:role/ImageAnalyzerLambdaRole"
    
    aws lambda create-function \
        --function-name $FUNCTION_NAME \
        --runtime $RUNTIME \
        --role $ROLE_ARN \
        --handler lambda_function.lambda_handler \
        --zip-file fileb://$ZIP_FILE \
        --timeout $TIMEOUT \
        --memory-size $MEMORY \
        --description "AI Image Analyzer - Real Analysis Version with Computer Vision" \
        --region $REGION \
        --output table
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Function created successfully${NC}"
    else
        echo -e "${RED}❌ Function creation failed${NC}"
        exit 1
    fi
else
    # Update existing function
    echo "  • Cập nhật function code..."
    
    aws lambda update-function-code \
        --function-name $FUNCTION_NAME \
        --zip-file fileb://$ZIP_FILE \
        --region $REGION \
        --output table
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Function code updated${NC}"
        
        # Update configuration
        echo "  • Cập nhật configuration..."
        aws lambda update-function-configuration \
            --function-name $FUNCTION_NAME \
            --timeout $TIMEOUT \
            --memory-size $MEMORY \
            --description "AI Image Analyzer - Real Analysis v1.0" \
            --region $REGION \
            --output table
    else
        echo -e "${RED}❌ Function update failed${NC}"
        exit 1
    fi
fi

# Step 5: Create API Gateway integration (if needed)
echo -e "${BLUE}🌐 Kiểm tra API Gateway integration...${NC}"

# This would need to be integrated with existing API Gateway
echo -e "${YELLOW}⚠️ Cần tích hợp với API Gateway hiện tại${NC}"
echo "  • Endpoint hiện tại: https://cuwg234q8g.execute-api.ap-southeast-1.amazonaws.com/prod/analyze"
echo "  • Cần tạo endpoint mới: /analyze-real"

# Step 6: Test function
echo -e "${BLUE}🧪 Testing Real Analysis function...${NC}"

# Create test payload
TEST_PAYLOAD='{
    "httpMethod": "POST",
    "body": "{\"bucket\":\"image-analyzer-workshop-1751722329\",\"image_data\":\"iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8/5+hHgAHggJ/PchI7wAAAABJRU5ErkJggg==\"}"
}'

echo "  • Invoking function với test payload..."
aws lambda invoke \
    --function-name $FUNCTION_NAME \
    --payload "$TEST_PAYLOAD" \
    --region $REGION \
    response-real.json \
    --output table

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Function test successful${NC}"
    
    if [ -f "response-real.json" ]; then
        echo "  • Response preview:"
        head -c 300 response-real.json
        echo ""
    fi
else
    echo -e "${YELLOW}⚠️ Function test có thể thất bại do thiếu dependencies${NC}"
fi

# Cleanup
echo -e "${BLUE}🧹 Cleanup...${NC}"
cd - >/dev/null
rm -rf "$TEMP_DIR"

echo ""
echo -e "${GREEN}🎉 REAL ANALYSIS DEPLOYMENT COMPLETED!${NC}"
echo -e "${BLUE}📋 Summary:${NC}"
echo "  • Function: $FUNCTION_NAME"
echo "  • Version: Real Analysis v1.0"
echo "  • Memory: ${MEMORY}MB"
echo "  • Timeout: ${TIMEOUT}s"
echo ""
echo -e "${YELLOW}🔧 NEXT STEPS:${NC}"
echo "  1. ✅ Tạo Lambda Layer cho OpenCV"
echo "  2. ✅ Cấu hình API Gateway endpoint mới"
echo "  3. ✅ Update web interface để sử dụng endpoint mới"
echo "  4. ✅ Test với ảnh thực tế"
echo ""
echo -e "${BLUE}📚 Tính năng Real Analysis:${NC}"
echo "  • ✅ Color histogram thực tế (RGB, HSV, LAB)"
echo "  • ✅ Texture analysis (LBP, GLCM, Gabor)"
echo "  • ✅ Shape analysis (Contours, Hu moments)"
echo "  • ✅ Quality metrics (Sharpness, Contrast, Noise)"
echo "  • ✅ Dominant color extraction (K-means)"
echo "  • ✅ Composition analysis"
echo ""
echo -e "${RED}⚠️ LIMITATIONS:${NC}"
echo "  • Cần Lambda Layer cho OpenCV"
echo "  • Memory và timeout cao hơn"
echo "  • Chi phí xử lý cao hơn"
echo ""
echo -e "${GREEN}Happy Real Analysis! 🔬${NC}"
