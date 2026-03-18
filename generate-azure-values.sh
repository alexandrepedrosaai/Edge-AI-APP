#!/bin/bash

#############################################################################
# Generate Azure Values Script
# Run this script locally on your machine to generate Azure credentials
# Then use the output to add secrets to GitHub
#############################################################################

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Configuration
SUBSCRIPTION_ID="f7fc86dd-bd9f-43a6-80a4-0bb6cab950ec"
RESOURCE_GROUP="edge-ai-rg"
LOCATION="eastus"
SERVICE_PRINCIPAL_NAME="github-edge-ai-app"
CONTAINER_APP_ENV="edge-ai-env"
CONTAINER_APP_NAME="edge-ai-app"
FUNCTION_APP_NAME="edge-ai-functions"
STORAGE_ACCOUNT_NAME="edgaistorageacct"
GITHUB_OWNER="alexandrepedrosaai"
GITHUB_REPO="Edge-AI-APP"

# Functions
log_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

log_success() {
    echo -e "${GREEN}✓${NC} $1"
}

log_error() {
    echo -e "${RED}✗${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

# Step 1: Check Azure CLI
log_info "Checking Azure CLI..."
if ! command -v az &> /dev/null; then
    log_error "Azure CLI not found. Please install it first."
    echo "Visit: https://learn.microsoft.com/en-us/cli/azure/install-azure-cli"
    exit 1
fi
log_success "Azure CLI is installed"

# Step 2: Check authentication
log_info "Checking Azure authentication..."
if ! az account show &> /dev/null; then
    log_error "Not authenticated with Azure. Please run: az login"
    exit 1
fi
log_success "Azure authentication verified"

# Step 3: Set subscription
log_info "Setting subscription..."
az account set --subscription "$SUBSCRIPTION_ID"
log_success "Subscription set"

# Step 4: Create Resource Group
log_info "Creating Resource Group..."
if az group exists --name "$RESOURCE_GROUP" | grep -q true; then
    log_warning "Resource Group already exists"
else
    az group create \
        --name "$RESOURCE_GROUP" \
        --location "$LOCATION"
    log_success "Resource Group created"
fi

# Step 5: Create Service Principal
log_info "Creating Service Principal..."
SP_OUTPUT=$(az ad sp create-for-rbac \
    --name "$SERVICE_PRINCIPAL_NAME" \
    --role contributor \
    --scopes "/subscriptions/$SUBSCRIPTION_ID" \
    --json-auth 2>/dev/null || echo "{}")

if [ "$SP_OUTPUT" = "{}" ]; then
    log_warning "Service Principal might already exist"
    CLIENT_ID=$(az ad sp list --display-name "$SERVICE_PRINCIPAL_NAME" --query "[0].appId" -o tsv)
    TENANT_ID=$(az account show --query tenantId -o tsv)
else
    CLIENT_ID=$(echo "$SP_OUTPUT" | jq -r '.clientId')
    TENANT_ID=$(echo "$SP_OUTPUT" | jq -r '.tenantId')
fi

log_success "Service Principal created/retrieved"

# Step 6: Create Managed Identity
log_info "Creating Managed Identity..."
if az identity show \
    --name "$SERVICE_PRINCIPAL_NAME" \
    --resource-group "$RESOURCE_GROUP" &>/dev/null; then
    log_warning "Managed Identity already exists"
else
    az identity create \
        --name "$SERVICE_PRINCIPAL_NAME" \
        --resource-group "$RESOURCE_GROUP"
    log_success "Managed Identity created"
fi

# Step 7: Create Federated Credential
log_info "Creating Federated Identity Credential..."
CRED_NAME="github-${GITHUB_REPO}-main"
az identity federated-credential create \
    --name "$CRED_NAME" \
    --identity-name "$SERVICE_PRINCIPAL_NAME" \
    --resource-group "$RESOURCE_GROUP" \
    --issuer "https://token.actions.githubusercontent.com" \
    --subject "repo:${GITHUB_OWNER}/${GITHUB_REPO}:ref:refs/heads/main" \
    --audiences "api://AzureADTokenExchange" 2>/dev/null || log_warning "Federated credential might already exist"
log_success "Federated Identity Credential configured"

# Step 8: Create Container App Environment
log_info "Creating Container App Environment..."
if az containerapp env show \
    --name "$CONTAINER_APP_ENV" \
    --resource-group "$RESOURCE_GROUP" &>/dev/null; then
    log_warning "Container App Environment already exists"
else
    az containerapp env create \
        --name "$CONTAINER_APP_ENV" \
        --resource-group "$RESOURCE_GROUP" \
        --location "$LOCATION"
    log_success "Container App Environment created"
fi

# Step 9: Create Container App
log_info "Creating Container App..."
if az containerapp show \
    --name "$CONTAINER_APP_NAME" \
    --resource-group "$RESOURCE_GROUP" &>/dev/null; then
    log_warning "Container App already exists"
else
    az containerapp create \
        --name "$CONTAINER_APP_NAME" \
        --resource-group "$RESOURCE_GROUP" \
        --environment "$CONTAINER_APP_ENV" \
        --image "ghcr.io/${GITHUB_OWNER}/Edge-AI-APP:latest" \
        --target-port 3000 \
        --ingress external \
        --cpu 0.5 \
        --memory 1Gi \
        --min-replicas 1 \
        --max-replicas 5 \
        --env-vars \
            VITE_ANALYTICS_ENDPOINT="https://analytics.example.com" \
            VITE_ANALYTICS_WEBSITE_ID="default" \
            VITE_APP_TITLE="Edge AI App" \
            VITE_APP_LOGO="/logo.svg"
    log_success "Container App created"
fi

# Get Container App FQDN
CONTAINER_APP_FQDN=$(az containerapp show \
    --name "$CONTAINER_APP_NAME" \
    --resource-group "$RESOURCE_GROUP" \
    --query "properties.configuration.ingress.fqdn" -o tsv)

# Step 10: Create Storage Account
log_info "Creating Storage Account..."
if az storage account show \
    --name "$STORAGE_ACCOUNT_NAME" \
    --resource-group "$RESOURCE_GROUP" &>/dev/null; then
    log_warning "Storage Account already exists"
else
    az storage account create \
        --name "$STORAGE_ACCOUNT_NAME" \
        --resource-group "$RESOURCE_GROUP" \
        --location "$LOCATION" \
        --sku Standard_LRS
    log_success "Storage Account created"
fi

# Step 11: Create Function App
log_info "Creating Function App..."
if az functionapp show \
    --name "$FUNCTION_APP_NAME" \
    --resource-group "$RESOURCE_GROUP" &>/dev/null; then
    log_warning "Function App already exists"
else
    az functionapp create \
        --resource-group "$RESOURCE_GROUP" \
        --consumption-plan-location "$LOCATION" \
        --runtime node \
        --runtime-version 20 \
        --functions-version 4 \
        --name "$FUNCTION_APP_NAME" \
        --storage-account "$STORAGE_ACCOUNT_NAME"
    log_success "Function App created"
fi

# Get Function App hostname
FUNCTION_APP_HOSTNAME=$(az functionapp show \
    --name "$FUNCTION_APP_NAME" \
    --resource-group "$RESOURCE_GROUP" \
    --query "defaultHostName" -o tsv)

# Step 12: Get Publish Profile
log_info "Getting Function App Publish Profile..."
PUBLISH_PROFILE=$(az functionapp deployment list-publishing-profiles \
    --name "$FUNCTION_APP_NAME" \
    --resource-group "$RESOURCE_GROUP" \
    --xml | base64 -w 0)
log_success "Publish Profile retrieved"

# Step 13: Configure Function App settings
log_info "Configuring Function App settings..."
az functionapp config appsettings set \
    --name "$FUNCTION_APP_NAME" \
    --resource-group "$RESOURCE_GROUP" \
    --settings \
        VITE_ANALYTICS_ENDPOINT="https://analytics.example.com" \
        VITE_ANALYTICS_WEBSITE_ID="default" \
        VITE_APP_TITLE="Edge AI App" \
        VITE_APP_LOGO="/logo.svg" \
        ENABLE_MSAL_LOGGING="false" \
        ASPNETCORE_ENVIRONMENT="Production"
log_success "Function App settings configured"

# Step 14: Generate output file
log_info "Generating output file..."
cat > azure-values.env << EOF
# Azure Configuration Values
# Generated on: $(date)

# OIDC Credentials
AZURE_CLIENT_ID=$CLIENT_ID
AZURE_TENANT_ID=$TENANT_ID
AZURE_SUBSCRIPTION_ID=$SUBSCRIPTION_ID

# Azure Resources
AZURE_RESOURCE_GROUP=$RESOURCE_GROUP
AZURE_CONTAINER_APP_NAME=$CONTAINER_APP_NAME
AZURE_FUNCTION_APP_NAME=$FUNCTION_APP_NAME

# Publish Profile (base64 encoded)
AZURE_FUNCTION_PUBLISH_PROFILE=$PUBLISH_PROFILE

# URLs
CONTAINER_APP_URL=https://$CONTAINER_APP_FQDN
FUNCTION_APP_URL=https://$FUNCTION_APP_HOSTNAME
EOF

log_success "Output file created: azure-values.env"

# Step 15: Display summary
echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║          Azure Setup Completed Successfully!              ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""
log_success "All Azure resources created/verified"
echo ""
echo "📋 Summary:"
echo "  Client ID: $CLIENT_ID"
echo "  Tenant ID: $TENANT_ID"
echo "  Resource Group: $RESOURCE_GROUP"
echo "  Container App: https://$CONTAINER_APP_FQDN"
echo "  Function App: https://$FUNCTION_APP_HOSTNAME"
echo ""
echo "📝 Next steps:"
echo "  1. Copy the values from azure-values.env"
echo "  2. Add them as GitHub secrets:"
echo ""
echo "     gh secret set AZURE_CLIENT_ID --body \"$CLIENT_ID\""
echo "     gh secret set AZURE_TENANT_ID --body \"$TENANT_ID\""
echo "     gh secret set AZURE_RESOURCE_GROUP --body \"$RESOURCE_GROUP\""
echo "     gh secret set AZURE_CONTAINER_APP_NAME --body \"$CONTAINER_APP_NAME\""
echo "     gh secret set AZURE_FUNCTION_APP_NAME --body \"$FUNCTION_APP_NAME\""
echo "     gh secret set AZURE_FUNCTION_PUBLISH_PROFILE --body \"\$(cat azure-values.env | grep AZURE_FUNCTION_PUBLISH_PROFILE | cut -d'=' -f2)\""
echo ""
echo "  3. Test workflows:"
echo ""
echo "     gh workflow run build-and-test.yml --ref main"
echo "     gh workflow run azure-container-app.yml --ref main"
echo ""
