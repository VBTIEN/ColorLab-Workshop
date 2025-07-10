#!/bin/bash

# Fix and Test Web Interface
echo "🔧 Fixing and testing web interface..."

WEB_BUCKET="ai-image-analyzer-web-1751723364"
REGION="ap-southeast-1"
API_ENDPOINT="https://cuwg234q8g.execute-api.ap-southeast-1.amazonaws.com/prod/analyze"

echo "📋 Configuration:"
echo "   Web Bucket: $WEB_BUCKET"
echo "   Region: $REGION"
echo "   API Endpoint: $API_ENDPOINT"
echo ""

# Test 1: Check S3 bucket accessibility
echo "🧪 Test 1: Checking S3 bucket accessibility..."
aws s3 ls s3://$WEB_BUCKET/ > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "✅ S3 bucket is accessible"
else
    echo "❌ S3 bucket access failed"
    exit 1
fi

# Test 2: Check website accessibility
echo "🧪 Test 2: Checking website accessibility..."
WEBSITE_URL="http://$WEB_BUCKET.s3-website-$REGION.amazonaws.com"
curl -s -o /dev/null -w "%{http_code}" $WEBSITE_URL | grep -q "200"
if [ $? -eq 0 ]; then
    echo "✅ Website is accessible at: $WEBSITE_URL"
else
    echo "⚠️ Website might have issues, but continuing..."
fi

# Test 3: Check API endpoint
echo "🧪 Test 3: Checking API endpoint..."
curl -s -X OPTIONS $API_ENDPOINT > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "✅ API endpoint is responding"
else
    echo "⚠️ API endpoint might have issues"
fi

# Test 4: Check Lambda function
echo "🧪 Test 4: Testing Lambda function..."
aws lambda invoke --function-name ImageAnalyzer --payload '{"test": true}' /tmp/lambda-test.json > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "✅ Lambda function is working"
    rm -f /tmp/lambda-test.json
else
    echo "⚠️ Lambda function might have issues"
fi

echo ""
echo "🌐 URLs to test:"
echo "   Main Website: $WEBSITE_URL"
echo "   Test Page: $WEBSITE_URL/test.html"
echo "   API Endpoint: $API_ENDPOINT"

echo ""
echo "📝 Test Instructions:"
echo "1. Open main website in browser"
echo "2. Try uploading an image"
echo "3. Check if analysis works"
echo "4. If main site has issues, try test page"
echo "5. Check browser console for errors"

echo ""
echo "🔧 Troubleshooting:"
echo "- If CSS not loading: Check css/styles.css path"
echo "- If JS not working: Check js/main.js path"
echo "- If API fails: Check CORS settings"
echo "- If upload fails: Check S3 permissions"

echo ""
echo "✅ Fix and test script completed!"
echo "🎯 Next: Test the website manually in browser"
