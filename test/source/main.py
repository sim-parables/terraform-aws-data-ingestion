""" AWS Lambda Function Example

This AWS Lambda function is designed to be triggered by an HTTP request via API Gateway. 
When invoked, it expects a POST request containing a file in the request body and a 
filename specified in either the query string or headers. The function writes the 
received file to an S3 bucket specified by the environment variable TARGET_BUCKET.

This enables direct file uploads to S3 via HTTP, allowing integration with web clients 
or other HTTP-based workflows.

"""

import logging
import base64
import s3fs
import json
import sys
import os

# Environment Variables
TARGET_BUCKET = os.getenv('TARGET_BUCKET')


# Setup
logging.basicConfig(stream=sys.stdout, level=logging.INFO)

def extract_file_from_event(event):
    """
    Extracts the file name and file content from the Lambda event.
    Parameters:
        event (dict): The Lambda event payload. Expected to contain:
    
    Raises ValueError if either file name or file content is missing.
    Returns:
        tuple: (filename, file_content)
    """
    
    # Get file content
    is_base64 = event.get('isBase64Encoded', False)
    body = event.get('body', '')
    if not body:
        raise ValueError('File content not provided in request body')
    if is_base64:
        file_content = base64.b64decode(body)
    else:
        file_content = body.encode('utf-8')
    
    # Get filename
    filename = None
    if event.get('queryStringParameters') and event['queryStringParameters'].get('filename'):
        filename = event['queryStringParameters']['filename']
    elif event.get('headers') and event['headers'].get('filename'):
        filename = event['headers']['filename']
    if not filename:
        raise ValueError('Filename not provided in request')
    
    return filename, file_content


def http_handler(event, context):
    """
    AWS Lambda handler for HTTP file upload via API Gateway.

    This function expects to be triggered by an HTTP POST request through API Gateway. The request must include:
      - The file content in the request body (may be base64-encoded, as indicated by the 'isBase64Encoded' field).
      - The filename, provided either as a 'filename' key in the query string parameters or in the HTTP headers.

    Parameters:
        event (dict): The Lambda event payload. Expected keys:
            - 'body': The file content (string, possibly base64-encoded).
            - 'isBase64Encoded': Boolean indicating if the body is base64-encoded.
            - 'queryStringParameters': (optional) Dict with 'filename' key.
            - 'headers': (optional) Dict with 'filename' key.
        context (LambdaContext): Lambda context object (not used).

    Returns:
        dict: API Gateway-compatible response with statusCode and body.
    """
    try:
        filename, file_content = extract_file_from_event(event)
    except ValueError as e:
        return {
            'statusCode': 400,
            'body': json.dumps({'error': str(e)})
        }
    
    # Upload to S3
    s3_path = f's3://{TARGET_BUCKET}/{filename}'
    fs = s3fs.S3FileSystem()
    with fs.open(s3_path, 'wb') as f:
        f.write(file_content)
    
    return {
        'statusCode': 200,
        'body': json.dumps({'message': f'File {filename} uploaded to {TARGET_BUCKET}'})
    }
