#!/bin/bash

# 🔬 Deploy No-Numpy Real Analysis Version
# Script deploy Lambda function với phân tích ảnh thực tế - KHÔNG CẦN NUMPY

echo "🔬 DEPLOY NO-NUMPY REAL ANALYSIS VERSION"
echo "========================================"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration - Update existing function
FUNCTION_NAME="ImageAnalyzer"
REGION="ap-southeast-1"
ZIP_FILE="lambda-no-numpy.zip"

echo -e "${BLUE}📋 Cấu hình No-Numpy Real Analysis:${NC}"
echo "  • Function: $FUNCTION_NAME (cập nhật function hiện tại)"
echo "  • Region: $REGION"
echo "  • Dependencies: Chỉ PIL (có sẵn trong Lambda)"
echo "  • Phân tích: Thực tế với PIL ImageStat + Filters"
echo ""

# Step 1: Prepare deployment package
echo -e "${BLUE}📦 Chuẩn bị No-Numpy package...${NC}"

# Create temp directory
TEMP_DIR=$(mktemp -d)
echo "  • Temp directory: $TEMP_DIR"

# Copy Lambda function
cp "../lambda_function_no_numpy.py" "$TEMP_DIR/lambda_function.py"

echo -e "${GREEN}✅ Đã copy No-Numpy Real Analysis code${NC}"

# Step 2: Create deployment package (chỉ cần PIL - có sẵn trong Lambda)
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
echo -e "${BLUE}🚀 Cập nhật Lambda function với No-Numpy Real Analysis...${NC}"

aws lambda update-function-code \
    --function-name $FUNCTION_NAME \
    --zip-file fileb://$ZIP_FILE \
    --region $REGION \
    --output table

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Function code updated successfully${NC}"
    
    # Update function configuration
    echo "  • Cập nhật configuration..."
    aws lambda update-function-configuration \
        --function-name $FUNCTION_NAME \
        --timeout 60 \
        --memory-size 1024 \
        --description "AI Image Analyzer v5.0 - No-Numpy Real Analysis with PIL" \
        --region $REGION \
        --output table
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Function configuration updated${NC}"
    fi
else
    echo -e "${RED}❌ Function update failed${NC}"
    exit 1
fi

# Step 4: Wait for function to be ready
echo -e "${BLUE}⏳ Chờ function sẵn sàng...${NC}"
sleep 5

# Step 5: Test the function
echo -e "${BLUE}🧪 Testing No-Numpy Real Analysis function...${NC}"

# Create simple test payload
cat > test-payload.json << 'EOF'
{
    "httpMethod": "POST",
    "body": "{\"bucket\":\"image-analyzer-workshop-1751722329\",\"image_data\":\"iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChAFfcULOdwAAAABJRU5ErkJggg==\"}"
}
EOF

echo "  • Invoking function với test payload..."
aws lambda invoke \
    --function-name $FUNCTION_NAME \
    --payload file://test-payload.json \
    --region $REGION \
    response-no-numpy.json \
    --output table

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Function invocation successful${NC}"
    
    if [ -f "response-no-numpy.json" ]; then
        echo "  • Response preview:"
        head -c 500 response-no-numpy.json
        echo ""
        echo "  • Full response saved to response-no-numpy.json"
        
        # Check if response contains real analysis
        if grep -q "no_numpy.*true" response-no-numpy.json; then
            echo -e "${GREEN}✅ No-Numpy Real Analysis detected!${NC}"
        fi
        
        if grep -q "metrics_thuc_te.*true" response-no-numpy.json; then
            echo -e "${GREEN}✅ Real metrics confirmed!${NC}"
        fi
        
        # Check for errors
        if grep -q "error" response-no-numpy.json; then
            echo -e "${YELLOW}⚠️ Response contains errors, checking...${NC}"
            grep "error" response-no-numpy.json
        fi
    fi
else
    echo -e "${RED}❌ Function invocation failed${NC}"
fi

# Step 6: Get function info
echo -e "${BLUE}📊 Function information:${NC}"
aws lambda get-function \
    --function-name $FUNCTION_NAME \
    --region $REGION \
    --query 'Configuration.[FunctionName,Runtime,Handler,Timeout,MemorySize,LastModified,Description]' \
    --output table

# Cleanup
echo -e "${BLUE}🧹 Cleanup...${NC}"
rm -f test-payload.json
cd - >/dev/null
rm -rf "$TEMP_DIR"

echo ""
echo -e "${GREEN}🎉 NO-NUMPY REAL ANALYSIS DEPLOYMENT COMPLETED!${NC}"
echo -e "${BLUE}📋 Summary:${NC}"
echo "  • Function: $FUNCTION_NAME"
echo "  • Version: No-Numpy Real Analysis v5.0"
echo "  • Memory: 1024MB"
echo "  • Timeout: 60s"
echo "  • Dependencies: Chỉ PIL (built-in)"
echo "  • Status: Updated successfully"
echo ""
echo -e "${GREEN}🔬 NO-NUMPY REAL ANALYSIS FEATURES:${NC}"
echo "  • ✅ Brightness analysis (PIL ImageStat.mean)"
echo "  • ✅ Contrast calculation (PIL ImageStat.stddev)"
echo "  • ✅ Sharpness detection (PIL FIND_EDGES filter)"
echo "  • ✅ Noise estimation (smooth filter comparison)"
echo "  • ✅ Dominant color extraction (pixel grouping)"
echo "  • ✅ Color distribution analysis (real pixel data)"
echo "  • ✅ Composition metrics (aspect ratio, golden ratio)"
echo "  • ✅ Texture analysis (edge density, emboss filter)"
echo "  • ✅ Real PSNR/SSIM estimation (từ noise level)"
echo "  • ✅ Quality scoring (dựa trên metrics thực tế)"
echo ""
echo -e "${BLUE}🌐 Test your NO-NUMPY REAL analysis at:${NC}"
echo "  http://ai-image-analyzer-web-1751723364.s3-website-ap-southeast-1.amazonaws.com"
echo ""
echo -e "${YELLOW}💡 Key Improvements:${NC}"
echo "  • ❌ Loại bỏ dependency numpy (gây lỗi import)"
echo "  • ✅ Sử dụng PIL ImageStat cho metrics chính xác"
echo "  • ✅ Real color analysis với pixel counting"
echo "  • ✅ Edge detection thực tế với PIL filters"
echo "  • ✅ Noise estimation với smooth filter"
echo "  • ✅ Quality scoring dựa trên calculations thực tế"
echo "  • ✅ Tất cả metrics được tính từ ảnh thực, không hard-coded"
echo ""
echo -e "${GREEN}Ready for REAL analysis! 🎊${NC}"
