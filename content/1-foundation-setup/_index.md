---
title: "Foundation Setup"
date: 2025-07-10T18:00:00+07:00
weight: 10
chapter: true
pre: "<b>I. </b>"
---

# Phase I: Foundation Setup
## AWS Account, Security, and Development Environment

{{% notice info %}}
**Duration**: 60 minutes | **Focus**: AWS Account Setup, Security Configuration, Development Tools
{{% /notice %}}

### 🎯 Phase Overview

In this foundational phase, you'll establish the essential infrastructure needed for deploying ColorLab on AWS. This includes creating and securing your AWS account, setting up proper access management, and preparing your development environment with all necessary tools.

### 📋 What You'll Accomplish

By the end of this phase, you will have:

- ✅ **Secure AWS Account**: Created with MFA and proper billing alerts
- ✅ **IAM Security**: Admin user, groups, and least-privilege policies configured
- ✅ **Development Environment**: All required tools installed and configured
- ✅ **AWS CLI**: Properly configured with credentials and tested access
- ✅ **Project Structure**: Organized directory structure for workshop materials

### 🏗️ Phase Components

This phase consists of 4 essential modules:

| Module | Topic | Time | Description |
|--------|-------|------|-------------|
| **1.1** | [AWS Account Creation](1-1-aws-account/) | 20 min | Create AWS account with proper configuration |
| **1.2** | [Security & Access Management](1-2-security-access/) | 25 min | MFA setup, IAM users, groups, and policies |
| **1.3** | [Development Environment](1-3-dev-environment/) | 15 min | Install tools, setup project structure |
| **1.4** | [AWS CLI Configuration](1-4-aws-cli/) | 10 min | Configure CLI, test access, verify setup |

### 🔒 Security First Approach

This phase emphasizes security best practices from the beginning:

- **Root Account Protection**: MFA enabled, limited usage
- **Least Privilege Access**: Proper IAM roles and policies
- **Credential Management**: Secure storage and rotation practices
- **Monitoring Setup**: Billing alerts and access logging

### 💰 Cost Considerations

All activities in this phase are **completely free**:
- AWS account creation: Free
- IAM configuration: Free
- Tool installation: Free (open source tools)
- CLI setup: Free

### 🛠️ Tools You'll Install

- **AWS CLI**: Command-line interface for AWS services
- **Python 3.11**: Runtime for Lambda functions
- **Git**: Version control for your code
- **Text Editor**: VS Code or similar for development

### ⚠️ Important Prerequisites

Before starting this phase, ensure you have:
- Valid email address for AWS account
- Credit card for account verification (won't be charged)
- Computer with internet connection
- Administrative access to install software

### 🎯 Success Criteria

You'll know this phase is complete when:
- [ ] AWS account created and verified
- [ ] MFA enabled on root account
- [ ] Admin IAM user created and configured
- [ ] All development tools installed
- [ ] AWS CLI configured and tested
- [ ] Can successfully run: `aws sts get-caller-identity`

---

{{% notice tip %}}
**Ready to start?** Begin with [Module 1.1 - AWS Account Creation](1-1-aws-account/) to create your AWS account with proper security configuration.
{{% /notice %}}

### 🔄 Phase Navigation

**Next Phase**: [Phase II - Core Services Deployment](../2-core-services/) (Lambda Functions & Algorithms)

---

**Foundation is everything - let's build it right from the start!** 🏗️
