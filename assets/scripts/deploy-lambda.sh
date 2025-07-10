#!/bin/bash

# Deploy Lambda Function for Image Analysis
echo "🚀 Deploying Lambda function..."

# Variables
FUNCTION_NAME="ImageAnalyzer"
REGION="ap-southeast-1"
ACCOUNT_ID="741448948262"
ROLE_ARN="arn:aws:iam::${ACCOUNT_ID}:role/ImageAnalyzerLambdaRole"

echo "📋 Configuration:"
echo "   Function: $FUNCTION_NAME"
echo "   Region: $REGION"
echo "   Account: $ACCOUNT_ID"
echo "   Role: $ROLE_ARN"
echo ""

echo "📦 Creating deployment package..."

# Create deployment package
rm -rf lambda-package
mkdir -p lambda-package
cp ../src/lambda/image_analyzer.py lambda-package/lambda_function.py

# Create zip file
cd lambda-package
zip -r ../image-analyzer.zip .
cd ..

echo "☁️ Deploying to AWS Lambda..."

# Create Lambda function
aws lambda create-function \
    --function-name $FUNCTION_NAME \
    --runtime python3.9 \
    --role $ROLE_ARN \
    --handler lambda_function.lambda_handler \
    --zip-file fileb://image-analyzer.zip \
    --timeout 30 \
    --memory-size 512 \
    --region $REGION

if [ $? -eq 0 ]; then
    echo "✅ Lambda function created successfully"
else
    echo "⚠️  Lambda function might already exist, updating..."
    aws lambda update-function-code \
        --function-name $FUNCTION_NAME \
        --zip-file fileb://image-analyzer.zip \
        --region $REGION
fi

# Create API Gateway (optional)
echo "🌐 Setting up API Gateway..."

# Create REST API
API_ID=$(aws apigateway create-rest-api \
    --name ImageAnalyzerAPI \
    --description "API for Image Analysis Workshop" \
    --region $REGION \
    --query 'id' --output text)

if [ "$API_ID" != "None" ] && [ ! -z "$API_ID" ]; then
    echo "✅ API Gateway created: $API_ID"
    
    # Get root resource ID
    ROOT_ID=$(aws apigateway get-resources \
        --rest-api-id $API_ID \
        --region $REGION \
        --query 'items[0].id' --output text)

    # Create resource
    RESOURCE_ID=$(aws apigateway create-resource \
        --rest-api-id $API_ID \
        --parent-id $ROOT_ID \
        --path-part analyze \
        --region $REGION \
        --query 'id' --output text)

    # Create POST method
    aws apigateway put-method \
        --rest-api-id $API_ID \
        --resource-id $RESOURCE_ID \
        --http-method POST \
        --authorization-type NONE \
        --region $REGION

    # Set up integration
    aws apigateway put-integration \
        --rest-api-id $API_ID \
        --resource-id $RESOURCE_ID \
        --http-method POST \
        --type AWS_PROXY \
        --integration-http-method POST \
        --uri "arn:aws:apigateway:${REGION}:lambda:path/2015-03-31/functions/arn:aws:lambda:${REGION}:${ACCOUNT_ID}:function:${FUNCTION_NAME}/invocations" \
        --region $REGION

    # Add permission for API Gateway to invoke Lambda
    aws lambda add-permission \
        --function-name $FUNCTION_NAME \
        --statement-id apigateway-invoke \
        --action lambda:InvokeFunction \
        --principal apigateway.amazonaws.com \
        --source-arn "arn:aws:execute-api:${REGION}:${ACCOUNT_ID}:${API_ID}/*/*" \
        --region $REGION

    # Deploy API
    aws apigateway create-deployment \
        --rest-api-id $API_ID \
        --stage-name prod \
        --region $REGION

    API_ENDPOINT="https://${API_ID}.execute-api.${REGION}.amazonaws.com/prod/analyze"
    echo "✅ API deployed successfully"
else
    echo "❌ Failed to create API Gateway"
    API_ENDPOINT="Lambda function created but no API endpoint"
fi

echo ""
echo "✅ Deployment completed!"
echo "🔗 API Endpoint: $API_ENDPOINT"
echo "📝 Lambda Function: $FUNCTION_NAME"
echo "🌍 Region: $REGION"

# Save API endpoint
mkdir -p ../output
echo "$API_ENDPOINT" > ../output/api-endpoint.txt

# Cleanup
rm -rf lambda-package image-analyzer.zip

echo ""
echo "🎯 Next: Test the web interface!"
echo "   The API endpoint has been saved to output/api-endpoint.txt"
