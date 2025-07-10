#!/bin/bash

# Setup CORS for API Gateway
echo "🌐 Setting up CORS for API Gateway..."

# Variables
API_ID="cuwg234q8g"
REGION="ap-southeast-1"
WEBSITE_URL="http://ai-image-analyzer-web-1751723364.s3-website-ap-southeast-1.amazonaws.com"

echo "📋 Configuration:"
echo "   API ID: $API_ID"
echo "   Region: $REGION"
echo "   Website URL: $WEBSITE_URL"
echo ""

# Get resource ID for /analyze
RESOURCE_ID=$(aws apigateway get-resources \
    --rest-api-id $API_ID \
    --region $REGION \
    --query 'items[?pathPart==`analyze`].id' --output text)

echo "📍 Resource ID: $RESOURCE_ID"

# Add OPTIONS method for CORS preflight
echo "🔧 Adding OPTIONS method for CORS..."
aws apigateway put-method \
    --rest-api-id $API_ID \
    --resource-id $RESOURCE_ID \
    --http-method OPTIONS \
    --authorization-type NONE \
    --region $REGION

# Set up OPTIONS integration
echo "🔗 Setting up OPTIONS integration..."
aws apigateway put-integration \
    --rest-api-id $API_ID \
    --resource-id $RESOURCE_ID \
    --http-method OPTIONS \
    --type MOCK \
    --integration-http-method OPTIONS \
    --request-templates '{"application/json": "{\"statusCode\": 200}"}' \
    --region $REGION

# Set up OPTIONS method response
echo "📤 Setting up OPTIONS method response..."
aws apigateway put-method-response \
    --rest-api-id $API_ID \
    --resource-id $RESOURCE_ID \
    --http-method OPTIONS \
    --status-code 200 \
    --response-parameters '{"method.response.header.Access-Control-Allow-Headers": false, "method.response.header.Access-Control-Allow-Methods": false, "method.response.header.Access-Control-Allow-Origin": false}' \
    --region $REGION

# Set up OPTIONS integration response
echo "📥 Setting up OPTIONS integration response..."
aws apigateway put-integration-response \
    --rest-api-id $API_ID \
    --resource-id $RESOURCE_ID \
    --http-method OPTIONS \
    --status-code 200 \
    --response-parameters '{"method.response.header.Access-Control-Allow-Headers": "'"'"'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"'"'", "method.response.header.Access-Control-Allow-Methods": "'"'"'GET,POST,OPTIONS'"'"'", "method.response.header.Access-Control-Allow-Origin": "'"'"'*'"'"'"}' \
    --region $REGION

# Update POST method response to include CORS headers
echo "🔄 Updating POST method response for CORS..."
aws apigateway put-method-response \
    --rest-api-id $API_ID \
    --resource-id $RESOURCE_ID \
    --http-method POST \
    --status-code 200 \
    --response-parameters '{"method.response.header.Access-Control-Allow-Origin": false}' \
    --region $REGION

# Update POST integration response to include CORS headers
echo "🔄 Updating POST integration response for CORS..."
aws apigateway put-integration-response \
    --rest-api-id $API_ID \
    --resource-id $RESOURCE_ID \
    --http-method POST \
    --status-code 200 \
    --response-parameters '{"method.response.header.Access-Control-Allow-Origin": "'"'"'*'"'"'"}' \
    --region $REGION

# Deploy API changes
echo "🚀 Deploying API changes..."
aws apigateway create-deployment \
    --rest-api-id $API_ID \
    --stage-name prod \
    --description "CORS configuration update" \
    --region $REGION

echo ""
echo "✅ CORS setup completed!"
echo "🌐 Your website can now call the API from:"
echo "   $WEBSITE_URL"
echo ""
echo "🔗 API Endpoint: https://${API_ID}.execute-api.${REGION}.amazonaws.com/prod/analyze"
echo "🎯 Test your live website now!"
