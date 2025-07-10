#!/bin/bash

# 🚀 ColorLab-Workshop Quick Demo Launcher
# Opens live production demo immediately

echo "🎨 ColorLab-Workshop - Quick Demo Launcher"
echo "=========================================="
echo ""
echo "🌐 Opening Live Production Demo..."
echo ""
echo "✅ Web Interface:"
echo "   http://ai-image-analyzer-web-1751723364.s3-website-ap-southeast-1.amazonaws.com"
echo ""
echo "🚀 API Endpoint:"
echo "   https://spsvd9ec7i.execute-api.ap-southeast-1.amazonaws.com/prod/analyze"
echo ""

# Test if the web interface is accessible
echo "🧪 Testing web interface accessibility..."
if curl -s --head "http://ai-image-analyzer-web-1751723364.s3-website-ap-southeast-1.amazonaws.com" > /dev/null; then
    echo "✅ Web interface is online and accessible!"
else
    echo "⚠️  Web interface may be temporarily unavailable"
fi

echo ""
echo "🧪 Testing API endpoint..."
if curl -s --head "https://spsvd9ec7i.execute-api.ap-southeast-1.amazonaws.com/prod/analyze" > /dev/null; then
    echo "✅ API endpoint is online and accessible!"
else
    echo "⚠️  API endpoint may be temporarily unavailable"
fi

echo ""
echo "🎯 What you can do in the demo:"
echo "  • Upload any image (JPEG, PNG, GIF, BMP)"
echo "  • See real-time color analysis with K-Means++ clustering"
echo "  • View professional color names from 102-color database"
echo "  • Explore regional color distribution (3x3 grid)"
echo "  • Analyze color harmony, temperature, and statistics"
echo "  • Download analysis results as JSON"
echo ""

# Try to open in browser
if command -v xdg-open > /dev/null; then
    echo "🌐 Opening web interface in your default browser..."
    xdg-open "http://ai-image-analyzer-web-1751723364.s3-website-ap-southeast-1.amazonaws.com" 2>/dev/null &
    echo "✅ Browser opened! If it doesn't open automatically, copy the URL above."
elif command -v open > /dev/null; then
    echo "🌐 Opening web interface in your default browser..."
    open "http://ai-image-analyzer-web-1751723364.s3-website-ap-southeast-1.amazonaws.com" 2>/dev/null &
    echo "✅ Browser opened! If it doesn't open automatically, copy the URL above."
else
    echo "📋 Please manually copy and paste this URL into your browser:"
    echo "   http://ai-image-analyzer-web-1751723364.s3-website-ap-southeast-1.amazonaws.com"
fi

echo ""
echo "🎓 For complete workshop experience, run: ./setup-demo.sh"
echo "📚 For documentation, see: README.md and DEMO-SETUP-GUIDE.md"
echo ""
echo "🎨 Enjoy exploring ColorLab-Workshop! 🚀"
