#!/bin/bash

#############################################################################
# Add GitHub Secrets Script
# This script adds all necessary secrets to GitHub Actions
#############################################################################

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Configuration
GITHUB_OWNER="alexandrepedrosaai"
GITHUB_REPO="Edge-AI-APP"

# Generated Values (these should be replaced with real values from Azure)
AZURE_CLIENT_ID="1a2b3c4d-5e6f-7g8h-9i0j-1k2l3m4n5o6p"
AZURE_TENANT_ID="9z8y7x6w-5v4u-3t2s-1r0q-9p8o7n6m5l4k"
AZURE_SUBSCRIPTION_ID="f7fc86dd-bd9f-43a6-80a4-0bb6cab950ec"
AZURE_RESOURCE_GROUP="edge-ai-rg"
AZURE_CONTAINER_APP_NAME="edge-ai-app"
AZURE_FUNCTION_APP_NAME="edge-ai-functions"

# Publish Profile (example - replace with real value)
AZURE_FUNCTION_PUBLISH_PROFILE="UEsDBBQABgAIAAAAIQBEAAAAAAAAAAAAAAAADwAAAC5naXRodWIvd29ya2Zsb3dzL2F6dXJlLWZ1bmN0aW9uLWFwcC55bWxVVAkAA/AAAA=="

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

# Check GitHub CLI
log_info "Checking GitHub CLI..."
if ! command -v gh &> /dev/null; then
    log_error "GitHub CLI not found. Installing..."
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
    sudo apt update
    sudo apt install gh
fi
log_success "GitHub CLI is installed"

# Check authentication
log_info "Checking GitHub authentication..."
if ! gh auth status &> /dev/null; then
    log_warning "Not authenticated with GitHub. Please login:"
    gh auth login
fi
log_success "GitHub authentication verified"

# Add secrets
log_info "Adding GitHub secrets..."

SECRETS=(
    "AZURE_CLIENT_ID:$AZURE_CLIENT_ID"
    "AZURE_TENANT_ID:$AZURE_TENANT_ID"
    "AZURE_RESOURCE_GROUP:$AZURE_RESOURCE_GROUP"
    "AZURE_CONTAINER_APP_NAME:$AZURE_CONTAINER_APP_NAME"
    "AZURE_FUNCTION_APP_NAME:$AZURE_FUNCTION_APP_NAME"
    "AZURE_FUNCTION_PUBLISH_PROFILE:$AZURE_FUNCTION_PUBLISH_PROFILE"
)

for secret in "${SECRETS[@]}"; do
    IFS=':' read -r key value <<< "$secret"
    log_info "Adding secret: $key"
    echo "$value" | gh secret set "$key" --repo "$GITHUB_OWNER/$GITHUB_REPO"
    log_success "Secret added: $key"
done

# Add variables
log_info "Adding GitHub variables..."

VARIABLES=(
    "VITE_ANALYTICS_ENDPOINT:https://analytics.example.com"
    "VITE_ANALYTICS_WEBSITE_ID:default"
    "VITE_APP_TITLE:Edge AI App"
    "VITE_APP_LOGO:/logo.svg"
    "AZURE_SUBSCRIPTION_ID:$AZURE_SUBSCRIPTION_ID"
)

for variable in "${VARIABLES[@]}"; do
    IFS=':' read -r key value <<< "$variable"
    log_info "Adding variable: $key"
    gh variable set "$key" --body "$value" --repo "$GITHUB_OWNER/$GITHUB_REPO"
    log_success "Variable added: $key"
done

# Verify secrets
log_info "Verifying secrets..."
gh secret list --repo "$GITHUB_OWNER/$GITHUB_REPO"

# Summary
echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║          GitHub Secrets Added Successfully!               ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""
log_success "All secrets and variables have been added to GitHub"
log_success "Repository: $GITHUB_OWNER/$GITHUB_REPO"
echo ""
echo "📋 Next steps:"
echo "1. Verify secrets in GitHub UI: Settings → Secrets and variables → Actions"
echo "2. Run workflows: gh workflow run build-and-test.yml --ref main"
echo "3. Monitor: https://github.com/$GITHUB_OWNER/$GITHUB_REPO/actions"
echo ""
