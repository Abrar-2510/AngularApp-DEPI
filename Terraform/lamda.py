



##This code defines a Lambda function that sends an email notification when triggered ( when the state file change in s3)

import json
import boto3
from botocore.exceptions import ClientError

def lambda_handler(event, context):
    # ===========================
    # Start of Lambda Function
    # ===========================
    print(" Event Received ")
    print(json.dumps(event, indent=2))  # Pretty print the event for better readability

    ses_client = boto3.client('sesv2')

    # ===========================
    # Begin Email Sending Process
    # ===========================
    print(" Initiating Email Sending ")

    try:
        email_response = ses_client.send_email(
            FromEmailAddress='abrarbero2510.dev@gmail.com',
            Destination={
                'ToAddresses': [
                    'abrarbero2510@gmail.com',
                ],
            },
            Content={
                'Simple': {
                    'Subject': {
                        'Data': 'Terraform State Update Notification',
                        'Charset': 'UTF-8'
                    },
                    'Body': {
                        'Text': {
                            'Data': 'The Terraform state file has been modified.',
                            'Charset': 'UTF-8'
                        },
                    }
                },
            },
        )

        # ===========================
        # Email Response Logging
        # ===========================
        print(" Email Sent Successfully ")
        print(json.dumps(email_response, indent=2))  # Pretty print the response

    except ClientError as error:
        # ===========================
        # Error Handling for Email Sending
        # ===========================
        print(f" Error Sending Email ")
        print(f"Error Message: {error.response['Error']['Message']}")

    # ===========================
    # End of Lambda Function
    # ===========================
    return {
        'statusCode': 200,
        'body': json.dumps('Upload completed successfully.')
    }
