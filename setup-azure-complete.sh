#!/bin/bash

#############################################################################
# Complete Azure Setup Script for Edge AI App
# This script sets up:
# - Service Principal with OIDC
# - Federated Identity Credential
# - Resource Group
# - Container App Environment
# - Container App
# - Storage Account
# - Function App
# - Publish Profile
# - GitHub Secrets
#############################################################################

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

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
    log_error "Azure CLI not found. Installing..."
    curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
fi
log_success "Azure CLI is installed"

# Step 2: Set subscription
log_info "Setting subscription..."
az account set --subscription "$SUBSCRIPTION_ID"
log_success "Subscription set to $SUBSCRIPTION_ID"

# Step 3: Create Resource Group
log_info "Creating Resource Group..."
if az group exists --name "$RESOURCE_GROUP" | grep -q true; then
    log_warning "Resource Group $RESOURCE_GROUP already exists"
else
    az group create \
        --name "$RESOURCE_GROUP" \
        --location "$LOCATION"
    log_success "Resource Group created: $RESOURCE_GROUP"
fi

# Step 4: Create Service Principal
log_info "Creating Service Principal..."
SP_JSON=$(az ad sp create-for-rbac \
    --name "$SERVICE_PRINCIPAL_NAME" \
    --role contributor \
    --scopes "/subscriptions/$SUBSCRIPTION_ID" \
    --json-auth 2>/dev/null || echo "{}")

if [ "$SP_JSON" = "{}" ]; then
    log_warning "Service Principal might already exist, fetching details..."
    SP_ID=$(az ad sp list --display-name "$SERVICE_PRINCIPAL_NAME" --query "[0].id" -o tsv)
    CLIENT_ID=$(az ad sp list --display-name "$SERVICE_PRINCIPAL_NAME" --query "[0].appId" -o tsv)
    TENANT_ID=$(az account show --query tenantId -o tsv)
else
    CLIENT_ID=$(echo "$SP_JSON" | jq -r '.clientId')
    TENANT_ID=$(echo "$SP_JSON" | jq -r '.tenantId')
    SP_ID=$(az ad sp list --display-name "$SERVICE_PRINCIPAL_NAME" --query "[0].id" -o tsv)
fi

log_success "Service Principal created/retrieved"
log_info "CLIENT_ID: $CLIENT_ID"
log_info "TENANT_ID: $TENANT_ID"

# Step 5: Create Federated Identity Credential
log_info "Creating Federated Identity Credential..."

# Get managed identity
IDENTITY_ID=$(az identity show \
    --name "$SERVICE_PRINCIPAL_NAME" \
    --resource-group "$RESOURCE_GROUP" \
    --query id -o tsv 2>/dev/null || echo "")

if [ -z "$IDENTITY_ID" ]; then
    log_info "Creating managed identity..."
    az identity create \
        --name "$SERVICE_PRINCIPAL_NAME" \
        --resource-group "$RESOURCE_GROUP"
    IDENTITY_ID=$(az identity show \
        --name "$SERVICE_PRINCIPAL_NAME" \
        --resource-group "$RESOURCE_GROUP" \
        --query id -o tsv)
fi

# Create federated credential
CRED_NAME="github-${GITHUB_REPO}-main"
az identity federated-credential create \
    --name "$CRED_NAME" \
    --identity-name "$SERVICE_PRINCIPAL_NAME" \
    --resource-group "$RESOURCE_GROUP" \
    --issuer "https://token.actions.githubusercontent.com" \
    --subject "repo:${GITHUB_OWNER}/${GITHUB_REPO}:ref:refs/heads/main" \
    --audiences "api://AzureADTokenExchange" 2>/dev/null || log_warning "Federated credential might already exist"

log_success "Federated Identity Credential configured"

# Step 6: Create Container App Environment
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

# Step 7: Create Container App
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
log_success "Container App FQDN: $CONTAINER_APP_FQDN"

# Step 8: Create Storage Account
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

# Step 9: Create Function App
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
log_success "Function App hostname: $FUNCTION_APP_HOSTNAME"

# Step 10: Get Publish Profile
log_info "Getting Function App Publish Profile..."
PUBLISH_PROFILE=$(az functionapp deployment list-publishing-profiles \
    --name "$FUNCTION_APP_NAME" \
    --resource-group "$RESOURCE_GROUP" \
    --xml 2>/dev/null | base64 -w 0)
log_success "Publish Profile retrieved"

# Step 11: Configure Function App settings
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

# Step 12: Create GitHub Secrets file
log_info "Creating GitHub Secrets configuration..."
cat > /tmp/github-secrets.env << EOF
AZURE_CLIENT_ID=$CLIENT_ID
AZURE_TENANT_ID=$TENANT_ID
AZURE_RESOURCE_GROUP=$RESOURCE_GROUP
AZURE_CONTAINER_APP_NAME=$CONTAINER_APP_NAME
AZURE_FUNCTION_APP_NAME=$FUNCTION_APP_NAME
AZURE_FUNCTION_PUBLISH_PROFILE=$PUBLISH_PROFILE
EOF

log_success "GitHub Secrets configuration created"

# Step 13: Add GitHub Secrets
log_info "Adding secrets to GitHub..."
if command -v gh &> /dev/null; then
    while IFS='=' read -r key value; do
        if [ -n "$key" ] && [ -n "$value" ]; then
            gh secret set "$key" --body "$value" --repo "$GITHUB_OWNER/$GITHUB_REPO" 2>/dev/null || log_warning "Could not set secret $key (might require authentication)"
        fi
    done < /tmp/github-secrets.env
    log_success "GitHub secrets added"
else
    log_warning "GitHub CLI not found. Please add secrets manually:"
    cat /tmp/github-secrets.env
fi

# Step 14: Create summary report
log_info "Creating summary report..."
cat > /tmp/azure-setup-summary.md << EOF
# Azure Setup Summary

## ✅ Resources Created

### Service Principal
- **Name**: $SERVICE_PRINCIPAL_NAME
- **Client ID**: $CLIENT_ID
- **Tenant ID**: $TENANT_ID

### Resource Group
- **Name**: $RESOURCE_GROUP
- **Location**: $LOCATION

### Container App
- **Name**: $CONTAINER_APP_NAME
- **Environment**: $CONTAINER_APP_ENV
- **FQDN**: $CONTAINER_APP_FQDN
- **URL**: https://$CONTAINER_APP_FQDN

### Function App
- **Name**: $FUNCTION_APP_NAME
- **Hostname**: $FUNCTION_APP_HOSTNAME
- **URL**: https://$FUNCTION_APP_HOSTNAME

### Storage Account
- **Name**: $STORAGE_ACCOUNT_NAME

## 📋 GitHub Secrets Added

\`\`\`
AZURE_CLIENT_ID=$CLIENT_ID
AZURE_TENANT_ID=$TENANT_ID
AZURE_RESOURCE_GROUP=$RESOURCE_GROUP
AZURE_CONTAINER_APP_NAME=$CONTAINER_APP_NAME
AZURE_FUNCTION_APP_NAME=$FUNCTION_APP_NAME
AZURE_FUNCTION_PUBLISH_PROFILE=<base64_encoded>
\`\`\`

## 🔗 Important Links

- **Container App**: https://$CONTAINER_APP_FQDN
- **Function App**: https://$FUNCTION_APP_HOSTNAME
- **Azure Portal**: https://portal.azure.com
- **GitHub Actions**: https://github.com/$GITHUB_OWNER/$GITHUB_REPO/actions

## 📝 Next Steps

1. ✅ Verify Container App is running
2. ✅ Verify Function App is running
3. ✅ Test GitHub Actions workflows
4. ✅ Monitor deployments

## 🆘 Troubleshooting

If you encounter issues:

1. Check Azure Portal for resource status
2. Review GitHub Actions logs
3. Verify secrets are correctly set
4. Check Container App and Function App logs

EOF

log_success "Summary report created"

# Final output
echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║          Azure Setup Completed Successfully!              ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""
log_success "Container App URL: https://$CONTAINER_APP_FQDN"
log_success "Function App URL: https://$FUNCTION_APP_HOSTNAME"
log_success "Summary saved to: /tmp/azure-setup-summary.md"
log_success "Secrets saved to: /tmp/github-secrets.env"
echo ""
echo "📋 Summary Report:"
cat /tmp/azure-setup-summary.md
echo ""
echo -e "${YELLOW}⚠ IMPORTANT: Save the secrets from /tmp/github-secrets.env${NC}"
echo ""
