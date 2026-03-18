#!/bin/bash

# ============================================================================
# Edge-AI-APP Dependencies Installation Script
# Installs all required dependencies for Assembly, Node.js, Python, and Docker
# ============================================================================

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  Edge-AI-APP Dependencies Installation                     ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"

# ============================================================================
# System Update
# ============================================================================
echo -e "\n${YELLOW}[1/5] Updating system packages...${NC}"
sudo apt-get update -qq
sudo apt-get upgrade -y -qq

# ============================================================================
# Install System Dependencies
# ============================================================================
echo -e "\n${YELLOW}[2/5] Installing system dependencies...${NC}"

SYSTEM_DEPS=(
    # Build tools
    "build-essential"
    "curl"
    "wget"
    "git"
    "ca-certificates"
    
    # Assembly tools
    "nasm"
    "yasm"
    "binutils"
    "gcc"
    "g++"
    
    # Debuggers & Analysis
    "gdb"
    "checksec"
    
    # Runtime
    "nodejs"
    "npm"
    "python3"
    "python3-pip"
    "python3-dev"
    
    # Utilities
    "jq"
    "apt-transport-https"
    "gnupg"
    "lsb-release"
)

for dep in "${SYSTEM_DEPS[@]}"; do
    if ! dpkg -l | grep -q "^ii  $dep"; then
        echo -e "${YELLOW}Installing $dep...${NC}"
        sudo apt-get install -y -qq "$dep" 2>/dev/null || echo -e "${RED}Failed to install $dep${NC}"
    else
        echo -e "${GREEN}✓${NC} $dep already installed"
    fi
done

# ============================================================================
# Install Node.js Tools
# ============================================================================
echo -e "\n${YELLOW}[3/5] Installing Node.js tools...${NC}"

# Install pnpm
if ! command -v pnpm &> /dev/null; then
    echo -e "${YELLOW}Installing pnpm...${NC}"
    npm install -g pnpm -q
    echo -e "${GREEN}✓${NC} pnpm installed"
else
    echo -e "${GREEN}✓${NC} pnpm already installed"
fi

# ============================================================================
# Install Python Tools
# ============================================================================
echo -e "\n${YELLOW}[4/5] Installing Python tools...${NC}"

python3 -m pip install --upgrade pip setuptools wheel -q 2>/dev/null || true

PYTHON_PACKAGES=(
    "syft"
    "trivy"
)

for pkg in "${PYTHON_PACKAGES[@]}"; do
    if ! pip show "$pkg" &> /dev/null; then
        echo -e "${YELLOW}Installing $pkg...${NC}"
        pip install "$pkg" -q 2>/dev/null || echo -e "${RED}Failed to install $pkg${NC}"
    else
        echo -e "${GREEN}✓${NC} $pkg already installed"
    fi
done

# ============================================================================
# Install Docker Tools (if not in container)
# ============================================================================
echo -e "\n${YELLOW}[5/5] Installing Docker tools...${NC}"

if ! command -v docker &> /dev/null; then
    echo -e "${YELLOW}Docker not found. Installing...${NC}"
    curl -fsSL https://get.docker.com -o get-docker.sh 2>/dev/null || true
    if [ -f "get-docker.sh" ]; then
        sudo sh get-docker.sh -q || echo -e "${RED}Failed to install Docker${NC}"
        rm -f get-docker.sh
    fi
else
    echo -e "${GREEN}✓${NC} Docker already installed"
fi

# ============================================================================
# Verify Installation
# ============================================================================
echo -e "\n${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  Verifying Installation                                    ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"

echo -e "\n${BLUE}System Tools:${NC}"
echo "- Node.js: $(node --version)"
echo "- npm: $(npm --version)"
echo "- pnpm: $(pnpm --version)"
echo "- Python: $(python3 --version)"

echo -e "\n${BLUE}Assembly Tools:${NC}"
echo "- NASM: $(nasm --version 2>&1 | head -1)"
echo "- YASM: $(yasm --version 2>&1 | head -1)"
echo "- GCC: $(gcc --version 2>&1 | head -1)"
echo "- GDB: $(gdb --version 2>&1 | head -1)"

echo -e "\n${BLUE}Analysis Tools:${NC}"
echo "- Checksec: $(checksec --version 2>&1 || echo 'Not available')"
echo "- Syft: $(syft --version 2>&1 || echo 'Not available')"
echo "- Trivy: $(trivy --version 2>&1 || echo 'Not available')"

echo -e "\n${BLUE}Docker:${NC}"
echo "- Docker: $(docker --version 2>&1 || echo 'Not available')"

echo -e "\n${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║  Installation Complete!                                    ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}\n"
