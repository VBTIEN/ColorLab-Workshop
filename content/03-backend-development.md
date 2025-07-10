# Module 2: Backend Development

## 🎯 Objective
Build the AWS Lambda function that will perform intelligent image analysis using advanced color extraction algorithms.

## ⏱️ Duration: 60 minutes

---

## 📋 What You'll Build

In this module, you'll create:
- **AWS Lambda Function** for serverless image processing
- **Lambda Layer** with PIL/NumPy dependencies
- **Advanced Color Analysis** using K-Means++ algorithms
- **Regional Analysis** with 3x3 grid processing
- **Professional Color Naming** system

---

## 🏗️ Lab 2.1: Create Lambda Function (30 min)

### Step 1: Prepare Lambda Function Code

First, let's examine the production-ready Lambda function code:

```bash
# View the Lambda function code
cat assets/code/lambda_function_colorlab_complete.py
```

This function includes:
- **K-Means++ Clustering**: Advanced color extraction
- **LAB Color Space**: Perceptually uniform color analysis
- **Regional Analysis**: 3x3 grid color distribution
- **Professional Color Names**: Accurate color naming
- **Error Handling**: Robust error management

### Step 2: Create IAM Role for Lambda

```bash
# Create IAM role for Lambda execution
aws iam create-role \
  --role-name lambda-execution-role \
  --assume-role-policy-document '{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "lambda.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  }'

# Attach basic execution policy
aws iam attach-role-policy \
  --role-name lambda-execution-role \
  --policy-arn arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole
```

### Step 3: Package Lambda Function

```bash
# Create deployment package
mkdir lambda-package
cp assets/code/lambda_function_colorlab_complete.py lambda-package/lambda_function.py

# Create requirements.txt
cat > lambda-package/requirements.txt << EOF
Pillow==10.0.0
numpy==1.24.3
EOF

# Package the function
cd lambda-package
zip -r ../function.zip .
cd ..
```

### Step 4: Create Lambda Function

```bash
# Get your AWS account ID
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

# Create Lambda function
aws lambda create-function \
  --function-name ai-image-analyzer-colorlab \
  --runtime python3.11 \
  --role arn:aws:iam::${ACCOUNT_ID}:role/lambda-execution-role \
  --handler lambda_function.lambda_handler \
  --zip-file fileb://function.zip \
  --description "ColorLab Enhanced - Advanced Color Analysis with K-Means++" \
  --timeout 120 \
  --memory-size 2048 \
  --region ap-southeast-1
```

### Step 5: Test Lambda Function

```bash
# Create test payload
cat > test-payload.json << EOF
{
  "body": "data:image/jpeg;base64,/9j/4AAQSkZJRgABAQEAYABgAAD..."
}
EOF

# Test the function
aws lambda invoke \
  --function-name ai-image-analyzer-colorlab \
  --payload file://test-payload.json \
  --region ap-southeast-1 \
  response.json

# View response
cat response.json
```

---

## 🏗️ Lab 2.2: Create Lambda Layer (30 min)

### Why Lambda Layers?

Lambda Layers allow you to:
- **Share Dependencies**: Reuse libraries across functions
- **Reduce Package Size**: Keep function code small
- **Faster Deployments**: Update code without dependencies
- **Better Organization**: Separate code from libraries

### Step 1: Create Layer Directory Structure

```bash
# Create layer structure
mkdir -p lambda-layer/python

# Install dependencies in layer
pip install Pillow==10.0.0 numpy==1.24.3 -t lambda-layer/python/
```

### Step 2: Package Lambda Layer

```bash
# Create layer package
cd lambda-layer
zip -r ../image-analysis-layer.zip .
cd ..
```

### Step 3: Create Lambda Layer

```bash
# Create the layer
aws lambda publish-layer-version \
  --layer-name image-analysis-layer \
  --description "PIL/Pillow and NumPy for image processing" \
  --zip-file fileb://image-analysis-layer.zip \
  --compatible-runtimes python3.11 \
  --region ap-southeast-1
```

### Step 4: Attach Layer to Function

```bash
# Get layer ARN
LAYER_ARN=$(aws lambda list-layer-versions \
  --layer-name image-analysis-layer \
  --region ap-southeast-1 \
  --query 'LayerVersions[0].LayerVersionArn' \
  --output text)

# Update function to use layer
aws lambda update-function-configuration \
  --function-name ai-image-analyzer-colorlab \
  --layers $LAYER_ARN \
  --region ap-southeast-1
```

---

## 🔬 Understanding the Algorithm

### K-Means++ Color Analysis

Our Lambda function uses advanced algorithms:

#### 1. **K-Means++ Initialization**
```python
# Better initial cluster selection
def kmeans_plus_plus_init(data, k):
    centers = []
    centers.append(data[np.random.randint(data.shape[0])])
    
    for _ in range(1, k):
        distances = np.array([min([np.linalg.norm(x - c)**2 for c in centers]) for x in data])
        probabilities = distances / distances.sum()
        cumulative_probabilities = probabilities.cumsum()
        r = np.random.rand()
        
        for j, p in enumerate(cumulative_probabilities):
            if r < p:
                centers.append(data[j])
                break
    
    return np.array(centers)
```

#### 2. **LAB Color Space Conversion**
```python
# Convert RGB to LAB for perceptual accuracy
def rgb_to_lab(rgb):
    # Convert RGB to XYZ
    rgb = rgb / 255.0
    rgb = np.where(rgb > 0.04045, np.power((rgb + 0.055) / 1.055, 2.4), rgb / 12.92)
    
    # XYZ conversion matrix
    xyz = np.dot(rgb, [[0.4124564, 0.3575761, 0.1804375],
                       [0.2126729, 0.7151522, 0.0721750],
                       [0.0193339, 0.1191920, 0.9503041]])
    
    # Convert XYZ to LAB
    xyz = xyz / [0.95047, 1.00000, 1.08883]  # D65 illuminant
    xyz = np.where(xyz > 0.008856, np.power(xyz, 1/3), (7.787 * xyz) + (16/116))
    
    lab = [116 * xyz[1] - 16,  # L
           500 * (xyz[0] - xyz[1]),  # A
           200 * (xyz[1] - xyz[2])]  # B
    
    return lab
```

#### 3. **Regional Analysis**
```python
# Divide image into 3x3 grid
def analyze_regions(image):
    height, width = image.shape[:2]
    regions = []
    
    for i in range(3):
        for j in range(3):
            # Calculate region boundaries
            start_y = i * height // 3
            end_y = (i + 1) * height // 3
            start_x = j * width // 3
            end_x = (j + 1) * width // 3
            
            # Extract region
            region = image[start_y:end_y, start_x:end_x]
            
            # Analyze region colors
            region_colors = extract_colors(region)
            regions.append({
                'position': f'{i+1},{j+1}',
                'colors': region_colors
            })
    
    return regions
```

---

## 🧪 Testing Your Lambda Function

### Test 1: Basic Color Analysis

```bash
# Test with a simple image
aws lambda invoke \
  --function-name ai-image-analyzer-colorlab \
  --payload '{
    "body": "data:image/jpeg;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8/5+hHgAHggJ/PchI7wAAAABJRU5ErkJggg=="
  }' \
  --region ap-southeast-1 \
  test-response.json

# View results
cat test-response.json | jq '.'
```

### Test 2: Performance Testing

```bash
# Test processing time
time aws lambda invoke \
  --function-name ai-image-analyzer-colorlab \
  --payload file://test-payload.json \
  --region ap-southeast-1 \
  performance-test.json
```

### Test 3: Error Handling

```bash
# Test with invalid data
aws lambda invoke \
  --function-name ai-image-analyzer-colorlab \
  --payload '{"body": "invalid-data"}' \
  --region ap-southeast-1 \
  error-test.json

# Should return proper error response
cat error-test.json
```

---

## 📊 Expected Results

### Successful Response Format:
```json
{
  "statusCode": 200,
  "headers": {
    "Content-Type": "application/json",
    "Access-Control-Allow-Origin": "*"
  },
  "body": {
    "colorFrequency": [
      {
        "color": "#FF5733",
        "name": "Vermillion",
        "percentage": 25.4,
        "rgb": [255, 87, 51],
        "lab": [62.3, 51.2, 45.8]
      }
    ],
    "regionalAnalysis": {
      "grid": [
        [
          {"position": "1,1", "color": "#FF5733", "name": "Vermillion"},
          {"position": "1,2", "color": "#33FF57", "name": "Spring Green"}
        ]
      ]
    },
    "metadata": {
      "processingTime": 1.23,
      "imageSize": [800, 600],
      "algorithm": "kmeans_plus_plus_lab",
      "accuracy": "70_percent_improvement"
    }
  }
}
```

---

## 🔧 Optimization Tips

### Performance Optimization:

1. **Memory Configuration**
```bash
# Optimize memory for your workload
aws lambda update-function-configuration \
  --function-name ai-image-analyzer-colorlab \
  --memory-size 1024  # Start with 1024MB, adjust based on testing
```

2. **Timeout Configuration**
```bash
# Set appropriate timeout
aws lambda update-function-configuration \
  --function-name ai-image-analyzer-colorlab \
  --timeout 60  # 60 seconds should be sufficient
```

3. **Environment Variables**
```bash
# Add configuration via environment variables
aws lambda update-function-configuration \
  --function-name ai-image-analyzer-colorlab \
  --environment Variables='{
    "ALGORITHM":"kmeans_plus_plus",
    "COLOR_SPACE":"lab",
    "MAX_COLORS":"10",
    "ACCURACY_MODE":"high"
  }'
```

---

## 🚨 Troubleshooting

### Common Issues:

#### 1. **Import Errors**
```
Error: Unable to import module 'lambda_function': No module named 'PIL'
```
**Solution**: Ensure Lambda Layer is properly attached

#### 2. **Memory Errors**
```
Error: Task timed out after 30.00 seconds
```
**Solution**: Increase memory and timeout settings

#### 3. **Permission Errors**
```
Error: User is not authorized to perform: lambda:InvokeFunction
```
**Solution**: Check IAM role permissions

### Debug Commands:
```bash
# Check function configuration
aws lambda get-function-configuration \
  --function-name ai-image-analyzer-colorlab

# View logs
aws logs describe-log-groups \
  --log-group-name-prefix /aws/lambda/ai-image-analyzer-colorlab

# Get recent logs
aws logs filter-log-events \
  --log-group-name /aws/lambda/ai-image-analyzer-colorlab \
  --start-time $(date -d '1 hour ago' +%s)000
```

---

## ✅ Module 2 Checklist

By the end of this module, you should have:

- [ ] **Lambda Function Created**: ai-image-analyzer-colorlab
- [ ] **Lambda Layer Attached**: image-analysis-layer with PIL/NumPy
- [ ] **IAM Role Configured**: lambda-execution-role with proper permissions
- [ ] **Function Tested**: Successfully processes images and returns color analysis
- [ ] **Performance Optimized**: Memory and timeout configured appropriately
- [ ] **Error Handling Verified**: Function handles invalid inputs gracefully

---

## 🎯 Next Steps

Your Lambda function is now ready! In the next module, we'll:
- Create API Gateway to expose your function
- Configure CORS for web access
- Set up proper error handling
- Test the complete API

**Ready?** Let's move to [Module 3 - API Gateway Setup](04-api-gateway.md)! 🚀

---

## 📚 Additional Resources

- [AWS Lambda Best Practices](https://docs.aws.amazon.com/lambda/latest/dg/best-practices.html)
- [Lambda Layers Documentation](https://docs.aws.amazon.com/lambda/latest/dg/configuration-layers.html)
- [PIL/Pillow Documentation](https://pillow.readthedocs.io/en/stable/)
- [K-Means Clustering Theory](https://en.wikipedia.org/wiki/K-means_clustering)
- [LAB Color Space](https://en.wikipedia.org/wiki/CIELAB_color_space)
