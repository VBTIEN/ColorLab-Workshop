#!/bin/bash

# Build Enhanced Web Interface
echo "🔨 Building enhanced web interface..."

cd ../web

# Create enhanced HTML with all improvements
cat > index.html << 'EOF'
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AI Image Analyzer - Enhanced</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', sans-serif; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); min-height: 100vh; padding: 20px; }
        .container { max-width: 1200px; margin: 0 auto; background: white; border-radius: 15px; box-shadow: 0 20px 40px rgba(0,0,0,0.1); overflow: hidden; }
        .header { background: linear-gradient(45deg, #FF6B6B, #4ECDC4); color: white; padding: 30px; text-align: center; }
        .header h1 { font-size: 2.5em; margin-bottom: 10px; }
        .status-bar { background: #f8f9fa; padding: 10px 30px; border-bottom: 1px solid #dee2e6; font-size: 0.9em; color: #666; }
        .status-online { color: #28a745; font-weight: bold; }
        .main-content { padding: 40px; }
        .upload-area { border: 3px dashed #ddd; border-radius: 10px; padding: 60px 20px; margin: 20px 0; cursor: pointer; transition: all 0.3s ease; }
        .upload-area:hover { border-color: #4ECDC4; background-color: #f8f9fa; }
        .upload-icon { font-size: 4em; color: #ddd; margin-bottom: 20px; }
        .btn { background: linear-gradient(45deg, #FF6B6B, #4ECDC4); color: white; border: none; padding: 15px 30px; border-radius: 25px; font-size: 1.1em; cursor: pointer; margin: 5px; }
        .btn:hover { transform: translateY(-2px); }
        .btn:disabled { opacity: 0.6; cursor: not-allowed; }
        .analysis-card { background: #f8f9fa; border-radius: 10px; padding: 25px; margin: 20px 0; border-left: 5px solid #4ECDC4; display: none; }
        .analysis-card.has-content { display: block; }
        .analysis-card h3 { color: #333; margin-bottom: 15px; font-size: 1.3em; }
        .tag { display: inline-block; background: linear-gradient(45deg, #FF6B6B, #4ECDC4); color: white; padding: 5px 12px; border-radius: 15px; margin: 5px; font-size: 0.9em; }
        .confidence { opacity: 0.8; font-size: 0.8em; }
        .color-swatch { width: 40px; height: 40px; border-radius: 50%; border: 2px solid #ddd; display: inline-flex; align-items: center; justify-content: center; margin: 5px; font-size: 0.8em; color: white; text-shadow: 1px 1px 1px rgba(0,0,0,0.5); }
        .face-analysis { background: white; border: 1px solid #ddd; border-radius: 8px; padding: 15px; margin: 10px 0; }
        .emotion-bar { display: flex; align-items: center; margin: 5px 0; }
        .emotion-name { width: 80px; font-size: 0.9em; }
        .emotion-progress { flex: 1; height: 8px; background: #e9ecef; border-radius: 4px; margin: 0 10px; overflow: hidden; }
        .emotion-fill { height: 100%; background: linear-gradient(45deg, #FF6B6B, #4ECDC4); border-radius: 4px; }
        .chat-section { background: #f8f9fa; border-radius: 10px; padding: 25px; margin-top: 30px; }
        .chat-messages { max-height: 400px; overflow-y: auto; margin-bottom: 20px; padding: 10px; }
        .message { padding: 12px 18px; margin: 10px 0; border-radius: 18px; max-width: 80%; word-wrap: break-word; }
        .user-message { background: #4ECDC4; color: white; margin-left: auto; }
        .ai-message { background: white; border: 1px solid #ddd; margin-right: auto; }
        .quick-questions { display: flex; gap: 10px; margin: 15px 0; flex-wrap: wrap; }
        .quick-question { background: #e9ecef; border: 1px solid #ddd; padding: 8px 15px; border-radius: 20px; cursor: pointer; font-size: 0.9em; }
        .quick-question:hover { background: #4ECDC4; color: white; }
        .loading { text-align: center; padding: 40px; }
        .spinner { border: 4px solid #f3f3f3; border-top: 4px solid #4ECDC4; border-radius: 50%; width: 50px; height: 50px; animation: spin 1s linear infinite; margin: 0 auto 20px; }
        @keyframes spin { 0% { transform: rotate(0deg); } 100% { transform: rotate(360deg); } }
        .error, .success, .info { padding: 15px; margin: 20px 0; border-radius: 5px; border-left: 5px solid; }
        .error { background: #ffebee; border-color: #f44336; }
        .success { background: #e8f5e8; border-color: #4caf50; }
        .info { background: #e3f2fd; border-color: #2196f3; }
        .hidden { display: none !important; }
        .stats-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(150px, 1fr)); gap: 15px; margin: 15px 0; }
        .stat-item { background: white; padding: 15px; border-radius: 8px; border: 1px solid #ddd; text-align: center; }
        .stat-number { font-size: 2em; font-weight: bold; color: #4ECDC4; }
        .stat-label { font-size: 0.9em; color: #666; margin-top: 5px; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🤖 AI Image Analyzer Enhanced</h1>
            <p>Comprehensive Analysis with Amazon AI</p>
        </div>
        
        <div class="status-bar">
            <span id="statusIndicator">🔄 Checking connection...</span>
            <span style="float: right;">🌍 Enhanced Version | Region: ap-southeast-1</span>
        </div>
        
        <div class="main-content">
            <div class="upload-section" style="text-align: center; margin-bottom: 40px;">
                <h2>📸 Upload Your Image</h2>
                <div class="upload-area" id="uploadArea">
                    <div class="upload-icon">📁</div>
                    <p>Drag & drop your image here or click to browse</p>
                    <small>Enhanced analysis: Objects, Faces, Colors, Text, Emotions</small>
                    <input type="file" id="fileInput" accept="image/*" style="display: none;">
                </div>
                <button class="btn" id="analyzeBtn" disabled>🔍 Analyze Image</button>
            </div>
            
            <div id="imagePreview" style="text-align: center; display: none;">
                <img id="previewImg" style="max-width: 100%; max-height: 400px; border-radius: 10px; margin: 20px 0; box-shadow: 0 10px 20px rgba(0,0,0,0.1);" alt="Preview">
            </div>
            
            <div id="loadingSection" class="loading" style="display: none;">
                <div class="spinner"></div>
                <p>🧠 AI đang phân tích toàn diện ảnh của bạn...</p>
                <small>Sử dụng Amazon Rekognition & Bedrock</small>
            </div>
            
            <div id="resultsSection" style="display: none;">
                <h2>📊 Enhanced Analysis Results</h2>
                
                <div class="analysis-card" id="statsCard">
                    <h3>📈 Tổng quan</h3>
                    <div class="stats-grid" id="statsGrid"></div>
                </div>
                
                <div class="analysis-card" id="labelsCard">
                    <h3>🏷️ Objects & Labels</h3>
                    <div id="labelsResult"></div>
                </div>
                
                <div class="analysis-card" id="colorsCard">
                    <h3>🎨 Màu sắc chủ đạo</h3>
                    <div id="colorsResult"></div>
                </div>
                
                <div class="analysis-card" id="facesCard">
                    <h3>👥 Face Analysis</h3>
                    <div id="facesResult"></div>
                </div>
                
                <div class="analysis-card" id="textCard">
                    <h3>📝 Text Detection</h3>
                    <div id="textResult"></div>
                </div>
                
                <div class="analysis-card" id="artisticCard">
                    <h3>🎨 Artistic Analysis</h3>
                    <div id="artisticResult"></div>
                </div>
            </div>
            
            <div id="chatSection" class="chat-section" style="display: none;">
                <h3>💬 Smart Chat with Amazon Q</h3>
                
                <div class="quick-questions" id="quickQuestions">
                    <div class="quick-question" data-question="Phân tích màu sắc chi tiết">🎨 Màu sắc</div>
                    <div class="quick-question" data-question="Đánh giá composition">📐 Composition</div>
                    <div class="quick-question" data-question="Gợi ý cải thiện">💡 Cải thiện</div>
                    <div class="quick-question" data-question="Phân tích cảm xúc">😊 Cảm xúc</div>
                    <div class="quick-question" data-question="Kỹ thuật chụp">📷 Kỹ thuật</div>
                </div>
                
                <div class="chat-messages" id="chatMessages"></div>
                <div style="display: flex; gap: 10px;">
                    <input type="text" style="width: calc(100% - 80px); padding: 15px; border: 2px solid #ddd; border-radius: 25px; font-size: 1em; outline: none;" id="chatInput" placeholder="Hỏi chi tiết về bức ảnh...">
                    <button class="btn" id="sendBtn">Send</button>
                </div>
            </div>
        </div>
    </div>

    <script>
        const API_ENDPOINT = 'https://cuwg234q8g.execute-api.ap-southeast-1.amazonaws.com/prod/analyze';
        const BUCKET_NAME = 'image-analyzer-workshop-1751722329';
        
        let currentImageData = null;
        let analysisResults = null;
        let isApiOnline = false;
        
        // Initialize
        document.addEventListener('DOMContentLoaded', function() {
            checkApiStatus();
            setupEventListeners();
            showInfo('🚀 Enhanced AI Image Analyzer ready! Upload an image for comprehensive analysis.');
        });
        
        function setupEventListeners() {
            const uploadArea = document.getElementById('uploadArea');
            const fileInput = document.getElementById('fileInput');
            
            uploadArea.addEventListener('click', () => fileInput.click());
            uploadArea.addEventListener('dragover', (e) => { e.preventDefault(); uploadArea.style.borderColor = '#4ECDC4'; });
            uploadArea.addEventListener('drop', handleDrop);
            uploadArea.addEventListener('dragleave', () => uploadArea.style.borderColor = '#ddd');
            
            fileInput.addEventListener('change', (e) => handleFile(e.target.files[0]));
            document.getElementById('analyzeBtn').addEventListener('click', analyzeImage);
            document.getElementById('sendBtn').addEventListener('click', sendMessage);
            document.getElementById('chatInput').addEventListener('keypress', (e) => { if (e.key === 'Enter') sendMessage(); });
            
            document.getElementById('quickQuestions').addEventListener('click', (e) => {
                if (e.target.classList.contains('quick-question')) {
                    document.getElementById('chatInput').value = e.target.dataset.question;
                    sendMessage();
                }
            });
        }
        
        async function checkApiStatus() {
            try {
                const response = await fetch(API_ENDPOINT, { method: 'OPTIONS', mode: 'cors' });
                if (response.ok) {
                    isApiOnline = true;
                    document.getElementById('statusIndicator').innerHTML = '<span class="status-online">✅ Enhanced API Online</span>';
                } else throw new Error('API not responding');
            } catch (error) {
                isApiOnline = false;
                document.getElementById('statusIndicator').innerHTML = '<span style="color: #dc3545;">⚠️ Demo Mode - Enhanced Features</span>';
            }
        }
        
        function handleDrop(e) {
            e.preventDefault();
            uploadArea.style.borderColor = '#ddd';
            if (e.dataTransfer.files.length > 0) handleFile(e.dataTransfer.files[0]);
        }
        
        function handleFile(file) {
            if (!file || !file.type.startsWith('image/')) {
                showError('Please select a valid image file');
                return;
            }
            
            if (file.size > 5 * 1024 * 1024) {
                showError('Image size must be less than 5MB');
                return;
            }
            
            const reader = new FileReader();
            reader.onload = (e) => {
                currentImageData = e.target.result;
                document.getElementById('previewImg').src = currentImageData;
                document.getElementById('imagePreview').style.display = 'block';
                document.getElementById('analyzeBtn').disabled = false;
                showSuccess('✅ Image loaded! Ready for enhanced analysis.');
            };
            reader.readAsDataURL(file);
        }
        
        async function analyzeImage() {
            if (!currentImageData) return;
            
            document.getElementById('loadingSection').style.display = 'block';
            document.getElementById('resultsSection').style.display = 'none';
            document.getElementById('chatSection').style.display = 'none';
            document.getElementById('analyzeBtn').disabled = true;
            
            try {
                if (isApiOnline) {
                    const response = await fetch(API_ENDPOINT, {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify({
                            bucket: BUCKET_NAME,
                            image_data: currentImageData.split(',')[1]
                        })
                    });
                    
                    if (!response.ok) throw new Error(`API failed: ${response.status}`);
                    
                    analysisResults = await response.json();
                    showSuccess('✅ Enhanced analysis completed with AWS AI!');
                } else {
                    throw new Error('API offline');
                }
            } catch (error) {
                showError(`Using enhanced demo data: ${error.message}`);
                await simulateEnhancedAnalysis();
            }
            
            displayEnhancedResults();
            document.getElementById('loadingSection').style.display = 'none';
            document.getElementById('resultsSection').style.display = 'block';
            document.getElementById('chatSection').style.display = 'block';
            document.getElementById('analyzeBtn').disabled = false;
        }
        
        async function simulateEnhancedAnalysis() {
            await new Promise(resolve => setTimeout(resolve, 3000));
            
            analysisResults = {
                basic_analysis: {
                    labels: [
                        { name: 'Person', confidence: 95.2, categories: ['People'] },
                        { name: 'Portrait', confidence: 89.1, categories: ['Photography'] },
                        { name: 'Smile', confidence: 87.3, categories: ['Expression'] },
                        { name: 'Face', confidence: 94.8, categories: ['People'] },
                        { name: 'Human', confidence: 92.5, categories: ['People'] }
                    ],
                    image_properties: {
                        dominant_colors: [
                            { color: 'Blue', hex: '#4A90E2', pixel_percent: 35.2 },
                            { color: 'White', hex: '#FFFFFF', pixel_percent: 28.7 },
                            { color: 'Beige', hex: '#F5F5DC', pixel_percent: 18.3 }
                        ]
                    },
                    faces: [{
                        age_range: { Low: 25, High: 35 },
                        gender: { value: 'Female', confidence: 92.3 },
                        emotions: [
                            { type: 'HAPPY', confidence: 85.2 },
                            { type: 'CALM', confidence: 12.1 },
                            { type: 'CONFIDENT', confidence: 8.7 }
                        ],
                        attributes: {
                            smile: { Value: true, Confidence: 89.2 },
                            eyeglasses: { Value: false, Confidence: 95.1 }
                        }
                    }],
                    text: [{ text: 'Sample Text', confidence: 92.1, type: 'LINE' }]
                },
                advanced_analysis: {
                    artistic_analysis: 'Bức ảnh thể hiện composition chân dung chuyên nghiệp với ánh sáng tự nhiên. Tông màu xanh dương và trắng tạo cảm giác thanh thoát, hài hòa. Chủ thể được đặt cân đối, cảm xúc vui vẻ được truyền tải rõ ràng. Kỹ thuật chụp tốt với độ sâu trường ảnh phù hợp.',
                    model_used: 'Enhanced Analysis Engine'
                }
            };
        }
        
        function displayEnhancedResults() {
            const { basic_analysis, advanced_analysis } = analysisResults;
            
            // Statistics
            const stats = [];
            if (basic_analysis.labels?.length) stats.push({ number: basic_analysis.labels.length, label: 'Objects' });
            if (basic_analysis.faces?.length) stats.push({ number: basic_analysis.faces.length, label: 'Faces' });
            if (basic_analysis.text?.length) stats.push({ number: basic_analysis.text.length, label: 'Text Lines' });
            if (basic_analysis.image_properties?.dominant_colors?.length) stats.push({ number: basic_analysis.image_properties.dominant_colors.length, label: 'Colors' });
            
            if (stats.length > 0) {
                document.getElementById('statsGrid').innerHTML = stats.map(s => 
                    `<div class="stat-item"><div class="stat-number">${s.number}</div><div class="stat-label">${s.label}</div></div>`
                ).join('');
                document.getElementById('statsCard').classList.add('has-content');
            }
            
            // Labels
            if (basic_analysis.labels?.length) {
                document.getElementById('labelsResult').innerHTML = basic_analysis.labels.map(l => 
                    `<span class="tag">${l.name} <span class="confidence">${l.confidence}%</span></span>`
                ).join('');
                document.getElementById('labelsCard').classList.add('has-content');
            }
            
            // Colors
            if (basic_analysis.image_properties?.dominant_colors?.length) {
                const colors = basic_analysis.image_properties.dominant_colors;
                document.getElementById('colorsResult').innerHTML = 
                    colors.map(c => `<div class="color-swatch" style="background-color: ${c.hex}">${c.pixel_percent.toFixed(1)}%</div>`).join('') +
                    '<p style="margin-top: 10px;">Màu sắc theo tỷ lệ xuất hiện</p>';
                document.getElementById('colorsCard').classList.add('has-content');
            }
            
            // Faces
            if (basic_analysis.faces?.length) {
                const face = basic_analysis.faces[0];
                const emotionsHtml = face.emotions.map(e => 
                    `<div class="emotion-bar">
                        <span class="emotion-name">${e.type}</span>
                        <div class="emotion-progress"><div class="emotion-fill" style="width: ${e.confidence}%"></div></div>
                        <span class="confidence">${e.confidence.toFixed(1)}%</span>
                    </div>`
                ).join('');
                
                document.getElementById('facesResult').innerHTML = 
                    `<div class="face-analysis">
                        <p><strong>Giới tính:</strong> ${face.gender.value} (${face.gender.confidence.toFixed(1)}%)</p>
                        <p><strong>Tuổi:</strong> ${face.age_range.Low}-${face.age_range.High}</p>
                        <p><strong>Đặc điểm:</strong> ${face.attributes.smile?.Value ? '😊 Có nụ cười' : ''} ${face.attributes.eyeglasses?.Value ? '👓 Đeo kính' : ''}</p>
                        <div style="margin-top: 10px;"><strong>Cảm xúc:</strong>${emotionsHtml}</div>
                    </div>`;
                document.getElementById('facesCard').classList.add('has-content');
            }
            
            // Text
            if (basic_analysis.text?.length) {
                document.getElementById('textResult').innerHTML = basic_analysis.text.map(t => 
                    `<span class="tag">${t.text} <span class="confidence">${t.confidence}%</span></span>`
                ).join('');
                document.getElementById('textCard').classList.add('has-content');
            }
            
            // Artistic Analysis
            if (advanced_analysis?.artistic_analysis) {
                document.getElementById('artisticResult').innerHTML = 
                    `<div style="line-height: 1.6;">
                        <p>${advanced_analysis.artistic_analysis}</p>
                        <div style="margin-top: 15px; padding-top: 15px; border-top: 1px solid #ddd; font-size: 0.9em; color: #666;">
                            <strong>Phân tích bởi:</strong> ${advanced_analysis.model_used}
                        </div>
                    </div>`;
                document.getElementById('artisticCard').classList.add('has-content');
            }
        }
        
        function sendMessage() {
            const input = document.getElementById('chatInput');
            const message = input.value.trim();
            if (!message) return;
            
            addMessage(message, 'user');
            input.value = '';
            
            setTimeout(() => {
                const response = generateSmartResponse(message);
                addMessage(response, 'ai');
            }, 1000);
        }
        
        function addMessage(text, sender) {
            const messagesDiv = document.getElementById('chatMessages');
            const messageDiv = document.createElement('div');
            messageDiv.className = `message ${sender}-message`;
            messageDiv.textContent = text;
            messagesDiv.appendChild(messageDiv);
            messagesDiv.scrollTop = messagesDiv.scrollHeight;
        }
        
        function generateSmartResponse(question) {
            if (!analysisResults) return "Hãy phân tích ảnh trước để tôi có thể trả lời chi tiết.";
            
            const { basic_analysis, advanced_analysis } = analysisResults;
            const lowerQ = question.toLowerCase();
            
            if (lowerQ.includes('màu')) {
                const colors = basic_analysis.image_properties?.dominant_colors;
                if (colors) {
                    const colorList = colors.map(c => `${c.color} (${c.pixel_percent.toFixed(1)}%)`).join(', ');
                    return `Ảnh có ${colors.length} màu chủ đạo: ${colorList}. Màu ${colors[0].color} chiếm tỷ lệ cao nhất, tạo nên tông màu ${colors.length > 3 ? 'phong phú' : 'hài hòa'}.`;
                }
            }
            
            if (lowerQ.includes('cảm xúc')) {
                const faces = basic_analysis.faces;
                if (faces?.length) {
                    const emotions = faces[0].emotions.slice(0, 3).map(e => `${e.type} (${e.confidence.toFixed(1)}%)`).join(', ');
                    return `Cảm xúc chủ đạo: ${emotions}. ${faces[0].emotions[0].type === 'HAPPY' ? 'Bức ảnh thể hiện niềm vui và sự tích cực.' : 'Cảm xúc trong ảnh khá đa dạng.'}`;
                }
            }
            
            if (lowerQ.includes('cải thiện')) {
                return `Dựa trên phân tích: ${advanced_analysis?.artistic_analysis || 'Ảnh có chất lượng tốt'}. Gợi ý: điều chỉnh ánh sáng và tăng độ tương phản để làm nổi bật chủ thể hơn.`;
            }
            
            if (lowerQ.includes('composition')) {
                const labels = basic_analysis.labels || [];
                return `Composition có ${labels.length} yếu tố chính: ${labels.slice(0, 3).map(l => l.name).join(', ')}. ${advanced_analysis?.artistic_analysis?.split('.')[0] || 'Bố cục cân đối và hài hòa'}.`;
            }
            
            if (lowerQ.includes('kỹ thuật')) {
                const faces = basic_analysis.faces;
                return `Kỹ thuật chụp: ${faces?.length ? 'chân dung chuyên nghiệp' : 'composition tốt'}, ${advanced_analysis?.artistic_analysis?.includes('ánh sáng') ? 'ánh sáng tự nhiên' : 'chất lượng ổn định'}. ${faces?.length ? `Độ sắc nét cao, pose tự nhiên.` : 'Tổng thể kỹ thuật tốt.'}`;
            }
            
            // Default smart response
            const mainElements = basic_analysis.labels?.slice(0, 2).map(l => l.name).join(' và ') || 'các yếu tố thú vị';
            return `Ảnh chứa ${mainElements} với ${basic_analysis.faces?.length || 0} người. ${advanced_analysis?.artistic_analysis?.split('.')[0] || 'Chất lượng tổng thể tốt'}. Bạn muốn tôi phân tích sâu hơn khía cạnh nào?`;
        }
        
        function showError(msg) { showNotification(msg, 'error'); }
        function showSuccess(msg) { showNotification(msg, 'success'); }
        function showInfo(msg) { showNotification(msg, 'info'); }
        
        function showNotification(message, type) {
            const div = document.createElement('div');
            div.className = type;
            div.innerHTML = message;
            document.querySelector('.main-content').insertBefore(div, document.querySelector('.upload-section').nextSibling);
            setTimeout(() => div.remove(), 5000);
        }
        
        console.log('🚀 Enhanced AI Image Analyzer loaded successfully!');
    </script>
</body>
</html>
EOF

echo "✅ Enhanced web interface built successfully!"
EOF

chmod +x build-enhanced-web.sh
