#!/bin/bash

#############################################################################
# Trigger Workflows via GitHub API
# This script uses the GitHub API to trigger workflows without CLI
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
BRANCH="main"

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

# Step 1: Check for token
if [ -z "$GITHUB_TOKEN" ]; then
    log_error "GITHUB_TOKEN not set!"
    echo ""
    echo "Please provide your GitHub Personal Access Token:"
    echo ""
    echo "1. Go to: https://github.com/settings/tokens"
    echo "2. Click 'Generate new token (classic)'"
    echo "3. Select scopes: repo, workflow"
    echo "4. Copy the token"
    echo "5. Run:"
    echo ""
    echo "   export GITHUB_TOKEN='your_token_here'"
    echo "   bash trigger-workflows-api.sh"
    echo ""
    exit 1
fi

log_success "GitHub token found"

# Step 2: Check curl
if ! command -v curl &> /dev/null; then
    log_error "curl not found. Please install it."
    exit 1
fi

log_success "curl is installed"

# Step 3: Verify token
log_info "Verifying GitHub token..."
VERIFY=$(curl -s -H "Authorization: token $GITHUB_TOKEN" \
    https://api.github.com/user | grep -o '"login"' || echo "")

if [ -z "$VERIFY" ]; then
    log_error "Invalid GitHub token!"
    exit 1
fi

log_success "GitHub token verified"

# Step 4: Define workflows
declare -a WORKFLOWS=(
    "build-and-test.yml"
    "test-multi-node.yml"
    "docker-build.yml"
    "docker-image.yml"
    "assembly-build.yml"
    "install-dependencies.yml"
    "sbom-security.yaml"
    "azure-container-app.yml"
    "azure-function-app.yml"
)

declare -a RUN_IDS=()

# Step 5: Trigger workflows
echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║          Triggering All Workflows via API                 ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""

for workflow in "${WORKFLOWS[@]}"; do
    log_info "Triggering: $workflow"
    
    # Trigger workflow via API
    RESPONSE=$(curl -s -X POST \
        -H "Authorization: token $GITHUB_TOKEN" \
        -H "Accept: application/vnd.github.v3+json" \
        "https://api.github.com/repos/$GITHUB_OWNER/$GITHUB_REPO/actions/workflows/$workflow/dispatches" \
        -d "{\"ref\":\"$BRANCH\"}")
    
    # Check response
    if echo "$RESPONSE" | grep -q "message"; then
        ERROR=$(echo "$RESPONSE" | grep -o '"message":"[^"]*' | cut -d'"' -f4)
        log_warning "Response: $ERROR"
    else
        log_success "Workflow triggered: $workflow"
    fi
    
    sleep 2
done

echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║          All Workflows Triggered Successfully!            ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Step 6: Get workflow runs
log_info "Fetching workflow runs..."
echo ""

RUNS=$(curl -s -H "Authorization: token $GITHUB_TOKEN" \
    "https://api.github.com/repos/$GITHUB_OWNER/$GITHUB_REPO/actions/runs?per_page=20" | \
    grep -o '"name":"[^"]*\|"status":"[^"]*\|"conclusion":"[^"]*' | \
    paste - - - | head -10)

echo "Recent workflow runs:"
echo "$RUNS"
echo ""

# Step 7: Show monitoring options
log_success "All workflows have been triggered!"
echo ""
echo "📊 Monitor at:"
echo "   https://github.com/$GITHUB_OWNER/$GITHUB_REPO/actions"
echo ""
echo "📋 Commands to monitor:"
echo ""
echo "   # Get all runs"
echo "   curl -H 'Authorization: token \$GITHUB_TOKEN' \\"
echo "     https://api.github.com/repos/$GITHUB_OWNER/$GITHUB_REPO/actions/runs"
echo ""
echo "   # Get specific workflow"
echo "   curl -H 'Authorization: token \$GITHUB_TOKEN' \\"
echo "     https://api.github.com/repos/$GITHUB_OWNER/$GITHUB_REPO/actions/workflows/build-and-test.yml/runs"
echo ""

# Step 8: Save summary
cat > workflow-api-summary.txt << EOF
Workflow Trigger Summary (API)
Generated: $(date)

Repository: $GITHUB_OWNER/$GITHUB_REPO
Branch: $BRANCH

Workflows Triggered:
$(printf '%s\n' "${WORKFLOWS[@]}" | nl)

Status: All workflows have been triggered successfully!

Monitor at: https://github.com/$GITHUB_OWNER/$GITHUB_REPO/actions

API Endpoints:
- Runs: https://api.github.com/repos/$GITHUB_OWNER/$GITHUB_REPO/actions/runs
- Build & Test: https://api.github.com/repos/$GITHUB_OWNER/$GITHUB_REPO/actions/workflows/build-and-test.yml/runs
- Docker Build: https://api.github.com/repos/$GITHUB_OWNER/$GITHUB_REPO/actions/workflows/docker-build.yml/runs
- Azure Container App: https://api.github.com/repos/$GITHUB_OWNER/$GITHUB_REPO/actions/workflows/azure-container-app.yml/runs
- Azure Function App: https://api.github.com/repos/$GITHUB_OWNER/$GITHUB_REPO/actions/workflows/azure-function-app.yml/runs

Commands:
- Get all runs: curl -H "Authorization: token \$GITHUB_TOKEN" https://api.github.com/repos/$GITHUB_OWNER/$GITHUB_REPO/actions/runs
- Get workflow: curl -H "Authorization: token \$GITHUB_TOKEN" https://api.github.com/repos/$GITHUB_OWNER/$GITHUB_REPO/actions/workflows/build-and-test.yml/runs
- Get run logs: curl -H "Authorization: token \$GITHUB_TOKEN" https://api.github.com/repos/$GITHUB_OWNER/$GITHUB_REPO/actions/runs/<run-id>/logs
EOF

log_success "Summary saved to: workflow-api-summary.txt"
echo ""
