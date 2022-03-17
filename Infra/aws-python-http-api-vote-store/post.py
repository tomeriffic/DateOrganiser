"""Post a Vote into storage"""
import json


def main(event, context):
    """
    Post a Vote into storage
    """
    body = {
        "message": "POST request is success",
        "input": event,
    }

    response = {"statusCode": 200, "body": json.dumps(body)}

    return response
