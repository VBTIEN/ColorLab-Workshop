#!/bin/bash

# 🔧 Deploy S3 Folder Fix Version
# Script này sẽ deploy Lambda function với fix lỗi tạo folder S3

echo "🚀 DEPLOY S3 FOLDER FIX VERSION"
echo "================================"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
FUNCTION_NAME="image-analyzer-workshop"
REGION="ap-southeast-1"
LAMBDA_DIR="../src/lambda"
ZIP_FILE="lambda-s3-folder-fix.zip"

echo -e "${BLUE}📋 Cấu hình:${NC}"
echo "  • Function: $FUNCTION_NAME"
echo "  • Region: $REGION"
echo "  • Source: $LAMBDA_DIR"
echo ""

# Step 1: Check if function exists
echo -e "${BLUE}🔍 Kiểm tra Lambda function...${NC}"
if aws lambda get-function --function-name $FUNCTION_NAME --region $REGION >/dev/null 2>&1; then
    echo -e "${GREEN}✅ Function đã tồn tại${NC}"
    FUNCTION_EXISTS=true
else
    echo -e "${YELLOW}⚠️ Function chưa tồn tại${NC}"
    FUNCTION_EXISTS=false
fi

# Step 2: Prepare deployment package
echo -e "${BLUE}📦 Chuẩn bị deployment package...${NC}"

# Create temp directory
TEMP_DIR=$(mktemp -d)
echo "  • Temp directory: $TEMP_DIR"

# Copy Lambda function
cp "$LAMBDA_DIR/lambda_function_s3_fixed.py" "$TEMP_DIR/lambda_function.py"
cp "$LAMBDA_DIR/requirements.txt" "$TEMP_DIR/"

echo -e "${GREEN}✅ Đã copy source code${NC}"

# Step 3: Create deployment package
echo -e "${BLUE}📦 Tạo deployment package...${NC}"
cd "$TEMP_DIR"

# Install dependencies if requirements.txt exists
if [ -f "requirements.txt" ]; then
    echo "  • Installing dependencies..."
    pip install -r requirements.txt -t . --quiet
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Dependencies installed${NC}"
    else
        echo -e "${YELLOW}⚠️ Some dependencies may have failed${NC}"
    fi
fi

# Create ZIP file
zip -r "$ZIP_FILE" . -q
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Deployment package created${NC}"
else
    echo -e "${RED}❌ Failed to create deployment package${NC}"
    exit 1
fi

# Step 4: Deploy or Update function
echo -e "${BLUE}🚀 Deploying Lambda function...${NC}"

if [ "$FUNCTION_EXISTS" = true ]; then
    # Update existing function
    echo "  • Updating existing function..."
    
    aws lambda update-function-code \
        --function-name $FUNCTION_NAME \
        --zip-file fileb://$ZIP_FILE \
        --region $REGION \
        --output table
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Function code updated successfully${NC}"
        
        # Update function configuration
        echo "  • Updating function configuration..."
        aws lambda update-function-configuration \
            --function-name $FUNCTION_NAME \
            --timeout 60 \
            --memory-size 1024 \
            --description "AI Image Analyzer v3.1 - S3 Folder Fix" \
            --region $REGION \
            --output table
        
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✅ Function configuration updated${NC}"
        else
            echo -e "${YELLOW}⚠️ Configuration update failed, but code was updated${NC}"
        fi
    else
        echo -e "${RED}❌ Function update failed${NC}"
        exit 1
    fi
else
    echo -e "${YELLOW}⚠️ Function doesn't exist. Please create it first using the main setup script.${NC}"
    exit 1
fi

# Step 5: Test the function
echo -e "${BLUE}🧪 Testing function...${NC}"

# Create test payload
TEST_PAYLOAD='{
    "httpMethod": "POST",
    "body": "{\"bucket\":\"image-analyzer-workshop-1751722329\",\"image_data\":\"iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8/5+hHgAHggJ/PchI7wAAAABJRU5ErkJggg==\"}"
}'

echo "  • Invoking function with test payload..."
aws lambda invoke \
    --function-name $FUNCTION_NAME \
    --payload "$TEST_PAYLOAD" \
    --region $REGION \
    response.json \
    --output table

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Function invocation successful${NC}"
    
    # Check response
    if [ -f "response.json" ]; then
        echo "  • Response preview:"
        head -c 200 response.json
        echo ""
        echo "  • Full response saved to response.json"
    fi
else
    echo -e "${RED}❌ Function test failed${NC}"
fi

# Step 6: Get function info
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
echo -e "${GREEN}✅ Cleanup completed${NC}"

echo ""
echo -e "${GREEN}🎉 DEPLOYMENT COMPLETED!${NC}"
echo -e "${BLUE}📋 Summary:${NC}"
echo "  • Function: $FUNCTION_NAME"
echo "  • Version: 3.1 - S3 Folder Fix"
echo "  • Region: $REGION"
echo "  • Status: Updated successfully"
echo ""
echo -e "${YELLOW}🔧 New Features in v3.1:${NC}"
echo "  • ✅ Automatic S3 folder structure creation"
echo "  • ✅ Enhanced upload verification"
echo "  • ✅ Better error handling"
echo "  • ✅ Comprehensive metadata"
echo "  • ✅ Folder marker creation"
echo ""
echo -e "${BLUE}🌐 Test your function at:${NC}"
echo "  http://ai-image-analyzer-web-1751723364.s3-website-ap-southeast-1.amazonaws.com"
echo ""
echo -e "${GREEN}Happy analyzing! 🎊${NC}"
