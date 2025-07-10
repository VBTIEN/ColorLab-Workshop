# 🎨 ColorLab-Workshop Hugo Setup Guide

## 🚀 **Cách chạy ColorLab-Workshop trên web Hugo**

### **📍 Vị trí project:**
```
/mnt/d/project/ai-image-analyzer-workshop/ColorLab-Workshop/
```

---

## 🔧 **Cách 1: Chạy nhanh (30 giây)**

### **⚡ Quick Start**
```bash
cd /mnt/d/project/ai-image-analyzer-workshop/ColorLab-Workshop
./run-hugo-server.sh
```

### **🌐 Truy cập website:**
- **Local**: http://localhost:1313
- **Network**: http://[your-ip]:1313

---

## 🛠️ **Cách 2: Chạy thủ công (Hugo commands)**

### **📋 Bước 1: Di chuyển đến thư mục**
```bash
cd /mnt/d/project/ai-image-analyzer-workshop/ColorLab-Workshop
```

### **📋 Bước 2: Kiểm tra Hugo**
```bash
# Kiểm tra Hugo đã cài đặt
hugo version

# Nếu chưa có Hugo, cài đặt:
sudo apt update && sudo apt install hugo
```

### **📋 Bước 3: Chạy Hugo server**
```bash
# Chạy development server
hugo server -D --bind 0.0.0.0 --port 1313

# Hoặc với live reload
hugo server -D --bind 0.0.0.0 --port 1313 --liveReload
```

### **📋 Bước 4: Mở trình duyệt**
```
http://localhost:1313
```

---

## 🎯 **Cách 3: Build static website (Production)**

### **🏗️ Build website tĩnh**
```bash
cd /mnt/d/project/ai-image-analyzer-workshop/ColorLab-Workshop

# Build static files
hugo --minify

# Files sẽ được tạo trong thư mục public/
ls -la public/
```

### **🌐 Deploy static files**
```bash
# Copy files to web server
cp -r public/* /var/www/html/

# Hoặc serve với Python
cd public
python3 -m http.server 8080
# Truy cập: http://localhost:8080
```

---

## 📊 **Cấu trúc project Hugo**

### **📁 Thư mục chính**
```
ColorLab-Workshop/
├── config.toml              # Hugo configuration
├── content/                 # Workshop content (Markdown files)
│   ├── _index.md           # Homepage
│   ├── 01-prerequisites.md # Module 1
│   ├── 02-architecture.md  # Module 2
│   └── ...                 # Other modules
├── themes/                 # Hugo themes
│   └── hugo-theme-learn/   # Learn theme
├── static/                 # Static assets (CSS, JS, images)
├── layouts/                # Custom layouts
├── public/                 # Generated static site (after build)
└── run-hugo-server.sh      # Quick start script
```

### **⚙️ Hugo Configuration (config.toml)**
```toml
baseURL = "/"
title = "ColorLab Workshop - Professional Color Analysis Platform"
theme = "hugo-theme-learn"

[params]
  themeVariant = "workshop"
  description = "Professional Color Analysis Workshop using Advanced Mathematical Algorithms and AWS Serverless Architecture"
  author = "AWS Solutions Architect"
```

---

## 🎨 **Tính năng website Hugo**

### **📚 Workshop Documentation**
- **7 Module hoàn chỉnh**: Prerequisites → Testing (3.5 hours)
- **Interactive Navigation**: Sidebar với progress tracking
- **Search Functionality**: Tìm kiếm nội dung workshop
- **Mobile Responsive**: Tối ưu cho mobile và tablet
- **Syntax Highlighting**: Code examples với highlighting

### **🎯 Educational Features**
- **Step-by-step Guides**: Hướng dẫn chi tiết từng bước
- **Code Examples**: Syntax-highlighted code blocks
- **Architecture Diagrams**: Visual system design
- **Live Demo Links**: Links đến production system
- **Download Resources**: Scripts và templates

### **🌐 Professional Presentation**
- **Clean Design**: Professional workshop appearance
- **Easy Navigation**: Intuitive menu structure
- **Progress Tracking**: Visual progress through modules
- **Print Friendly**: Optimized for printing
- **Fast Loading**: Optimized static site generation

---

## 🔧 **Troubleshooting**

### **❌ Common Issues & Solutions**

#### **Hugo not found**
```bash
# Install Hugo
sudo apt update
sudo apt install hugo

# Verify installation
hugo version
```

#### **Port already in use**
```bash
# Use different port
hugo server -D --port 1314

# Or kill existing process
sudo lsof -ti:1313 | xargs kill -9
```

#### **Theme not loading**
```bash
# Check theme directory
ls -la themes/hugo-theme-learn/

# If missing, the site will use default styling
# Content will still be accessible
```

#### **Permission denied**
```bash
# Fix permissions
sudo chown -R $USER:$USER /mnt/d/project/ai-image-analyzer-workshop/ColorLab-Workshop
chmod +x run-hugo-server.sh
```

#### **Content not updating**
```bash
# Clear Hugo cache
hugo --cleanDestinationDir

# Or restart server
# Press Ctrl+C and run again
./run-hugo-server.sh
```

---

## 🌐 **Deployment Options**

### **🏠 Local Development**
```bash
# Development server with live reload
hugo server -D --bind 0.0.0.0 --port 1313
```
- **URL**: http://localhost:1313
- **Features**: Live reload, draft content, fast rendering

### **🌍 Network Access**
```bash
# Allow network access
hugo server -D --bind 0.0.0.0 --port 1313
```
- **URL**: http://[your-ip]:1313
- **Use case**: Demo to others on same network

### **📄 Static Website**
```bash
# Build static site
hugo --minify
```
- **Output**: `public/` directory
- **Use case**: Deploy to any web server

### **☁️ Cloud Deployment**
```bash
# Build and deploy to S3
hugo --minify
aws s3 sync public/ s3://your-bucket-name/
```
- **Use case**: Production deployment on AWS

---

## 📱 **Mobile & Responsive**

### **📲 Mobile Testing**
- **Responsive Design**: Automatically adapts to screen size
- **Touch Navigation**: Mobile-friendly menu and navigation
- **Fast Loading**: Optimized for mobile networks
- **Readable Text**: Proper font sizes and spacing

### **🖥️ Desktop Features**
- **Full Navigation**: Complete sidebar menu
- **Search**: Full-text search functionality
- **Print Support**: Optimized for printing
- **Keyboard Navigation**: Full keyboard support

---

## 🎓 **Workshop Content Structure**

### **📚 Module Organization**
```
Module 0: Prerequisites & Setup (30 min)
├── AWS Account setup
├── Development environment
└── Required tools

Module 1: Architecture Overview (20 min)
├── System design
├── AWS services
└── Component interaction

Module 2: Backend Development (60 min)
├── Lambda function development
├── K-Means++ algorithms
├── LAB color space processing
└── Professional color database

[... và các modules khác]
```

### **🔗 Navigation Features**
- **Previous/Next**: Navigate between modules
- **Breadcrumbs**: Show current location
- **Progress Indicator**: Visual progress tracking
- **Quick Links**: Jump to any section
- **Search**: Find specific content

---

## 📊 **Performance & Analytics**

### **⚡ Performance Metrics**
- **Build Time**: ~2-5 seconds for full site
- **Page Load**: <1 second for static pages
- **File Size**: Optimized with minification
- **SEO**: Optimized meta tags and structure

### **📈 Usage Analytics**
- **Page Views**: Track module completion
- **Time on Page**: Measure engagement
- **Search Queries**: Popular search terms
- **Mobile Usage**: Mobile vs desktop access

---

## 🎯 **Quick Commands Summary**

### **🚀 Start Development Server**
```bash
cd /mnt/d/project/ai-image-analyzer-workshop/ColorLab-Workshop
./run-hugo-server.sh
```

### **🏗️ Build Static Site**
```bash
cd /mnt/d/project/ai-image-analyzer-workshop/ColorLab-Workshop
hugo --minify
```

### **🧪 Test Different Ports**
```bash
hugo server -D --port 1314  # Port 1314
hugo server -D --port 8080  # Port 8080
```

### **🔍 Debug Mode**
```bash
hugo server -D --verbose --debug
```

---

## 📞 **Support & Resources**

### **📚 Documentation**
- **Hugo Documentation**: https://gohugo.io/documentation/
- **Learn Theme**: https://learn.netlify.app/en/
- **Markdown Guide**: https://www.markdownguide.org/

### **🛠️ Development**
- **Content**: Edit files in `content/` directory
- **Styling**: Modify `static/css/` files
- **Configuration**: Update `config.toml`
- **Themes**: Customize in `themes/` directory

### **🌐 Live Examples**
- **Similar Workshop**: https://000001.awsstudygroup.com/1-create-new-aws-account/
- **Hugo Learn Theme**: https://learn.netlify.app/en/
- **ColorLab Production**: http://ai-image-analyzer-web-1751723364.s3-website-ap-southeast-1.amazonaws.com

---

## ✅ **Ready to Start!**

### **🎯 Recommended Workflow**
1. **Start Development Server**: `./run-hugo-server.sh`
2. **Open Browser**: http://localhost:1313
3. **Navigate Workshop**: Follow modules 0-7
4. **Test Features**: Search, navigation, mobile view
5. **Build for Production**: `hugo --minify` when ready

### **🎨 Workshop URL Structure**
```
http://localhost:1313/                    # Homepage
http://localhost:1313/01-prerequisites/  # Module 1
http://localhost:1313/02-architecture/   # Module 2
http://localhost:1313/03-backend-development/  # Module 3
[... và các modules khác]
```

**🚀 Bắt đầu ngay:** `./run-hugo-server.sh`

**🎨 Chúc bạn có trải nghiệm workshop tuyệt vời với ColorLab!** ✨
