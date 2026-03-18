#!/bin/bash

#############################################################################
# Verify Azure Containers Script
# Run this script to check Container App and Function App status
#############################################################################

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Configuration
RESOURCE_GROUP="edge-ai-rg"
CONTAINER_APP_NAME="edge-ai-app"
FUNCTION_APP_NAME="edge-ai-functions"
LOCATION="eastus"

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

# Step 3: Get account info
ACCOUNT=$(az account show --query "{name: name, id: id}" -o json)
log_success "Logged in to Azure"
echo "$ACCOUNT" | jq '.'

echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║          Container App Status                             ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Step 4: Check Container App
log_info "Checking Container App: $CONTAINER_APP_NAME"

CONTAINER_STATUS=$(az containerapp show \
    --name "$CONTAINER_APP_NAME" \
    --resource-group "$RESOURCE_GROUP" \
    --query "{name: name, provisioningState: properties.provisioningState, runningStatus: properties.runningStatus, fqdn: properties.configuration.ingress.fqdn}" \
    -o json 2>/dev/null || echo "{}")

if [ "$CONTAINER_STATUS" = "{}" ]; then
    log_error "Container App not found"
else
    log_success "Container App found"
    echo ""
    echo "$CONTAINER_STATUS" | jq '.'
    
    # Extract FQDN
    FQDN=$(echo "$CONTAINER_STATUS" | jq -r '.fqdn // empty')
    if [ -n "$FQDN" ]; then
        log_success "Container App URL: https://$FQDN"
        echo ""
        
        # Try to access the app
        log_info "Testing Container App endpoint..."
        HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "https://$FQDN" 2>/dev/null || echo "000")
        
        if [ "$HTTP_CODE" = "200" ]; then
            log_success "Container App is responding (HTTP $HTTP_CODE)"
        elif [ "$HTTP_CODE" = "000" ]; then
            log_warning "Could not reach Container App (network issue)"
        else
            log_warning "Container App returned HTTP $HTTP_CODE"
        fi
    fi
fi

echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║          Function App Status                              ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Step 5: Check Function App
log_info "Checking Function App: $FUNCTION_APP_NAME"

FUNCTION_STATUS=$(az functionapp show \
    --name "$FUNCTION_APP_NAME" \
    --resource-group "$RESOURCE_GROUP" \
    --query "{name: name, state: state, defaultHostName: defaultHostName, kind: kind}" \
    -o json 2>/dev/null || echo "{}")

if [ "$FUNCTION_STATUS" = "{}" ]; then
    log_error "Function App not found"
else
    log_success "Function App found"
    echo ""
    echo "$FUNCTION_STATUS" | jq '.'
    
    # Extract hostname
    HOSTNAME=$(echo "$FUNCTION_STATUS" | jq -r '.defaultHostName // empty')
    if [ -n "$HOSTNAME" ]; then
        log_success "Function App URL: https://$HOSTNAME"
        echo ""
        
        # Try to access the app
        log_info "Testing Function App endpoint..."
        HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "https://$HOSTNAME" 2>/dev/null || echo "000")
        
        if [ "$HTTP_CODE" = "200" ] || [ "$HTTP_CODE" = "404" ]; then
            log_success "Function App is responding (HTTP $HTTP_CODE)"
        elif [ "$HTTP_CODE" = "000" ]; then
            log_warning "Could not reach Function App (network issue)"
        else
            log_warning "Function App returned HTTP $HTTP_CODE"
        fi
    fi
fi

echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║          Container Logs                                   ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Step 6: Get Container App logs
log_info "Getting Container App logs (last 20 lines)..."
echo ""

az containerapp logs show \
    --name "$CONTAINER_APP_NAME" \
    --resource-group "$RESOURCE_GROUP" \
    --tail 20 2>/dev/null || log_warning "Could not retrieve Container App logs"

echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║          Resource Group Summary                           ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Step 7: List all resources
log_info "Resources in $RESOURCE_GROUP:"
echo ""

az resource list \
    --resource-group "$RESOURCE_GROUP" \
    --query "[].{name: name, type: type, status: properties.provisioningState}" \
    -o table

echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║          Verification Complete                            ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Step 8: Summary
log_success "Verification complete!"
echo ""
echo "📋 Summary:"
echo "  Resource Group: $RESOURCE_GROUP"
echo "  Location: $LOCATION"
echo ""
echo "🔗 Links:"
echo "  Azure Portal: https://portal.azure.com"
echo "  Resource Group: https://portal.azure.com/#@/resource/subscriptions/f7fc86dd-bd9f-43a6-80a4-0bb6cab950ec/resourceGroups/$RESOURCE_GROUP/overview"
echo ""
echo "📊 Next steps:"
echo "  1. Monitor workflows: https://github.com/alexandrepedrosaai/Edge-AI-APP/actions"
echo "  2. Check Azure Portal for resource status"
echo "  3. Review Container App and Function App logs"
echo "  4. Test endpoints"
echo ""
