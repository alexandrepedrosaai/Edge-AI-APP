import logging
import json
import azure.functions as func


def main(req: func.HttpRequest) -> func.HttpResponse:
    """
    Edge AI App - HTTP Trigger Function
    Handles HTTP requests for Edge AI processing
    """
    logging.info('Edge AI App HTTP trigger function processed a request.')

    # Get parameters from query string or request body
    name = req.params.get('name')
    if not name:
        try:
            req_body = req.get_json()
        except ValueError:
            req_body = None
        
        if req_body:
            name = req_body.get('name')

    # Process the request
    if name:
        response_data = {
            "status": "success",
            "message": f"Hello, {name}! Edge AI App is running.",
            "app": "Edge-AI-APP",
            "version": "1.0.0",
            "author": "Alexandre Pedrosa"
        }
        return func.HttpResponse(
            json.dumps(response_data, indent=2),
            mimetype="application/json",
            status_code=200
        )
    else:
        response_data = {
            "status": "error",
            "message": "Please pass a name on the query string or in the request body",
            "usage": "?name=YourName or POST with JSON body {\"name\": \"YourName\"}"
        }
        return func.HttpResponse(
            json.dumps(response_data, indent=2),
            mimetype="application/json",
            status_code=400
        )
