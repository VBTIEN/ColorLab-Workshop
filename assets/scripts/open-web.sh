#!/bin/bash

# Script để mở web interface
WEB_PATH="$(pwd)/../web/index.html"
FULL_PATH="file://$WEB_PATH"

echo "🌐 Opening AI Image Analyzer Web Interface..."
echo "📍 Path: $FULL_PATH"
echo ""
echo "🖱️  Copy và paste URL này vào browser:"
echo "   $FULL_PATH"
echo ""
echo "📋 Hoặc navigate đến:"
echo "   $WEB_PATH"
echo ""
echo "🎯 Hướng dẫn sử dụng:"
echo "   1. Drag & drop ảnh vào vùng upload"
echo "   2. Click 'Analyze Image'"
echo "   3. Xem kết quả phân tích"
echo "   4. Chat với AI về ảnh"
echo ""
echo "📝 Lưu ý: Đang chạy ở demo mode với dữ liệu mẫu"

# Thử mở browser tự động (nếu có)
if command -v xdg-open > /dev/null; then
    echo "🚀 Attempting to open browser..."
    xdg-open "$FULL_PATH" 2>/dev/null &
elif command -v open > /dev/null; then
    echo "🚀 Attempting to open browser..."
    open "$FULL_PATH" 2>/dev/null &
else
    echo "⚠️  Please manually open the URL in your browser"
fi
