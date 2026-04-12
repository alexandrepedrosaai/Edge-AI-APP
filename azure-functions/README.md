# Edge AI App  -  Azure Functions

Azure Functions implementation for Edge-AI-APP project with Python 3.11 and Docker container support.

## Structure

```
azure-functions/
├── HttpTrigger/          # HTTP trigger function
├── TimerTrigger/         # Timer trigger function  
├── Dockerfile            # Optimized Docker image
├── host.json             # Global host configuration
├── requirements.txt      # Python dependencies
└── .dockerignore         # Build optimization
```

## Quick Start

### Local Development

```bash
cd azure-functions
func start
```

### Docker Build

```bash
cd azure-functions
docker build -t edge-ai-functions:latest .
docker run -p 8080:80 edge-ai-functions:latest
```

## Endpoints

**HttpTrigger**: `GET/POST /api/HttpTrigger?name=YourName`

**TimerTrigger**: Runs automatically every 5 minutes

## Sample Requests

### GET with query parameter

```bash
curl -s "http://localhost:7071/api/HttpTrigger?name=Alexandre" | jq .
```

### POST with JSON body

```bash
curl -s -X POST "http://localhost:7071/api/HttpTrigger" \
  -H "Content-Type: application/json" \
  -d '{"name": "Alexandre"}' | jq .
```

### Pass a custom request ID (optional)

The function respects the `x-ms-client-request-id` header. If not provided, a
`uuid4` is generated automatically. The value is always echoed back as
`request_id` in the JSON response, which makes end-to-end tracing easier.

```bash
curl -s "http://localhost:7071/api/HttpTrigger?name=Alexandre" \
  -H "x-ms-client-request-id: my-trace-id-123" | jq .
# → { "status": "success", "request_id": "my-trace-id-123", ... }
```

### Example success response

```json
{
  "status": "success",
  "request_id": "550e8400-e29b-41d4-a716-446655440000",
  "message": "Hello, Alexandre! Edge AI App is running.",
  "app": "Edge-AI-APP",
  "version": "1.0.0",
  "author": "Alexandre Pedrosa"
}
```

### Example error response (missing name)

```json
{
  "status": "error",
  "request_id": "550e8400-e29b-41d4-a716-446655440000",
  "message": "Please pass a name on the query string or in the request body",
  "usage": "?name=YourName or POST JSON body {\"name\": \"YourName\"}"
}
```

## Author

Alexandre Pedrosa - Edge AI App
