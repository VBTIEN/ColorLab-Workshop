#!/bin/bash

# 🎨 ColorLab-Workshop Hugo Server Launcher
# Starts Hugo development server for workshop documentation

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

print_header() {
    echo -e "${BLUE}"
    echo "🎨 =============================================="
    echo "   ColorLab-Workshop Hugo Server"
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

check_requirements() {
    print_info "Checking requirements..."
    
    # Check if Hugo is installed
    if ! command -v hugo > /dev/null; then
        print_error "Hugo not found. Please install Hugo first:"
        echo "  sudo apt update && sudo apt install hugo"
        exit 1
    fi
    
    print_success "Hugo found: $(hugo version | head -1)"
    
    # Check if we're in the right directory
    if [ ! -f "config.toml" ]; then
        print_error "config.toml not found. Please run this script from the ColorLab-Workshop directory."
        exit 1
    fi
    
    # Check theme
    if [ ! -d "themes/hugo-theme-learn" ]; then
        print_warning "Hugo theme not found. The site may not display correctly."
    else
        print_success "Hugo theme found"
    fi
    
    # Check content
    if [ ! -d "content" ]; then
        print_error "Content directory not found."
        exit 1
    fi
    
    print_success "Content directory found"
}

start_server() {
    print_info "Starting Hugo development server..."
    
    # Get local IP for network access
    LOCAL_IP=$(hostname -I | awk '{print $1}' 2>/dev/null || echo "localhost")
    
    echo -e "${GREEN}"
    echo "🌐 Hugo Server Starting..."
    echo "=========================="
    echo "📍 Local URL:    http://localhost:1313"
    echo "🌍 Network URL:  http://$LOCAL_IP:1313"
    echo "🔄 Live reload:  Enabled"
    echo "📱 Mobile:       Responsive design"
    echo "🎨 Theme:        hugo-theme-learn"
    echo ""
    echo "📚 Workshop Content:"
    echo "   - 7 comprehensive modules"
    echo "   - Interactive navigation"
    echo "   - Code syntax highlighting"
    echo "   - Search functionality"
    echo ""
    echo "⏹️  Press Ctrl+C to stop the server"
    echo -e "${NC}"
    
    # Start Hugo server with development settings
    hugo server \
        --bind 0.0.0.0 \
        --port 1313 \
        --buildDrafts \
        --buildFuture \
        --disableFastRender \
        --ignoreCache \
        --liveReloadPort 1314 \
        --navigateToChanged \
        --templateMetrics \
        --verbose
}

cleanup() {
    print_info "Shutting down Hugo server..."
    print_success "Server stopped. Thank you for using ColorLab-Workshop!"
}

# Set up cleanup on script exit
trap cleanup EXIT

# Main execution
main() {
    print_header
    check_requirements
    start_server
}

# Run main function
main "$@"
