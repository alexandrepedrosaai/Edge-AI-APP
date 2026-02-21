# Edge AI App - Azure Functions

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

## Author

Alexandre Pedrosa - Edge AI App
