# Edge AI App - Azure Deployment Guide

Complete guide for deploying Edge AI App to Azure using Docker containers.

## Architecture

1. **Azure Web App** - Main multi-language application
2. **Azure Functions** - Serverless Python functions

## Prerequisites

- Azure account
- Azure CLI installed
- Docker installed
- GitHub repository access

## Quick Deploy - Azure Functions

### 1. Create Azure Resources

```bash
# Variables
RESOURCE_GROUP="edge-ai-rg"
LOCATION="brazilsouth"
ACR_NAME="edgeaiacr"
FUNCTION_APP_NAME="edge-ai-functions"
STORAGE_ACCOUNT="edgeaifuncstorage"

# Create resource group
az group create --name $RESOURCE_GROUP --location $LOCATION

# Create Azure Container Registry
az acr create --resource-group $RESOURCE_GROUP \
  --name $ACR_NAME --sku Basic --admin-enabled true

# Create storage account
az storage account create --name $STORAGE_ACCOUNT \
  --location $LOCATION --resource-group $RESOURCE_GROUP \
  --sku Standard_LRS

# Create App Service Plan
az appservice plan create --name edge-ai-plan \
  --resource-group $RESOURCE_GROUP --is-linux --sku B1

# Create Function App
az functionapp create --name $FUNCTION_APP_NAME \
  --storage-account $STORAGE_ACCOUNT \
  --resource-group $RESOURCE_GROUP \
  --plan edge-ai-plan \
  --deployment-container-image-name $ACR_NAME.azurecr.io/edge-ai-functions:latest \
  --functions-version 4 --runtime python --runtime-version 3.11
```

### 2. Build and Push Docker Image

```bash
cd azure-functions

# Login to ACR
az acr login --name $ACR_NAME

# Build image
docker build -t $ACR_NAME.azurecr.io/edge-ai-functions:latest .

# Push to ACR
docker push $ACR_NAME.azurecr.io/edge-ai-functions:latest
```

### 3. Configure Function App

```bash
# Get ACR credentials
ACR_USERNAME=$(az acr credential show --name $ACR_NAME --query username -o tsv)
ACR_PASSWORD=$(az acr credential show --name $ACR_NAME --query passwords[0].value -o tsv)

# Configure container
az functionapp config container set \
  --name $FUNCTION_APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --docker-custom-image-name $ACR_NAME.azurecr.io/edge-ai-functions:latest \
  --docker-registry-server-url https://$ACR_NAME.azurecr.io \
  --docker-registry-server-user $ACR_USERNAME \
  --docker-registry-server-password $ACR_PASSWORD
```

### 4. Test Deployment

```bash
# Get function URL
FUNCTION_URL=$(az functionapp function show \
  --name $FUNCTION_APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --function-name HttpTrigger \
  --query invokeUrlTemplate -o tsv)

# Test
curl "$FUNCTION_URL?name=Alexandre"
```

## GitHub Actions Setup

### Required Secrets

Add these secrets to your GitHub repository (Settings > Secrets and variables > Actions):

1. **AZURE_CREDENTIALS**
```bash
az ad sp create-for-rbac --name "edge-ai-sp" \
  --role contributor \
  --scopes /subscriptions/{SUBSCRIPTION_ID}/resourceGroups/$RESOURCE_GROUP \
  --sdk-auth
```

2. **AZURE_ACR_NAME**: `edgeaiacr`

3. **AZURE_ACR_USERNAME**: From `az acr credential show`

4. **AZURE_ACR_PASSWORD**: From `az acr credential show`

### Workflows

The repository includes GitHub Actions workflows for automated deployment:

- `azure-functions-deploy.yml` - Deploy Azure Functions
- `ci-azure-docker.yml` - Deploy Azure Web App
- `blank.yml` - CI/CD tests

**Note**: Due to GitHub App permissions, workflows must be added manually via GitHub UI.

## Monitoring

### View Logs

```bash
# Function App logs
az functionapp log tail --name $FUNCTION_APP_NAME \
  --resource-group $RESOURCE_GROUP

# Web App logs  
az webapp log tail --name edge-ai-app \
  --resource-group $RESOURCE_GROUP
```

### Application Insights

```bash
# Create Application Insights
az monitor app-insights component create \
  --app edge-ai-insights \
  --location $LOCATION \
  --resource-group $RESOURCE_GROUP

# Get instrumentation key
INSTRUMENTATION_KEY=$(az monitor app-insights component show \
  --app edge-ai-insights \
  --resource-group $RESOURCE_GROUP \
  --query instrumentationKey -o tsv)

# Configure Function App
az functionapp config appsettings set \
  --name $FUNCTION_APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --settings APPINSIGHTS_INSTRUMENTATIONKEY=$INSTRUMENTATION_KEY
```

## Troubleshooting

### Check Deployment Status

```bash
az functionapp show --name $FUNCTION_APP_NAME \
  --resource-group $RESOURCE_GROUP --query state
```

### Restart Function App

```bash
az functionapp restart --name $FUNCTION_APP_NAME \
  --resource-group $RESOURCE_GROUP
```

### Update Container Image

```bash
az functionapp config container set \
  --name $FUNCTION_APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --docker-custom-image-name $ACR_NAME.azurecr.io/edge-ai-functions:latest
```

## Security Best Practices

1. Use Azure Key Vault for secrets
2. Enable managed identity
3. Configure CORS properly
4. Use function-level authorization
5. Enable HTTPS only

## Resources

- [Azure Functions Documentation](https://docs.microsoft.com/azure/azure-functions/)
- [Azure Container Registry](https://docs.microsoft.com/azure/container-registry/)
- [GitHub Actions for Azure](https://github.com/Azure/actions)

## Author

**Alexandre Pedrosa**  
Edge AI App - Symbiotic Intelligence Architecture

Co-authored-by: Manus AI  
Guided by the MANUS principle: Many languages, unified system
