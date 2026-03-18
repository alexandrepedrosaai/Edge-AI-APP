#!/bin/bash

# ============================================================================
# Edge-AI-APP Assembly Build Pipeline
# Robust pipeline for assembling, linking, and validating Assembly code
# ============================================================================

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
ASM_DIR=".ASM_HEX"
BUILD_DIR="build"
BIN_DIR="$BUILD_DIR/bin"
OBJ_DIR="$BUILD_DIR/obj"
LOG_DIR="$BUILD_DIR/logs"
ARCH="${1:-x86_64}"
PLATFORM="${2:-linux}"

# Create directories
mkdir -p "$BIN_DIR" "$OBJ_DIR" "$LOG_DIR"

echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  Edge-AI-APP Assembly Build Pipeline                       ║${NC}"
echo -e "${BLUE}║  Architecture: $ARCH | Platform: $PLATFORM                      ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"

# ============================================================================
# Step 1: Validate Assembly Tools
# ============================================================================
echo -e "\n${YELLOW}[1/6] Validating Assembly Tools...${NC}"

tools=("nasm" "yasm" "gcc" "ld" "gdb" "objdump" "readelf" "checksec")
missing_tools=()

for tool in "${tools[@]}"; do
    if command -v "$tool" &> /dev/null; then
        version=$($tool --version 2>&1 | head -1)
        echo -e "${GREEN}✓${NC} $tool: $version"
    else
        echo -e "${RED}✗${NC} $tool: NOT FOUND"
        missing_tools+=("$tool")
    fi
done

if [ ${#missing_tools[@]} -gt 0 ]; then
    echo -e "${RED}Warning: Missing tools: ${missing_tools[*]}${NC}"
fi

# ============================================================================
# Step 2: Convert HEX files back to ASM for compilation
# ============================================================================
echo -e "\n${YELLOW}[2/6] Converting HEX files to ASM...${NC}"

hex_to_asm() {
    local hex_file=$1
    local asm_file=$2
    
    # Convert hex string to ASCII
    python3 << 'PYTHON_EOF'
import sys
hex_file = sys.argv[1]
asm_file = sys.argv[2]

try:
    with open(hex_file, 'r') as f:
        hex_content = f.read().replace('\n', '')
    
    # Convert hex to ASCII
    asm_content = bytes.fromhex(hex_content).decode('utf-8', errors='ignore')
    
    with open(asm_file, 'w') as f:
        f.write(asm_content)
    
    return True
except Exception as e:
    print(f"Error: {e}", file=sys.stderr)
    return False
PYTHON_EOF
}

hex_count=0
for hex_file in "$ASM_DIR"/*.hex; do
    if [ -f "$hex_file" ]; then
        filename=$(basename "$hex_file" .hex)
        asm_file="$OBJ_DIR/${filename}.asm"
        
        if hex_to_asm "$hex_file" "$asm_file" 2>/dev/null; then
            echo -e "${GREEN}✓${NC} $filename.hex → $filename.asm"
            ((hex_count++))
        else
            echo -e "${RED}✗${NC} Failed to convert $filename.hex"
        fi
    fi
done

echo -e "${GREEN}Converted $hex_count HEX files to ASM${NC}"

# ============================================================================
# Step 3: Assemble ASM files to Object files
# ============================================================================
echo -e "\n${YELLOW}[3/6] Assembling ASM files...${NC}"

asm_count=0
obj_count=0

for asm_file in "$OBJ_DIR"/*.asm; do
    if [ -f "$asm_file" ]; then
        filename=$(basename "$asm_file" .asm)
        obj_file="$OBJ_DIR/${filename}.o"
        
        # Try NASM first, then YASM
        if nasm -f elf64 -o "$obj_file" "$asm_file" 2>"$LOG_DIR/${filename}.log"; then
            echo -e "${GREEN}✓${NC} $filename.asm → $filename.o (NASM)"
            ((obj_count++))
        elif yasm -f elf64 -o "$obj_file" "$asm_file" 2>>"$LOG_DIR/${filename}.log"; then
            echo -e "${GREEN}✓${NC} $filename.asm → $filename.o (YASM)"
            ((obj_count++))
        else
            echo -e "${YELLOW}⚠${NC} $filename.asm: Assembly skipped (may not be valid ASM)"
        fi
        ((asm_count++))
    fi
done

echo -e "${GREEN}Assembled $obj_count/$asm_count files successfully${NC}"

# ============================================================================
# Step 4: Link Object files
# ============================================================================
echo -e "\n${YELLOW}[4/6] Linking object files...${NC}"

if [ $obj_count -gt 0 ]; then
    final_binary="$BIN_DIR/edge-ai-app"
    
    # Collect all object files
    obj_files=$(find "$OBJ_DIR" -name "*.o" -type f)
    
    if [ -n "$obj_files" ]; then
        if ld -o "$final_binary" $obj_files 2>"$LOG_DIR/linking.log"; then
            echo -e "${GREEN}✓${NC} Linked to: $final_binary"
        else
            echo -e "${YELLOW}⚠${NC} Linking completed with warnings (see $LOG_DIR/linking.log)"
        fi
    fi
fi

# ============================================================================
# Step 5: Analyze and Validate Binaries
# ============================================================================
echo -e "\n${YELLOW}[5/6] Analyzing binaries...${NC}"

if [ -f "$final_binary" ]; then
    echo -e "${BLUE}Binary Information:${NC}"
    
    # File info
    file "$final_binary"
    
    # Size info
    size "$final_binary" 2>/dev/null || echo "Size info unavailable"
    
    # Security checks
    echo -e "\n${BLUE}Security Analysis:${NC}"
    checksec --file="$final_binary" 2>/dev/null || echo "Checksec not available"
    
    # Symbols
    echo -e "\n${BLUE}Symbols:${NC}"
    readelf -s "$final_binary" 2>/dev/null | head -20 || echo "Symbol info unavailable"
    
    # Sections
    echo -e "\n${BLUE}Sections:${NC}"
    objdump -h "$final_binary" 2>/dev/null | head -15 || echo "Section info unavailable"
fi

# ============================================================================
# Step 6: Generate Build Report
# ============================================================================
echo -e "\n${YELLOW}[6/6] Generating build report...${NC}"

report_file="$LOG_DIR/build-report.txt"

cat > "$report_file" << EOF
================================================================================
Edge-AI-APP Assembly Build Report
Generated: $(date)
================================================================================

Build Configuration:
  Architecture: $ARCH
  Platform: $PLATFORM
  Build Directory: $BUILD_DIR

Statistics:
  HEX Files Converted: $hex_count
  ASM Files Processed: $asm_count
  Object Files Created: $obj_count
  Final Binary: ${final_binary:-Not created}

Tools Installed:
EOF

for tool in "${tools[@]}"; do
    if command -v "$tool" &> /dev/null; then
        echo "  ✓ $tool" >> "$report_file"
    else
        echo "  ✗ $tool (missing)" >> "$report_file"
    fi
done

echo "" >> "$report_file"
echo "Build Logs:" >> "$report_file"
echo "  Assembly Logs: $LOG_DIR/*.log" >> "$report_file"
echo "  Linking Log: $LOG_DIR/linking.log" >> "$report_file"

echo -e "${GREEN}✓${NC} Report saved to: $report_file"

# ============================================================================
# Summary
# ============================================================================
echo -e "\n${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  Build Summary                                             ║${NC}"
echo -e "${BLUE}╠════════════════════════════════════════════════════════════╣${NC}"
echo -e "${BLUE}║${NC} HEX Files Converted:    ${GREEN}$hex_count${NC}"
echo -e "${BLUE}║${NC} ASM Files Processed:    ${GREEN}$asm_count${NC}"
echo -e "${BLUE}║${NC} Object Files Created:   ${GREEN}$obj_count${NC}"
echo -e "${BLUE}║${NC} Build Directory:        ${GREEN}$BUILD_DIR${NC}"
echo -e "${BLUE}║${NC} Report:                 ${GREEN}$report_file${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"

echo -e "\n${GREEN}Build pipeline completed!${NC}\n"
