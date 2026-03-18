#!/bin/bash

#############################################################################
# Run All Workflows Script
# Execute this script to trigger all GitHub Actions workflows
# and monitor their progress in real-time
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

# Step 1: Check GitHub CLI
log_info "Checking GitHub CLI..."
if ! command -v gh &> /dev/null; then
    log_error "GitHub CLI not found. Please install it first."
    echo "Visit: https://cli.github.com"
    exit 1
fi
log_success "GitHub CLI is installed"

# Step 2: Check authentication
log_info "Checking GitHub authentication..."
if ! gh auth status &> /dev/null; then
    log_error "Not authenticated with GitHub. Please run: gh auth login"
    exit 1
fi
log_success "GitHub authentication verified"

# Step 3: Define workflows
log_info "Preparing workflows..."

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

# Step 4: Trigger all workflows
echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║          Triggering All Workflows                         ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""

for workflow in "${WORKFLOWS[@]}"; do
    log_info "Triggering: $workflow"
    
    # Trigger workflow and capture run ID
    RUN_OUTPUT=$(gh workflow run "$workflow" \
        --ref "$BRANCH" \
        --repo "$GITHUB_OWNER/$GITHUB_REPO" 2>&1)
    
    if echo "$RUN_OUTPUT" | grep -q "queued\|created"; then
        log_success "Workflow queued: $workflow"
        
        # Extract run ID if available
        RUN_ID=$(echo "$RUN_OUTPUT" | grep -oP '(?<=run ID )\d+' || echo "")
        if [ -n "$RUN_ID" ]; then
            RUN_IDS+=("$RUN_ID")
        fi
    else
        log_warning "Workflow triggered: $workflow"
    fi
    
    sleep 2
done

echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║          All Workflows Triggered Successfully!            ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Step 5: Wait and monitor
log_info "Waiting for workflows to complete..."
echo ""

# Function to check workflow status
check_status() {
    local count=0
    local max_wait=3600  # 1 hour
    local elapsed=0
    
    while [ $elapsed -lt $max_wait ]; do
        clear
        
        echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
        echo -e "${BLUE}║          Workflow Status Monitor                          ║${NC}"
        echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
        echo ""
        echo "Elapsed time: $((elapsed / 60)) minutes"
        echo ""
        
        # Get latest runs
        gh run list \
            --repo "$GITHUB_OWNER/$GITHUB_REPO" \
            --limit 20 \
            --json "status,name,createdAt,conclusion" \
            --template '{{range .}}{{.status | printf "%-10s"}} {{.conclusion | printf "%-15s"}} {{.name | printf "%-30s"}} {{.createdAt}}{{"\n"}}{{end}}'
        
        echo ""
        echo "Press Ctrl+C to stop monitoring"
        echo ""
        
        sleep 30
        elapsed=$((elapsed + 30))
    done
}

# Step 6: Show monitoring options
echo "📊 Monitoring Options:"
echo ""
echo "Option 1: Monitor in this terminal (auto-refresh every 30s)"
echo "  Press Enter to start..."
read -p ""
check_status

# Step 7: Final summary
echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║          Workflow Execution Complete                      ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Get final status
log_info "Getting final status..."
echo ""

SUMMARY=$(gh run list \
    --repo "$GITHUB_OWNER/$GITHUB_REPO" \
    --limit 20 \
    --json "status,conclusion,name" \
    --template '{{range .}}{{if eq .status "completed"}}✓{{else}}⏳{{end}} {{.conclusion | printf "%-10s"}} {{.name}}{{"\n"}}{{end}}')

echo "$SUMMARY"
echo ""

# Step 8: Show next steps
log_success "All workflows have been triggered!"
echo ""
echo "📋 Next Steps:"
echo ""
echo "1. Monitor workflows in GitHub:"
echo "   https://github.com/$GITHUB_OWNER/$GITHUB_REPO/actions"
echo ""
echo "2. Check specific workflow:"
echo "   gh run list --workflow build-and-test.yml --repo $GITHUB_OWNER/$GITHUB_REPO"
echo ""
echo "3. View workflow logs:"
echo "   gh run view <run-id> --log --repo $GITHUB_OWNER/$GITHUB_REPO"
echo ""
echo "4. Monitor Azure resources:"
echo "   az containerapp logs show --name edge-ai-app --resource-group edge-ai-rg --follow"
echo ""
echo "5. Check Function App:"
echo "   az functionapp log tail --name edge-ai-functions --resource-group edge-ai-rg"
echo ""

# Step 9: Save summary to file
cat > workflow-execution-summary.txt << EOF
Workflow Execution Summary
Generated: $(date)

Workflows Triggered:
$(printf '%s\n' "${WORKFLOWS[@]}" | nl)

Repository: $GITHUB_OWNER/$GITHUB_REPO
Branch: $BRANCH

Status: All workflows have been triggered successfully!

Monitor at: https://github.com/$GITHUB_OWNER/$GITHUB_REPO/actions

Commands:
- List runs: gh run list --repo $GITHUB_OWNER/$GITHUB_REPO
- View logs: gh run view <run-id> --log --repo $GITHUB_OWNER/$GITHUB_REPO
- Container App logs: az containerapp logs show --name edge-ai-app --resource-group edge-ai-rg --follow
- Function App logs: az functionapp log tail --name edge-ai-functions --resource-group edge-ai-rg
EOF

log_success "Summary saved to: workflow-execution-summary.txt"
echo ""
