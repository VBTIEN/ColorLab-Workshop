#!/bin/bash

# Demo Mode - Chạy workshop mà không cần AWS credentials thật
echo "🎭 Starting Demo Mode..."

# Tạo fake credentials cho demo
mkdir -p ~/.aws
cat > ~/.aws/credentials << EOF
[default]
aws_access_key_id = DEMO_ACCESS_KEY_ID
aws_secret_access_key = DEMO_SECRET_ACCESS_KEY
EOF

cat > ~/.aws/config << EOF
[default]
region = us-east-1
output = json
EOF

echo "✅ Demo credentials configured"

# Tạo fake output files
mkdir -p ../output
echo "image-analyzer-workshop-demo-$(date +%s)" > ../output/bucket-name.txt
echo "https://demo-api.execute-api.us-east-1.amazonaws.com/prod/analyze" > ../output/api-endpoint.txt

echo "✅ Demo environment setup complete"
echo ""
echo "🌐 Bây giờ bạn có thể mở web interface:"
echo "   file://$(pwd)/../web/index.html"
echo ""
echo "📝 Lưu ý: Đây là demo mode, không kết nối AWS thật"
echo "   - Web interface sẽ hiển thị kết quả mẫu"
echo "   - Để sử dụng AWS thật, cần cấu hình credentials"
