#!/usr/bin/env bash
# Build script for Intel Cyclone V using Quartus Prime
# Usage: ./scripts/build_cyclonev.sh
set -euo pipefail

PROJECT_NAME="EdgeAIApp_CycloneV"
QSF="constraints/cycloneV.qsf"
OUTPUT_DIR="fpga_build"

echo "=== Edge-AI-APP: Quartus Cyclone V Build ==="

if ! command -v quartus_sh &>/dev/null; then
    echo "ERROR: quartus_sh not found. Install Quartus Prime and add to PATH."
    exit 1
fi

mkdir -p "$OUTPUT_DIR"

# Create Quartus project file
quartus_sh --flow compile "$QSF"

# Copy output bitstream
cp "output_files/${PROJECT_NAME}.sof" "${OUTPUT_DIR}/${PROJECT_NAME}.sof" 2>/dev/null || true

echo "=== Build complete: ${OUTPUT_DIR}/${PROJECT_NAME}.sof ==="
