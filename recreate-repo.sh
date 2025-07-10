#!/bin/bash

echo "🔄 Recreating repository as standalone (not fork)"

# Backup current content
echo "📦 Creating backup..."
tar -czf workshop-backup.tar.gz .

# Delete the forked repository
echo "🗑️ Deleting forked repository..."
gh repo delete VBTIEN/ai-image-analyzer-workshop --confirm

# Create new standalone repository
echo "🆕 Creating new standalone repository..."
gh repo create VBTIEN/ai-image-analyzer-workshop \
  --description "🎨 AI Image Analyzer Workshop - Hands-on AWS Lambda & Color Analysis" \
  --public

# Clone the new empty repository
echo "📥 Cloning new repository..."
cd ..
rm -rf ai-image-analyzer-workshop
gh repo clone VBTIEN/ai-image-analyzer-workshop
cd ai-image-analyzer-workshop

# Extract backup content
echo "📤 Restoring content..."
tar -xzf ../workshop-backup.tar.gz --exclude='.git'

# Add topics and settings
echo "🏷️ Adding topics..."
gh repo edit --add-topic "aws,workshop,lambda,image-analysis,serverless,ai,machine-learning,python,color-analysis,tutorial"

# Initial commit
echo "💾 Creating initial commit..."
git add .
git commit -m "🎨 Initial AI Image Analyzer Workshop

✨ Complete workshop with 7 hands-on modules:
- Module 0: Prerequisites & Setup (30 min)
- Module 1: Architecture Overview (20 min)  
- Module 2: Backend Development (60 min)
- Module 3: API Gateway Setup (30 min)
- Module 4: Frontend Development (45 min)
- Module 5: S3 Integration (20 min)
- Module 6: Advanced Features (30 min)
- Module 7: Testing & Wrap-up (15 min)

🏗️ Production-ready architecture:
- AWS Lambda with K-Means++ color analysis
- Advanced image processing with PIL/NumPy
- Professional web interface with ultimate fixes
- Complete deployment automation

🎯 Ready for hands-on learning experience!
Total Duration: 3.5 hours | Level: Intermediate"

# Push to new repository
echo "🚀 Pushing to new repository..."
git push origin master

echo "✅ Repository recreated successfully as standalone!"
echo "🌐 New repository: https://github.com/VBTIEN/ai-image-analyzer-workshop"
echo "📝 No longer shows as fork of template repository"

# Cleanup
rm ../workshop-backup.tar.gz

