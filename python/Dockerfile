# Step 1: Base image
FROM python:3.12-slim

WORKDIR /app

# Copy dependency file
COPY requirements.txt ./

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy source code
COPY . .

# Expose port (se necessário para API)
EXPOSE 5000

# Startup command (ajuste conforme seu entrypoint)
CMD ["python", "main.py"]
