# Module 0: Prerequisites & Setup

## 🎯 Objective
Set up your development environment and AWS account for the workshop.

## ⏱️ Duration: 30 minutes

---

## 📋 Checklist

By the end of this module, you should have:
- [ ] AWS Account with admin access
- [ ] AWS CLI installed and configured
- [ ] IAM user created (if needed)
- [ ] Development environment ready
- [ ] Workshop files downloaded

---

## 🔧 Step 1: AWS Account Setup

### If you don't have an AWS Account:

1. **Go to AWS Console**: https://aws.amazon.com/
2. **Click "Create an AWS Account"**
3. **Follow the registration process**
   - Provide email and password
   - Enter payment information (Free Tier eligible)
   - Verify phone number
   - Choose Basic support plan (free)

### If you have an AWS Account:
- ✅ Ensure you have admin access
- ✅ Verify Free Tier eligibility

---

## 👤 Step 2: IAM User Creation (Recommended)

For security best practices, create an IAM user instead of using root account:

### 2.1 Access IAM Console
1. Sign in to AWS Console
2. Search for "IAM" in services
3. Click on "IAM" service

### 2.2 Create IAM User
```bash
# User Details
Username: workshop-user
Access Type: ✅ Programmatic access
             ✅ AWS Management Console access
Console Password: Auto-generated (or custom)
Require Password Reset: ✅ (recommended)
```

### 2.3 Attach Policies
For this workshop, attach these policies:
- ✅ `AWSLambdaFullAccess`
- ✅ `AmazonS3FullAccess`
- ✅ `AmazonAPIGatewayAdministrator`
- ✅ `IAMFullAccess`

### 2.4 Save Credentials
**⚠️ IMPORTANT**: Download and save:
- Access Key ID
- Secret Access Key
- Console login URL

---

## 💻 Step 3: AWS CLI Installation

### For Windows:
```powershell
# Download AWS CLI MSI installer
# https://awscli.amazonaws.com/AWSCLIV2.msi
# Run the installer

# Verify installation
aws --version
```

### For macOS:
```bash
# Using Homebrew
brew install awscli

# Or download installer
curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
sudo installer -pkg AWSCLIV2.pkg -target /

# Verify installation
aws --version
```

### For Linux:
```bash
# Download and install
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# Verify installation
aws --version
```

---

## ⚙️ Step 4: AWS CLI Configuration

### 4.1 Configure Credentials
```bash
aws configure
```

**Enter the following when prompted:**
```
AWS Access Key ID: [Your Access Key ID]
AWS Secret Access Key: [Your Secret Access Key]
Default region name: ap-southeast-1
Default output format: json
```

### 4.2 Verify Configuration
```bash
# Test AWS CLI
aws sts get-caller-identity

# Expected output:
{
    "UserId": "AIDACKCEVSQ6C2EXAMPLE",
    "Account": "123456789012",
    "Arn": "arn:aws:iam::123456789012:user/workshop-user"
}
```

---

## 📁 Step 5: Workshop Files Setup

### 5.1 Create Workshop Directory
```bash
# Create workshop directory
mkdir ai-image-analyzer-workshop
cd ai-image-analyzer-workshop

# Create subdirectories
mkdir src
mkdir src/lambda
mkdir web
mkdir scripts
mkdir docs
```

### 5.2 Download Workshop Files

**Option A: Download from GitHub**
```bash
# If you have git installed
git clone [workshop-repository-url]
```

**Option B: Manual Download**
- Download workshop files from provided link
- Extract to your workshop directory

---

## 🛠️ Step 6: Development Environment

### 6.1 Text Editor
**Recommended**: Visual Studio Code
- Download: https://code.visualstudio.com/
- Install useful extensions:
  - Python
  - AWS Toolkit
  - HTML/CSS/JavaScript support

### 6.2 Python Environment (Optional)
```bash
# Check Python version (3.8+ recommended)
python --version

# Create virtual environment (optional)
python -m venv workshop-env

# Activate virtual environment
# Windows:
workshop-env\Scripts\activate
# macOS/Linux:
source workshop-env/bin/activate
```

---

## ✅ Step 7: Verification

### 7.1 AWS Access Test
```bash
# List S3 buckets (should work without errors)
aws s3 ls

# List Lambda functions
aws lambda list-functions --region ap-southeast-1
```

### 7.2 Environment Check
- [ ] AWS CLI working
- [ ] Correct region (ap-southeast-1)
- [ ] IAM permissions working
- [ ] Text editor ready
- [ ] Workshop files downloaded

---

## 🚨 Troubleshooting

### Common Issues:

#### 1. AWS CLI Not Found
```bash
# Check PATH
echo $PATH

# Reinstall AWS CLI
# Follow installation steps again
```

#### 2. Permission Denied
```bash
# Check IAM policies
aws iam list-attached-user-policies --user-name workshop-user

# Verify credentials
aws configure list
```

#### 3. Region Issues
```bash
# Set correct region
aws configure set region ap-southeast-1

# Verify region
aws configure get region
```

#### 4. Access Key Issues
```bash
# Reconfigure credentials
aws configure

# Test access
aws sts get-caller-identity
```

---

## 💡 Best Practices

### Security:
- ✅ Use IAM users, not root account
- ✅ Enable MFA (Multi-Factor Authentication)
- ✅ Regularly rotate access keys
- ✅ Use least privilege principle

### Cost Management:
- ✅ Set up billing alerts
- ✅ Use Free Tier resources
- ✅ Clean up resources after workshop
- ✅ Monitor usage regularly

---

## 📊 Workshop Environment Summary

After completing this setup, you should have:

```
✅ AWS Account: Ready
✅ IAM User: Created with proper permissions
✅ AWS CLI: Installed and configured
✅ Region: ap-southeast-1
✅ Development Environment: Ready
✅ Workshop Files: Downloaded
```

---

## 🎯 Next Steps

Once your environment is ready:

1. **Verify everything works** with the tests above
2. **Ask for help** if you encounter issues
3. **Proceed to Module 1** - Architecture Overview

---

## 📞 Getting Help

### During Setup:
- **Instructor**: Available for immediate help
- **Documentation**: AWS CLI troubleshooting guides
- **Community**: Ask fellow participants

### Common Resources:
- [AWS CLI User Guide](https://docs.aws.amazon.com/cli/latest/userguide/)
- [IAM User Guide](https://docs.aws.amazon.com/IAM/latest/UserGuide/)
- [AWS Free Tier](https://aws.amazon.com/free/)

---

**Ready?** Let's move to [Module 1 - Architecture Overview](02-architecture.md)! 🚀
