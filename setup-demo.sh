#!/bin/bash

# 🚀 ColorLab-Workshop Automated Demo Setup Script
# Quickly sets up and runs demo in multiple ways

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

print_header() {
    echo -e "${PURPLE}"
    echo "🎨 =============================================="
    echo "   ColorLab-Workshop Demo Setup"
    echo "   Professional Color Analysis Platform"
    echo "===============================================${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_step() {
    echo -e "${CYAN}🔧 $1${NC}"
}

show_menu() {
    echo -e "${YELLOW}"
    echo "📋 Choose Demo Option:"
    echo "======================"
    echo "1) 🌐 Open Live Production Demo (Immediate)"
    echo "2) 🏠 Setup Local Hugo Website (5 minutes)"
    echo "3) 📄 Deploy to GitHub Pages (10 minutes)"
    echo "4) ☁️  Full AWS Deployment (30 minutes)"
    echo "5) 🧪 Test API Endpoints"
    echo "6) 📊 Show System Status"
    echo "7) 🆘 Help & Documentation"
    echo "0) 🚪 Exit"
    echo -e "${NC}"
}

open_live_demo() {
    print_step "Opening Live Production Demo..."
    
    echo -e "${GREEN}"
    echo "🎨 ColorLab-Workshop Live Demo URLs:"
    echo "===================================="
    echo "🌐 Web Interface:"
    echo "   http://ai-image-analyzer-web-1751723364.s3-website-ap-southeast-1.amazonaws.com"
    echo ""
    echo "🚀 API Endpoint:"
    echo "   https://spsvd9ec7i.execute-api.ap-southeast-1.amazonaws.com/prod/analyze"
    echo -e "${NC}"
    
    # Try to open in browser
    if command -v xdg-open > /dev/null; then
        print_info "Opening web interface in browser..."
        xdg-open "http://ai-image-analyzer-web-1751723364.s3-website-ap-southeast-1.amazonaws.com" 2>/dev/null &
    elif command -v open > /dev/null; then
        print_info "Opening web interface in browser..."
        open "http://ai-image-analyzer-web-1751723364.s3-website-ap-southeast-1.amazonaws.com" 2>/dev/null &
    else
        print_warning "Please manually open the URL in your browser"
    fi
    
    print_success "Live demo is ready! Upload any image to see color analysis."
}

setup_local_hugo() {
    print_step "Setting up Local Hugo Website..."
    
    # Check if Hugo is installed
    if ! command -v hugo > /dev/null; then
        print_warning "Hugo not found. Installing Hugo..."
        
        if command -v apt > /dev/null; then
            sudo apt update && sudo apt install -y hugo
        elif command -v brew > /dev/null; then
            brew install hugo
        else
            print_error "Please install Hugo manually: https://gohugo.io/installation/"
            return 1
        fi
    fi
    
    print_info "Hugo version: $(hugo version)"
    
    # Start Hugo server
    print_step "Starting Hugo development server..."
    print_info "Server will run on http://localhost:1313"
    print_info "Press Ctrl+C to stop the server"
    
    echo -e "${GREEN}"
    echo "🏠 Local Hugo Server Starting..."
    echo "================================"
    echo "📍 URL: http://localhost:1313"
    echo "🔄 Live reload enabled"
    echo "📱 Mobile responsive"
    echo -e "${NC}"
    
    # Start server with live reload
    hugo server -D --bind 0.0.0.0 --port 1313 --liveReload
}

deploy_github_pages() {
    print_step "Deploying to GitHub Pages..."
    
    # Check if we're in a git repository
    if [ ! -d ".git" ]; then
        print_error "Not in a git repository. Please run from ColorLab-Workshop directory."
        return 1
    fi
    
    # Check if Hugo is installed
    if ! command -v hugo > /dev/null; then
        print_error "Hugo not found. Please install Hugo first."
        return 1
    fi
    
    # Build static site
    print_step "Building static site with Hugo..."
    hugo --minify
    
    if [ ! -d "public" ]; then
        print_error "Hugo build failed. No public directory found."
        return 1
    fi
    
    # Create or switch to gh-pages branch
    print_step "Preparing GitHub Pages deployment..."
    
    # Stash current changes
    git stash push -m "Stash before gh-pages deployment"
    
    # Create gh-pages branch if it doesn't exist
    if ! git show-ref --verify --quiet refs/heads/gh-pages; then
        print_info "Creating gh-pages branch..."
        git checkout --orphan gh-pages
        git rm -rf .
    else
        print_info "Switching to gh-pages branch..."
        git checkout gh-pages
        git rm -rf . 2>/dev/null || true
    fi
    
    # Copy public content to root
    cp -r public/* .
    cp -r public/.* . 2>/dev/null || true
    
    # Add and commit
    git add .
    git commit -m "🚀 Deploy ColorLab-Workshop to GitHub Pages

✅ Generated with Hugo
📅 $(date)
🎨 Complete workshop documentation
📚 7-module curriculum
🌐 Mobile responsive design"
    
    # Push to GitHub
    print_step "Pushing to GitHub Pages..."
    git push origin gh-pages
    
    # Switch back to master
    git checkout master
    git stash pop 2>/dev/null || true
    
    print_success "Deployed to GitHub Pages!"
    echo -e "${GREEN}"
    echo "🌐 GitHub Pages URL:"
    echo "   https://vbtien.github.io/ColorLab-Workshop/"
    echo ""
    echo "⏱️  Note: It may take a few minutes for GitHub Pages to update"
    echo -e "${NC}"
}

full_aws_deployment() {
    print_step "Starting Full AWS Deployment..."
    
    # Check AWS CLI
    if ! command -v aws > /dev/null; then
        print_error "AWS CLI not found. Please install AWS CLI first."
        return 1
    fi
    
    # Check AWS credentials
    if ! aws sts get-caller-identity > /dev/null 2>&1; then
        print_error "AWS credentials not configured. Run 'aws configure' first."
        return 1
    fi
    
    print_info "AWS Account: $(aws sts get-caller-identity --query Account --output text)"
    print_info "AWS Region: $(aws configure get region)"
    
    print_warning "Full AWS deployment requires:"
    echo "  - AWS account with admin permissions"
    echo "  - Estimated cost: $5-10 for testing"
    echo "  - Time required: 30-45 minutes"
    echo ""
    
    read -p "Continue with AWS deployment? (y/N): " -n 1 -r
    echo
    
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_info "AWS deployment cancelled."
        return 0
    fi
    
    print_step "This would deploy:"
    echo "  1. Lambda function with color analysis algorithms"
    echo "  2. API Gateway with REST endpoints"
    echo "  3. S3 bucket for web hosting"
    echo "  4. IAM roles and policies"
    echo ""
    
    print_info "For detailed AWS deployment, please follow Workshop Module 2-5"
    print_info "Or use the existing production demo for immediate testing"
}

test_api_endpoints() {
    print_step "Testing API Endpoints..."
    
    # Check if curl is available
    if ! command -v curl > /dev/null; then
        print_error "curl not found. Please install curl to test API endpoints."
        return 1
    fi
    
    API_ENDPOINT="https://spsvd9ec7i.execute-api.ap-southeast-1.amazonaws.com/prod/analyze"
    
    print_info "Testing ColorLab API endpoint..."
    print_info "Endpoint: $API_ENDPOINT"
    
    # Test with a simple base64 image
    TEST_IMAGE="data:image/jpeg;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8/5+hHgAHggJ/PchI7wAAAABJRU5ErkJggg=="
    
    echo -e "${YELLOW}🧪 Sending test request...${NC}"
    
    RESPONSE=$(curl -s -X POST \
        -H "Content-Type: application/json" \
        -d "{\"image_data\": \"$TEST_IMAGE\"}" \
        "$API_ENDPOINT" \
        --max-time 30)
    
    if [ $? -eq 0 ]; then
        print_success "API endpoint is responding!"
        echo -e "${GREEN}📊 Response preview:${NC}"
        echo "$RESPONSE" | head -c 500
        echo "..."
        echo ""
        print_info "Full response saved to api-test-response.json"
        echo "$RESPONSE" > api-test-response.json
    else
        print_error "API endpoint test failed"
        print_info "Please check your internet connection and try again"
    fi
}

show_system_status() {
    print_step "Checking System Status..."
    
    echo -e "${CYAN}"
    echo "🖥️  System Information:"
    echo "======================"
    echo "OS: $(uname -s)"
    echo "Architecture: $(uname -m)"
    echo "Current Directory: $(pwd)"
    echo "User: $(whoami)"
    echo ""
    
    echo "📦 Installed Tools:"
    echo "=================="
    
    # Check Hugo
    if command -v hugo > /dev/null; then
        echo "✅ Hugo: $(hugo version | head -1)"
    else
        echo "❌ Hugo: Not installed"
    fi
    
    # Check Git
    if command -v git > /dev/null; then
        echo "✅ Git: $(git --version)"
    else
        echo "❌ Git: Not installed"
    fi
    
    # Check AWS CLI
    if command -v aws > /dev/null; then
        echo "✅ AWS CLI: $(aws --version)"
        if aws sts get-caller-identity > /dev/null 2>&1; then
            echo "   └─ Credentials: Configured"
        else
            echo "   └─ Credentials: Not configured"
        fi
    else
        echo "❌ AWS CLI: Not installed"
    fi
    
    # Check curl
    if command -v curl > /dev/null; then
        echo "✅ curl: $(curl --version | head -1)"
    else
        echo "❌ curl: Not installed"
    fi
    
    echo ""
    echo "📁 Repository Status:"
    echo "===================="
    if [ -d ".git" ]; then
        echo "✅ Git repository: $(git remote get-url origin 2>/dev/null || echo 'No remote')"
        echo "   └─ Branch: $(git branch --show-current)"
        echo "   └─ Last commit: $(git log -1 --pretty=format:'%h %s' 2>/dev/null || echo 'No commits')"
    else
        echo "❌ Not a git repository"
    fi
    
    echo ""
    echo "🌐 Live Demo Status:"
    echo "==================="
    if curl -s --head "http://ai-image-analyzer-web-1751723364.s3-website-ap-southeast-1.amazonaws.com" > /dev/null; then
        echo "✅ Web Interface: Online"
    else
        echo "❌ Web Interface: Offline or unreachable"
    fi
    
    if curl -s --head "https://spsvd9ec7i.execute-api.ap-southeast-1.amazonaws.com/prod/analyze" > /dev/null; then
        echo "✅ API Endpoint: Online"
    else
        echo "❌ API Endpoint: Offline or unreachable"
    fi
    
    echo -e "${NC}"
}

show_help() {
    echo -e "${BLUE}"
    echo "📚 ColorLab-Workshop Help & Documentation"
    echo "=========================================="
    echo ""
    echo "🎯 Quick Start Options:"
    echo "  1. Live Demo     - Immediate access to working system"
    echo "  2. Local Hugo    - Run documentation website locally"
    echo "  3. GitHub Pages  - Deploy workshop to GitHub Pages"
    echo "  4. AWS Deploy    - Full cloud deployment experience"
    echo ""
    echo "📖 Documentation Files:"
    echo "  - README.md              - Main documentation"
    echo "  - DEMO-SETUP-GUIDE.md    - Detailed setup instructions"
    echo "  - TECHNICAL-ACCURACY.md  - Technical specifications"
    echo "  - workshop-config.yaml   - Workshop configuration"
    echo ""
    echo "🌐 Live URLs:"
    echo "  - Web: http://ai-image-analyzer-web-1751723364.s3-website-ap-southeast-1.amazonaws.com"
    echo "  - API: https://spsvd9ec7i.execute-api.ap-southeast-1.amazonaws.com/prod/analyze"
    echo "  - Repo: https://github.com/VBTIEN/ColorLab-Workshop"
    echo ""
    echo "🎓 Workshop Modules:"
    echo "  - Module 0: Prerequisites & Setup (30 min)"
    echo "  - Module 1: Architecture Overview (20 min)"
    echo "  - Module 2: Backend Development (60 min)"
    echo "  - Module 3: API Gateway Setup (30 min)"
    echo "  - Module 4: Frontend Development (45 min)"
    echo "  - Module 5: S3 Integration (20 min)"
    echo "  - Module 6: Advanced Features (30 min)"
    echo "  - Module 7: Testing & Wrap-up (15 min)"
    echo ""
    echo "🔧 Technical Support:"
    echo "  - GitHub Issues: https://github.com/VBTIEN/ColorLab-Workshop/issues"
    echo "  - Documentation: ./DEMO-SETUP-GUIDE.md"
    echo "  - Workshop Content: ./content/ directory"
    echo -e "${NC}"
}

# Main script execution
main() {
    print_header
    
    # Check if we're in the right directory
    if [ ! -f "workshop-config.yaml" ]; then
        print_error "Please run this script from the ColorLab-Workshop directory"
        print_info "Current directory: $(pwd)"
        print_info "Expected files: workshop-config.yaml, README.md, content/"
        exit 1
    fi
    
    while true; do
        show_menu
        read -p "Enter your choice (0-7): " choice
        
        case $choice in
            1)
                open_live_demo
                ;;
            2)
                setup_local_hugo
                ;;
            3)
                deploy_github_pages
                ;;
            4)
                full_aws_deployment
                ;;
            5)
                test_api_endpoints
                ;;
            6)
                show_system_status
                ;;
            7)
                show_help
                ;;
            0)
                print_info "Thank you for using ColorLab-Workshop Demo Setup!"
                print_success "Happy learning! 🎨"
                exit 0
                ;;
            *)
                print_error "Invalid option. Please choose 0-7."
                ;;
        esac
        
        echo ""
        read -p "Press Enter to continue..." -r
        clear
    done
}

# Run main function
main "$@"
