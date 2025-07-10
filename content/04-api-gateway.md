# Module 3: API Gateway Setup

## 🎯 Objective
Create a RESTful API using Amazon API Gateway to expose your Lambda function to the web interface.

## ⏱️ Duration: 30 minutes

---

## 📋 What You'll Build

In this module, you'll create:
- **REST API** with API Gateway
- **POST endpoint** for image analysis
- **CORS configuration** for web access
- **Error handling** and response formatting
- **API deployment** and testing

---

## 🏗️ Lab 3.1: Create REST API (20 min)

### Step 1: Create API Gateway

```bash
# Create REST API
aws apigateway create-rest-api \
  --name "ai-image-analyzer-api" \
  --description "AI Image Analyzer API for color analysis" \
  --region ap-southeast-1
```

### Step 2: Get API Details

```bash
# Get API ID
API_ID=$(aws apigateway get-rest-apis \
  --query 'items[?name==`ai-image-analyzer-api`].id' \
  --output text \
  --region ap-southeast-1)

echo "API ID: $API_ID"

# Get root resource ID
ROOT_RESOURCE_ID=$(aws apigateway get-resources \
  --rest-api-id $API_ID \
  --query 'items[?path==`/`].id' \
  --output text \
  --region ap-southeast-1)

echo "Root Resource ID: $ROOT_RESOURCE_ID"
```

### Step 3: Create /analyze Resource

```bash
# Create /analyze resource
ANALYZE_RESOURCE_ID=$(aws apigateway create-resource \
  --rest-api-id $API_ID \
  --parent-id $ROOT_RESOURCE_ID \
  --path-part "analyze" \
  --region ap-southeast-1 \
  --query 'id' \
  --output text)

echo "Analyze Resource ID: $ANALYZE_RESOURCE_ID"
```

### Step 4: Create POST Method

```bash
# Create POST method
aws apigateway put-method \
  --rest-api-id $API_ID \
  --resource-id $ANALYZE_RESOURCE_ID \
  --http-method POST \
  --authorization-type NONE \
  --region ap-southeast-1

# Create OPTIONS method for CORS
aws apigateway put-method \
  --rest-api-id $API_ID \
  --resource-id $ANALYZE_RESOURCE_ID \
  --http-method OPTIONS \
  --authorization-type NONE \
  --region ap-southeast-1
```

### Step 5: Configure Lambda Integration

```bash
# Get Lambda function ARN
LAMBDA_ARN=$(aws lambda get-function \
  --function-name ai-image-analyzer-colorlab \
  --region ap-southeast-1 \
  --query 'Configuration.FunctionArn' \
  --output text)

echo "Lambda ARN: $LAMBDA_ARN"

# Create Lambda integration for POST
aws apigateway put-integration \
  --rest-api-id $API_ID \
  --resource-id $ANALYZE_RESOURCE_ID \
  --http-method POST \
  --type AWS_PROXY \
  --integration-http-method POST \
  --uri "arn:aws:apigateway:ap-southeast-1:lambda:path/2015-03-31/functions/$LAMBDA_ARN/invocations" \
  --region ap-southeast-1
```

### Step 6: Configure CORS for OPTIONS

```bash
# Configure OPTIONS method response
aws apigateway put-method-response \
  --rest-api-id $API_ID \
  --resource-id $ANALYZE_RESOURCE_ID \
  --http-method OPTIONS \
  --status-code 200 \
  --response-parameters '{
    "method.response.header.Access-Control-Allow-Headers": false,
    "method.response.header.Access-Control-Allow-Methods": false,
    "method.response.header.Access-Control-Allow-Origin": false
  }' \
  --region ap-southeast-1

# Configure OPTIONS integration
aws apigateway put-integration \
  --rest-api-id $API_ID \
  --resource-id $ANALYZE_RESOURCE_ID \
  --http-method OPTIONS \
  --type MOCK \
  --request-templates '{"application/json": "{\"statusCode\": 200}"}' \
  --region ap-southeast-1

# Configure OPTIONS integration response
aws apigateway put-integration-response \
  --rest-api-id $API_ID \
  --resource-id $ANALYZE_RESOURCE_ID \
  --http-method OPTIONS \
  --status-code 200 \
  --response-parameters '{
    "method.response.header.Access-Control-Allow-Headers": "\"Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token\"",
    "method.response.header.Access-Control-Allow-Methods": "\"POST,OPTIONS\"",
    "method.response.header.Access-Control-Allow-Origin": "\"*\""
  }' \
  --region ap-southeast-1
```

### Step 7: Grant API Gateway Permission to Lambda

```bash
# Get AWS account ID
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

# Add permission for API Gateway to invoke Lambda
aws lambda add-permission \
  --function-name ai-image-analyzer-colorlab \
  --statement-id api-gateway-invoke \
  --action lambda:InvokeFunction \
  --principal apigateway.amazonaws.com \
  --source-arn "arn:aws:execute-api:ap-southeast-1:$ACCOUNT_ID:$API_ID/*/*" \
  --region ap-southeast-1
```

---

## 🏗️ Lab 3.2: Deploy and Test API (10 min)

### Step 1: Deploy API

```bash
# Create deployment
aws apigateway create-deployment \
  --rest-api-id $API_ID \
  --stage-name prod \
  --stage-description "Production stage" \
  --description "Initial deployment" \
  --region ap-southeast-1

# Get API endpoint URL
API_URL="https://$API_ID.execute-api.ap-southeast-1.amazonaws.com/prod"
echo "API Endpoint: $API_URL"
```

### Step 2: Test API with curl

```bash
# Test OPTIONS request (CORS preflight)
curl -X OPTIONS \
  -H "Origin: http://localhost:3000" \
  -H "Access-Control-Request-Method: POST" \
  -H "Access-Control-Request-Headers: Content-Type" \
  -v \
  "$API_URL/analyze"

# Test POST request with sample data
curl -X POST \
  -H "Content-Type: application/json" \
  -d '{
    "body": "data:image/jpeg;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8/5+hHgAHggJ/PchI7wAAAABJRU5ErkJggg=="
  }' \
  "$API_URL/analyze"
```

### Step 3: Test with Real Image

```bash
# Create test script
cat > test-api.sh << 'EOF'
#!/bin/bash

API_URL="https://YOUR-API-ID.execute-api.ap-southeast-1.amazonaws.com/prod"

# Convert test image to base64
if [ -f "test-image.jpg" ]; then
    BASE64_IMAGE=$(base64 -w 0 test-image.jpg)
    
    # Test API call
    curl -X POST \
      -H "Content-Type: application/json" \
      -d "{\"body\": \"data:image/jpeg;base64,$BASE64_IMAGE\"}" \
      "$API_URL/analyze" | jq '.'
else
    echo "Please add a test-image.jpg file to test with a real image"
fi
EOF

chmod +x test-api.sh
```

---

## 📊 API Response Format

### Successful Response:
```json
{
  "statusCode": 200,
  "headers": {
    "Content-Type": "application/json",
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Headers": "Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token",
    "Access-Control-Allow-Methods": "POST,OPTIONS"
  },
  "body": {
    "colorFrequency": [
      {
        "color": "#FF5733",
        "name": "Vermillion",
        "percentage": 25.4,
        "rgb": [255, 87, 51],
        "lab": [62.3, 51.2, 45.8]
      },
      {
        "color": "#33FF57",
        "name": "Spring Green", 
        "percentage": 18.7,
        "rgb": [51, 255, 87],
        "lab": [84.2, -68.3, 49.1]
      }
    ],
    "regionalAnalysis": {
      "grid": [
        [
          {"position": "1,1", "color": "#FF5733", "name": "Vermillion"},
          {"position": "1,2", "color": "#33FF57", "name": "Spring Green"},
          {"position": "1,3", "color": "#3357FF", "name": "Royal Blue"}
        ],
        [
          {"position": "2,1", "color": "#FF33F5", "name": "Magenta"},
          {"position": "2,2", "color": "#F5FF33", "name": "Yellow"},
          {"position": "2,3", "color": "#33FFF5", "name": "Cyan"}
        ],
        [
          {"position": "3,1", "color": "#FF8C33", "name": "Orange"},
          {"position": "3,2", "color": "#8CFF33", "name": "Lime"},
          {"position": "3,3", "color": "#338CFF", "name": "Sky Blue"}
        ]
      ]
    },
    "metadata": {
      "processingTime": 1.23,
      "imageSize": [800, 600],
      "algorithm": "kmeans_plus_plus_lab",
      "totalColors": 5,
      "accuracy": "70_percent_improvement"
    }
  }
}
```

### Error Response:
```json
{
  "statusCode": 400,
  "headers": {
    "Content-Type": "application/json",
    "Access-Control-Allow-Origin": "*"
  },
  "body": {
    "error": "Invalid image data",
    "message": "Unable to decode base64 image data",
    "timestamp": "2025-07-10T08:00:00Z"
  }
}
```

---

## 🔧 Advanced API Configuration

### Enable API Gateway Logging

```bash
# Create CloudWatch role for API Gateway
aws iam create-role \
  --role-name APIGatewayCloudWatchRole \
  --assume-role-policy-document '{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "apigateway.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  }'

# Attach logging policy
aws iam attach-role-policy \
  --role-name APIGatewayCloudWatchRole \
  --policy-arn arn:aws:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs

# Configure API Gateway account settings
ROLE_ARN=$(aws iam get-role --role-name APIGatewayCloudWatchRole --query 'Role.Arn' --output text)

aws apigateway put-account \
  --cloudwatch-role-arn $ROLE_ARN \
  --region ap-southeast-1
```

### Enable Request/Response Logging

```bash
# Update stage to enable logging
aws apigateway update-stage \
  --rest-api-id $API_ID \
  --stage-name prod \
  --patch-ops '[
    {
      "op": "replace",
      "path": "/accessLogSettings/destinationArn",
      "value": "arn:aws:logs:ap-southeast-1:'$ACCOUNT_ID':log-group:API-Gateway-Execution-Logs_'$API_ID'/prod"
    },
    {
      "op": "replace", 
      "path": "/accessLogSettings/format",
      "value": "$requestId $requestTime $httpMethod $resourcePath $status $responseLength $requestTime"
    },
    {
      "op": "replace",
      "path": "/*/*/logging/loglevel",
      "value": "INFO"
    },
    {
      "op": "replace",
      "path": "/*/*/logging/dataTrace",
      "value": "true"
    }
  ]' \
  --region ap-southeast-1
```

### Add Request Validation

```bash
# Create request validator
VALIDATOR_ID=$(aws apigateway create-request-validator \
  --rest-api-id $API_ID \
  --name "image-analyzer-validator" \
  --validate-request-body true \
  --validate-request-parameters true \
  --region ap-southeast-1 \
  --query 'id' \
  --output text)

# Create request model
aws apigateway create-model \
  --rest-api-id $API_ID \
  --name "ImageAnalysisRequest" \
  --content-type "application/json" \
  --schema '{
    "$schema": "http://json-schema.org/draft-04/schema#",
    "title": "Image Analysis Request",
    "type": "object",
    "properties": {
      "body": {
        "type": "string",
        "pattern": "^data:image\/(jpeg|jpg|png|gif);base64,[A-Za-z0-9+/=]+$"
      }
    },
    "required": ["body"]
  }' \
  --region ap-southeast-1

# Update method to use validator
aws apigateway update-method \
  --rest-api-id $API_ID \
  --resource-id $ANALYZE_RESOURCE_ID \
  --http-method POST \
  --patch-ops '[
    {
      "op": "replace",
      "path": "/requestValidatorId",
      "value": "'$VALIDATOR_ID'"
    },
    {
      "op": "replace",
      "path": "/requestModels/application~1json",
      "value": "ImageAnalysisRequest"
    }
  ]' \
  --region ap-southeast-1
```

---

## 🚨 Troubleshooting

### Common Issues:

#### 1. **CORS Errors**
```
Access to fetch at 'API_URL' from origin 'http://localhost:3000' has been blocked by CORS policy
```

**Solution**: Verify CORS configuration
```bash
# Check CORS headers
curl -X OPTIONS \
  -H "Origin: http://localhost:3000" \
  -v \
  "$API_URL/analyze"
```

#### 2. **Lambda Permission Errors**
```
{"message": "Internal server error"}
```

**Solution**: Check Lambda permissions
```bash
# Verify Lambda permission
aws lambda get-policy \
  --function-name ai-image-analyzer-colorlab \
  --region ap-southeast-1
```

#### 3. **API Gateway 502 Errors**
```
{"message": "Internal server error"}
```

**Solution**: Check Lambda function logs
```bash
# Get recent Lambda logs
aws logs filter-log-events \
  --log-group-name /aws/lambda/ai-image-analyzer-colorlab \
  --start-time $(date -d '10 minutes ago' +%s)000 \
  --region ap-southeast-1
```

### Debug Commands:

```bash
# Test Lambda function directly
aws lambda invoke \
  --function-name ai-image-analyzer-colorlab \
  --payload '{"body": "test"}' \
  --region ap-southeast-1 \
  debug-response.json

# Check API Gateway configuration
aws apigateway get-method \
  --rest-api-id $API_ID \
  --resource-id $ANALYZE_RESOURCE_ID \
  --http-method POST \
  --region ap-southeast-1

# View API Gateway logs
aws logs describe-log-groups \
  --log-group-name-prefix API-Gateway-Execution-Logs \
  --region ap-southeast-1
```

---

## 📈 Performance Optimization

### Enable Caching

```bash
# Enable caching on stage
aws apigateway update-stage \
  --rest-api-id $API_ID \
  --stage-name prod \
  --patch-ops '[
    {
      "op": "replace",
      "path": "/cacheClusterEnabled",
      "value": "true"
    },
    {
      "op": "replace",
      "path": "/cacheClusterSize",
      "value": "0.5"
    }
  ]' \
  --region ap-southeast-1
```

### Configure Throttling

```bash
# Set throttling limits
aws apigateway update-stage \
  --rest-api-id $API_ID \
  --stage-name prod \
  --patch-ops '[
    {
      "op": "replace",
      "path": "/throttle/rateLimit",
      "value": "100"
    },
    {
      "op": "replace",
      "path": "/throttle/burstLimit", 
      "value": "200"
    }
  ]' \
  --region ap-southeast-1
```

---

## ✅ Module 3 Checklist

By the end of this module, you should have:

- [ ] **REST API Created**: ai-image-analyzer-api
- [ ] **POST Endpoint**: /analyze endpoint configured
- [ ] **CORS Enabled**: Proper CORS headers for web access
- [ ] **Lambda Integration**: API Gateway connected to Lambda function
- [ ] **API Deployed**: Production stage deployed and accessible
- [ ] **Testing Completed**: API tested with curl and sample data
- [ ] **Error Handling**: Proper error responses configured

---

## 🎯 Next Steps

Your API is now ready! In the next module, we'll:
- Build the web interface
- Integrate with your API
- Create professional UI components
- Add real-time image analysis

**Ready?** Let's move to [Module 4 - Frontend Development](05-frontend-development.md)! 🚀

---

## 📚 Additional Resources

- [API Gateway Developer Guide](https://docs.aws.amazon.com/apigateway/latest/developerguide/)
- [CORS Configuration](https://docs.aws.amazon.com/apigateway/latest/developerguide/how-to-cors.html)
- [API Gateway Best Practices](https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-basic-concept.html)
- [Lambda Proxy Integration](https://docs.aws.amazon.com/apigateway/latest/developerguide/set-up-lambda-proxy-integrations.html)
