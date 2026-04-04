import json
import logging
import uuid
import azure.functions as func

_USAGE = '?name=YourName or POST JSON body {"name": "YourName"}'


def _request_id(req: func.HttpRequest) -> str:
    rid = req.headers.get("x-ms-client-request-id") or req.headers.get("x-request-id")
    return rid.strip() if rid else str(uuid.uuid4())


def _json_response(payload: dict, status: int) -> func.HttpResponse:
    return func.HttpResponse(
        body=json.dumps(payload, indent=2, ensure_ascii=False),
        status_code=status,
        headers={"Content-Type": "application/json; charset=utf-8"},
    )


def _get_name(req: func.HttpRequest) -> tuple:
    """Return (name, error_response_or_None).

    Precedence: query param > JSON body.
    Returns (None, None) when name is simply absent.
    Returns ("__INVALID_JSON__", None) when body is present but not valid JSON.
    """
    name = req.params.get("name")
    if name:
        return str(name), None

    try:
        body_bytes = req.get_body() or b""
        if body_bytes.strip():
            try:
                data = json.loads(body_bytes.decode("utf-8"))
            except (json.JSONDecodeError, UnicodeDecodeError):
                return "__INVALID_JSON__", None
            if isinstance(data, dict) and data.get("name"):
                return str(data["name"]), None
    except Exception:
        pass

    return None, None


def main(req: func.HttpRequest) -> func.HttpResponse:
    """
    Edge AI App - HTTP Trigger Function
    Handles HTTP requests for Edge AI processing.
    """
    rid = _request_id(req)
    try:
        logging.info("HttpTrigger start request_id=%s method=%s", rid, req.method)

        name, _ = _get_name(req)

        if name == "__INVALID_JSON__":
            return _json_response(
                {
                    "status": "error",
                    "request_id": rid,
                    "message": "Invalid JSON in request body.",
                    "usage": _USAGE,
                },
                400,
            )

        if name:
            return _json_response(
                {
                    "status": "success",
                    "request_id": rid,
                    "message": f"Hello, {name}! Edge AI App is running.",
                    "app": "Edge-AI-APP",
                    "version": "1.0.0",
                    "author": "Alexandre Pedrosa",
                },
                200,
            )

        return _json_response(
            {
                "status": "error",
                "request_id": rid,
                "message": "Please pass a name on the query string or in the request body",
                "usage": _USAGE,
            },
            400,
        )

    except Exception as exc:
        logging.exception("HttpTrigger unhandled error request_id=%s err=%s", rid, exc)
        return _json_response(
            {
                "status": "error",
                "request_id": rid,
                "message": "Internal server error.",
            },
            500,
        )
