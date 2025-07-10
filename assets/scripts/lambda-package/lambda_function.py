import json
import boto3
import base64
from urllib.parse import unquote_plus
import uuid
from datetime import datetime

# Initialize AWS clients
rekognition = boto3.client('rekognition')
s3 = boto3.client('s3')
bedrock = boto3.client('bedrock-runtime')

def lambda_handler(event, context):
    """
    Lambda function để phân tích ảnh với Amazon Rekognition và Bedrock
    """
    
    # Add CORS headers
    headers = {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Headers': 'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token',
        'Access-Control-Allow-Methods': 'GET,POST,OPTIONS'
    }
    
    try:
        # Handle OPTIONS request for CORS
        if event.get('httpMethod') == 'OPTIONS':
            return {
                'statusCode': 200,
                'headers': headers,
                'body': json.dumps({'message': 'CORS preflight'})
            }
        
        # Parse input
        if 'body' in event:
            # API Gateway request
            body = json.loads(event['body']) if isinstance(event['body'], str) else event['body']
            bucket = body.get('bucket', 'image-analyzer-workshop-1751722329')
            image_data = body.get('image_data')
            
            if not image_data:
                return {
                    'statusCode': 400,
                    'headers': headers,
                    'body': json.dumps({'error': 'Missing image_data parameter'})
                }
            
            # Generate unique key for the image
            key = f"uploads/{datetime.now().strftime('%Y/%m/%d')}/{str(uuid.uuid4())}.jpg"
            
            # Upload image to S3
            try:
                image_bytes = base64.b64decode(image_data)
                s3.put_object(
                    Bucket=bucket,
                    Key=key,
                    Body=image_bytes,
                    ContentType='image/jpeg'
                )
                print(f"Image uploaded to s3://{bucket}/{key}")
            except Exception as e:
                print(f"Failed to upload image to S3: {str(e)}")
                return {
                    'statusCode': 500,
                    'headers': headers,
                    'body': json.dumps({'error': f'Failed to upload image: {str(e)}'})
                }
                
        elif 'Records' in event:
            # S3 trigger
            bucket = event['Records'][0]['s3']['bucket']['name']
            key = unquote_plus(event['Records'][0]['s3']['object']['key'])
        else:
            # Direct invocation
            bucket = event.get('bucket')
            key = event.get('key')
            
        if not bucket or not key:
            return {
                'statusCode': 400,
                'headers': headers,
                'body': json.dumps({'error': 'Missing bucket or key parameter'})
            }
        
        # Comprehensive image analysis with Rekognition
        print(f"Analyzing image: s3://{bucket}/{key}")
        rekognition_results = comprehensive_rekognition_analysis(bucket, key)
        
        # Get advanced analysis with Bedrock
        bedrock_analysis = analyze_with_bedrock(bucket, key, rekognition_results)
        
        # Combine results
        analysis_result = {
            'image': f's3://{bucket}/{key}',
            'basic_analysis': rekognition_results,
            'advanced_analysis': bedrock_analysis,
            'timestamp': datetime.now().isoformat(),
            'request_id': context.aws_request_id
        }
        
        return {
            'statusCode': 200,
            'headers': headers,
            'body': json.dumps(analysis_result, indent=2)
        }
        
    except Exception as e:
        print(f"Error: {str(e)}")
        return {
            'statusCode': 500,
            'headers': headers,
            'body': json.dumps({'error': f'Error analyzing image: {str(e)}'})
        }

def comprehensive_rekognition_analysis(bucket, key):
    """Phân tích toàn diện với Amazon Rekognition"""
    
    results = {}
    
    try:
        # 1. Detect labels (objects, scenes, activities)
        labels_response = rekognition.detect_labels(
            Image={'S3Object': {'Bucket': bucket, 'Name': key}},
            MaxLabels=30,
            MinConfidence=60,
            Features=['GENERAL_LABELS', 'IMAGE_PROPERTIES']
        )
        
        results['labels'] = [
            {
                'name': label['Name'],
                'confidence': round(label['Confidence'], 2),
                'categories': [cat['Name'] for cat in label.get('Categories', [])],
                'instances': len(label.get('Instances', [])),
                'parents': [parent['Name'] for parent in label.get('Parents', [])]
            }
            for label in labels_response['Labels']
        ]
        
        # Extract image properties if available
        if 'ImageProperties' in labels_response:
            image_props = labels_response['ImageProperties']
            results['image_properties'] = {
                'quality': image_props.get('Quality', {}),
                'dominant_colors': [
                    {
                        'color': color.get('SimplifiedColor', 'Unknown'),
                        'hex': color.get('CSSColor', '#000000'),
                        'pixel_percent': round(color.get('PixelPercent', 0), 2)
                    }
                    for color in image_props.get('DominantColors', [])[:5]
                ],
                'foreground': image_props.get('Foreground', {}),
                'background': image_props.get('Background', {})
            }
        
        # 2. Detect faces with comprehensive attributes
        faces_response = rekognition.detect_faces(
            Image={'S3Object': {'Bucket': bucket, 'Name': key}},
            Attributes=['ALL']
        )
        
        results['faces'] = []
        for face in faces_response['FaceDetails']:
            face_analysis = {
                'age_range': face['AgeRange'],
                'gender': {
                    'value': face['Gender']['Value'],
                    'confidence': round(face['Gender']['Confidence'], 2)
                },
                'emotions': [
                    {
                        'type': emotion['Type'],
                        'confidence': round(emotion['Confidence'], 2)
                    }
                    for emotion in sorted(face['Emotions'], key=lambda x: x['Confidence'], reverse=True)[:5]
                ],
                'attributes': {
                    'smile': face.get('Smile', {}),
                    'eyeglasses': face.get('Eyeglasses', {}),
                    'sunglasses': face.get('Sunglasses', {}),
                    'beard': face.get('Beard', {}),
                    'mustache': face.get('Mustache', {}),
                    'eyes_open': face.get('EyesOpen', {}),
                    'mouth_open': face.get('MouthOpen', {})
                },
                'quality': face.get('Quality', {}),
                'pose': {
                    'roll': round(face.get('Pose', {}).get('Roll', 0), 2),
                    'yaw': round(face.get('Pose', {}).get('Yaw', 0), 2),
                    'pitch': round(face.get('Pose', {}).get('Pitch', 0), 2)
                }
            }
            results['faces'].append(face_analysis)
        
        # 3. Detect text with location info
        text_response = rekognition.detect_text(
            Image={'S3Object': {'Bucket': bucket, 'Name': key}}
        )
        
        results['text'] = [
            {
                'text': text['DetectedText'],
                'confidence': round(text['Confidence'], 2),
                'type': text['Type'],
                'id': text.get('Id', 0)
            }
            for text in text_response['TextDetections']
            if text['Type'] == 'LINE' and text['Confidence'] > 70
        ]
        
        # 4. Detect celebrities (if any)
        try:
            celebrities_response = rekognition.recognize_celebrities(
                Image={'S3Object': {'Bucket': bucket, 'Name': key}}
            )
            
            results['celebrities'] = [
                {
                    'name': celeb['Name'],
                    'confidence': round(celeb['MatchConfidence'], 2),
                    'urls': celeb.get('Urls', [])
                }
                for celeb in celebrities_response['CelebrityFaces']
                if celeb['MatchConfidence'] > 80
            ]
        except:
            results['celebrities'] = []
        
        # 5. Detect moderation labels
        try:
            moderation_response = rekognition.detect_moderation_labels(
                Image={'S3Object': {'Bucket': bucket, 'Name': key}},
                MinConfidence=60
            )
            
            results['content_moderation'] = [
                {
                    'name': label['Name'],
                    'confidence': round(label['Confidence'], 2),
                    'parent_name': label.get('ParentName', '')
                }
                for label in moderation_response['ModerationLabels']
            ]
        except:
            results['content_moderation'] = []
        
    except Exception as e:
        results['error'] = f"Rekognition analysis failed: {str(e)}"
        print(f"Rekognition error: {str(e)}")
    
    return results

def analyze_with_bedrock(bucket, key, rekognition_data):
    """Phân tích nâng cao với Amazon Bedrock"""
    
    try:
        # Create comprehensive prompt
        prompt = create_comprehensive_analysis_prompt(rekognition_data)
        
        # Try different model IDs
        model_ids = [
            'anthropic.claude-3-haiku-20240307-v1:0',
            'anthropic.claude-v2:1',
            'anthropic.claude-v2'
        ]
        
        for model_id in model_ids:
            try:
                print(f"Trying Bedrock model: {model_id}")
                
                if 'claude-3' in model_id:
                    response = bedrock.invoke_model(
                        modelId=model_id,
                        body=json.dumps({
                            'anthropic_version': 'bedrock-2023-05-31',
                            'max_tokens': 1500,
                            'messages': [
                                {
                                    'role': 'user',
                                    'content': prompt
                                }
                            ]
                        })
                    )
                    
                    response_body = json.loads(response['body'].read())
                    analysis = response_body['content'][0]['text']
                else:
                    response = bedrock.invoke_model(
                        modelId=model_id,
                        body=json.dumps({
                            'prompt': f"\n\nHuman: {prompt}\n\nAssistant:",
                            'max_tokens_to_sample': 1500,
                            'temperature': 0.7,
                            'top_p': 1,
                        })
                    )
                    
                    response_body = json.loads(response['body'].read())
                    analysis = response_body['completion']
                
                return {
                    'artistic_analysis': analysis.strip(),
                    'model_used': model_id,
                    'analysis_type': 'ai_generated'
                }
                
            except Exception as model_error:
                print(f"Model {model_id} failed: {str(model_error)}")
                continue
        
        raise Exception("All Bedrock models failed")
        
    except Exception as e:
        print(f"Bedrock error: {str(e)}")
        return {
            'artistic_analysis': generate_comprehensive_fallback_analysis(rekognition_data),
            'model_used': 'Comprehensive Fallback Analysis',
            'analysis_type': 'rule_based',
            'note': 'Bedrock không khả dụng, sử dụng phân tích dự phòng chi tiết'
        }

def create_comprehensive_analysis_prompt(rekognition_data):
    """Tạo prompt chi tiết cho Bedrock"""
    
    labels = rekognition_data.get('labels', [])
    faces = rekognition_data.get('faces', [])
    text = rekognition_data.get('text', [])
    colors = rekognition_data.get('image_properties', {}).get('dominant_colors', [])
    celebrities = rekognition_data.get('celebrities', [])
    
    # Categorize labels
    people_labels = [l['name'] for l in labels if any(cat in ['People', 'Person'] for cat in l.get('categories', []))]
    object_labels = [l['name'] for l in labels if any(cat in ['Objects', 'Vehicles', 'Electronics'] for cat in l.get('categories', []))]
    scene_labels = [l['name'] for l in labels if any(cat in ['Outdoors', 'Indoors', 'Nature'] for cat in l.get('categories', []))]
    activity_labels = [l['name'] for l in labels if any(cat in ['Activities', 'Sports', 'Hobbies'] for cat in l.get('categories', []))]
    
    prompt = f"""
    Bạn là một chuyên gia phân tích nghệ thuật và nhiếp ảnh. Hãy phân tích bức ảnh dựa trên thông tin chi tiết sau:

    🎨 THÔNG TIN HÌNH ẢNH:
    - Đối tượng chính: {', '.join(people_labels[:5]) if people_labels else 'Không có người'}
    - Vật thể: {', '.join(object_labels[:5]) if object_labels else 'Không rõ'}
    - Bối cảnh: {', '.join(scene_labels[:3]) if scene_labels else 'Không xác định'}
    - Hoạt động: {', '.join(activity_labels[:3]) if activity_labels else 'Không có'}
    - Màu sắc chủ đạo: {', '.join([c['color'] for c in colors[:3]]) if colors else 'Không xác định'}
    - Văn bản: {', '.join([t['text'] for t in text[:3]]) if text else 'Không có'}
    - Người nổi tiếng: {', '.join([c['name'] for c in celebrities]) if celebrities else 'Không có'}

    👥 THÔNG TIN KHUÔN MẶT ({len(faces)} người):
    """
    
    for i, face in enumerate(faces[:2]):  # Chỉ phân tích 2 khuôn mặt đầu
        emotions = ', '.join([f"{e['type']}({e['confidence']:.1f}%)" for e in face['emotions'][:3]])
        prompt += f"""
    - Người {i+1}: {face['gender']['value']}, {face['age_range']['Low']}-{face['age_range']['High']} tuổi
      Cảm xúc: {emotions}
      Đặc điểm: {'Có nụ cười' if face['attributes']['smile'].get('Value') else 'Không cười'}, {'Đeo kính' if face['attributes']['eyeglasses'].get('Value') else 'Không kính'}
        """
    
    prompt += f"""

    📝 YÊU CẦU PHÂN TÍCH:
    Hãy viết một đoạn phân tích 4-6 câu bao gồm:
    1. Composition và bố cục tổng thể
    2. Màu sắc và ánh sáng
    3. Cảm xúc và tâm trạng được truyền tải
    4. Kỹ thuật nhiếp ảnh (góc chụp, độ sâu trường ảnh)
    5. Giá trị nghệ thuật và thẩm mỹ
    6. Gợi ý cải thiện cụ thể

    Viết bằng tiếng Việt, phong cách chuyên nghiệp nhưng dễ hiểu.
    """
    
    return prompt

def generate_comprehensive_fallback_analysis(rekognition_data):
    """Tạo phân tích dự phòng chi tiết"""
    
    labels = rekognition_data.get('labels', [])
    faces = rekognition_data.get('faces', [])
    text = rekognition_data.get('text', [])
    colors = rekognition_data.get('image_properties', {}).get('dominant_colors', [])
    
    analysis_parts = []
    
    # Phân tích composition
    if labels:
        main_subjects = [label['name'] for label in labels[:3]]
        analysis_parts.append(f"Bức ảnh có composition tập trung vào {', '.join(main_subjects).lower()}")
        
        # Phân tích theo category
        categories = {}
        for label in labels[:10]:
            for cat in label.get('categories', []):
                categories[cat] = categories.get(cat, 0) + 1
        
        dominant_category = max(categories.items(), key=lambda x: x[1])[0] if categories else None
        if dominant_category:
            analysis_parts.append(f"với chủ đề chính thuộc nhóm {dominant_category}")
    
    # Phân tích màu sắc
    if colors:
        color_names = [color['color'] for color in colors[:3]]
        analysis_parts.append(f"Tông màu chủ đạo là {', '.join(color_names).lower()}, tạo cảm giác hài hòa và cân bằng")
    
    # Phân tích khuôn mặt
    if faces:
        face_count = len(faces)
        if face_count == 1:
            face = faces[0]
            age_range = f"{face['age_range']['Low']}-{face['age_range']['High']}"
            top_emotion = face['emotions'][0]['type'] if face['emotions'] else 'CALM'
            analysis_parts.append(f"Chân dung của một {face['gender']['value'].lower()} khoảng {age_range} tuổi với cảm xúc {top_emotion.lower()}")
        else:
            analysis_parts.append(f"Ảnh nhóm với {face_count} người, thể hiện sự tương tác xã hội")
    
    # Phân tích text
    if text:
        analysis_parts.append(f"Có yếu tố văn bản '{text[0]['text']}' làm tăng tính thông tin")
    
    # Đánh giá kỹ thuật
    quality_assessment = []
    if faces:
        avg_quality = sum([face.get('quality', {}).get('Brightness', 50) for face in faces]) / len(faces)
        if avg_quality > 70:
            quality_assessment.append("chất lượng ánh sáng tốt")
        elif avg_quality < 30:
            quality_assessment.append("ánh sáng cần cải thiện")
    
    if quality_assessment:
        analysis_parts.append(f"Về mặt kỹ thuật, ảnh có {', '.join(quality_assessment)}")
    
    # Gợi ý cải thiện
    suggestions = []
    if not faces and not labels:
        suggestions.append("tăng cường độ tương phản")
    if len(colors) < 2:
        suggestions.append("cân bằng màu sắc")
    if faces and any(face.get('quality', {}).get('Brightness', 50) < 40 for face in faces):
        suggestions.append("cải thiện ánh sáng")
    
    if suggestions:
        analysis_parts.append(f"Có thể cải thiện bằng cách {', '.join(suggestions)}")
    
    # Kết hợp thành đoạn văn
    if analysis_parts:
        return '. '.join(analysis_parts) + '.'
    else:
        return "Đây là một bức ảnh có chất lượng tốt với composition cân đối và màu sắc hài hòa. Kỹ thuật chụp ổn định, thể hiện được ý tưởng của tác giả."
