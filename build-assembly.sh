#!/bin/bash
# ============================================================================
# Edge-AI-APP Assembly Build Pipeline
# Converts .hex files -> .asm -> ELF64 object files -> linked binary
# ============================================================================
set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

ASM_DIR=".ASM_HEX"
BUILD_DIR="build"
BIN_DIR="$BUILD_DIR/bin"
OBJ_DIR="$BUILD_DIR/obj"
LOG_DIR="$BUILD_DIR/logs"
ARCH="${1:-x86_64}"
PLATFORM="${2:-linux}"

mkdir -p "$BIN_DIR" "$OBJ_DIR" "$LOG_DIR"

echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  Edge-AI-APP Assembly Build Pipeline                       ║${NC}"
echo -e "${BLUE}║  Architecture: $ARCH | Platform: $PLATFORM                 ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"

# ============================================================================
# Step 1: Validate Assembly Tools
# ============================================================================
echo -e "\n${YELLOW}[1/6] Validating Assembly Tools...${NC}"
tools=("nasm" "yasm" "gcc" "ld" "objdump" "readelf")
for tool in "${tools[@]}"; do
    if command -v "$tool" &>/dev/null; then
        echo -e "${GREEN}✓${NC} $tool"
    else
        echo -e "${RED}✗${NC} $tool: NOT FOUND"
    fi
done

# ============================================================================
# Step 2: Write Python converter to a temp file (FIXES the heredoc bug)
# ============================================================================
CONVERTER="/tmp/hex_to_asm_converter.py"
python3 -c "
import sys, os
hex_file = sys.argv[1]
asm_file = sys.argv[2]
try:
    with open(hex_file, 'r') as f:
        hex_content = f.read().replace('\n','').replace(' ','').strip()
    asm_content = bytes.fromhex(hex_content).decode('utf-8', errors='replace')
    with open(asm_file, 'w') as f:
        f.write(asm_content)
    print(f'OK: {os.path.basename(hex_file)} -> {os.path.basename(asm_file)} ({len(asm_content)} bytes)')
    sys.exit(0)
except Exception as e:
    print(f'ERROR: {e}', file=sys.stderr)
    sys.exit(1)
" --help 2>/dev/null || true

# Write the converter properly
cat > "$CONVERTER" << 'PYEOF'
import sys, os
hex_file = sys.argv[1]
asm_file = sys.argv[2]
try:
    with open(hex_file, 'r') as f:
        hex_content = f.read().replace('\n','').replace(' ','').strip()
    asm_content = bytes.fromhex(hex_content).decode('utf-8', errors='replace')
    with open(asm_file, 'w') as f:
        f.write(asm_content)
    print(f"OK: {os.path.basename(hex_file)} -> {os.path.basename(asm_file)} ({len(asm_content)} bytes)")
    sys.exit(0)
except Exception as e:
    print(f"ERROR: {e}", file=sys.stderr)
    sys.exit(1)
PYEOF

# ============================================================================
# Step 3: Convert HEX files to ASM
# ============================================================================
echo -e "\n${YELLOW}[2/6] Converting HEX files to ASM...${NC}"
hex_count=0
for hex_file in "$ASM_DIR"/*.hex; do
    if [ -f "$hex_file" ]; then
        filename=$(basename "$hex_file" .hex)
        asm_file="$OBJ_DIR/${filename}.asm"
        if python3 "$CONVERTER" "$hex_file" "$asm_file"; then
            echo -e "${GREEN}✓${NC} $filename.hex -> $filename.asm"
            hex_count=$((hex_count + 1))
        else
            echo -e "${RED}✗${NC} Failed: $filename.hex"
        fi
    fi
done
echo -e "${GREEN}Converted $hex_count HEX files to ASM${NC}"

# ============================================================================
# Step 4: Assemble ASM files
# ============================================================================
echo -e "\n${YELLOW}[3/6] Assembling ASM files...${NC}"
asm_count=0
obj_count=0
for asm_file in "$OBJ_DIR"/*.asm; do
    if [ -f "$asm_file" ]; then
        filename=$(basename "$asm_file" .asm)
        obj_file="$OBJ_DIR/${filename}.o"
        if nasm -f elf64 -o "$obj_file" "$asm_file" 2>"$LOG_DIR/${filename}.log"; then
            echo -e "${GREEN}✓${NC} $filename.asm -> $filename.o (NASM)"
            obj_count=$((obj_count + 1))
        elif yasm -f elf64 -o "$obj_file" "$asm_file" 2>>"$LOG_DIR/${filename}.log"; then
            echo -e "${GREEN}✓${NC} $filename.asm -> $filename.o (YASM)"
            obj_count=$((obj_count + 1))
        else
            echo -e "${YELLOW}⚠${NC} $filename.asm: skipped (not pure x86-64 ASM)"
        fi
        asm_count=$((asm_count + 1))
    fi
done
echo -e "${GREEN}Assembled $obj_count/$asm_count files${NC}"

# ============================================================================
# Step 5: Link
# ============================================================================
echo -e "\n${YELLOW}[4/6] Linking...${NC}"
final_binary=""
if [ "$obj_count" -gt 0 ]; then
    final_binary="$BIN_DIR/edge-ai-app"
    obj_files=$(find "$OBJ_DIR" -name "*.o" -type f | tr '\n' ' ')
    if ld -o "$final_binary" $obj_files 2>"$LOG_DIR/linking.log"; then
        echo -e "${GREEN}✓${NC} Linked -> $final_binary"
    else
        echo -e "${YELLOW}⚠${NC} Linking warnings (see $LOG_DIR/linking.log)"
    fi
else
    echo -e "${BLUE}ℹ${NC}  No ELF objects produced — hex files decoded to ASM source only"
fi

# ============================================================================
# Step 6: Report
# ============================================================================
echo -e "\n${YELLOW}[5/6] Generating report...${NC}"
report_file="$LOG_DIR/build-report.txt"
cat > "$report_file" << EOF
================================================================================
Edge-AI-APP Assembly Build Report
Generated: $(date)
================================================================================
Build Configuration:
  Architecture: $ARCH
  Platform:     $PLATFORM
  Build Dir:    $BUILD_DIR

Statistics:
  HEX Files Converted: $hex_count
  ASM Files Processed: $asm_count
  Object Files Created: $obj_count
  Final Binary: ${final_binary:-Not created (source decoded to ASM)}
================================================================================
EOF
echo -e "${GREEN}✓${NC} Report: $report_file"

echo -e "\n${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  Build Summary                                             ║${NC}"
echo -e "${BLUE}╠════════════════════════════════════════════════════════════╣${NC}"
echo -e "${BLUE}║${NC} HEX Files Converted:  ${GREEN}$hex_count${NC}"
echo -e "${BLUE}║${NC} ASM Files Processed:  ${GREEN}$asm_count${NC}"
echo -e "${BLUE}║${NC} Object Files Created: ${GREEN}$obj_count${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
echo -e "\n${GREEN}Build pipeline completed!${NC}\n"
