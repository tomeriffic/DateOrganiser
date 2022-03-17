"""Get a list of Votes for a specific event"""
import json


def main(event, context):
    """
    Get a list of Votes for a specific event
    """
    body = {
        "message": "GET Request is success",
        "input": event,
    }

    response = {"statusCode": 200, "body": json.dumps(body)}

    return response
