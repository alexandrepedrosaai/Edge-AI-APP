# Azure Functions Python Docker Image
# Optimized for Edge AI App deployment

# Use official Azure Functions Python base image
FROM mcr.microsoft.com/azure-functions/python:4-python3.11

# Set environment variables
ENV AzureWebJobsScriptRoot=/home/site/wwwroot \
    AzureFunctionsJobHost__Logging__Console__IsEnabled=true \
    FUNCTIONS_WORKER_RUNTIME=python

# Copy function app files
COPY . /home/site/wwwroot

# Install Python dependencies
RUN cd /home/site/wwwroot && \
    pip install --no-cache-dir -r requirements.txt

# Expose port (Azure Functions default)
EXPOSE 80

# The base image already has the correct entrypoint
# No need to override CMD or ENTRYPOINT
