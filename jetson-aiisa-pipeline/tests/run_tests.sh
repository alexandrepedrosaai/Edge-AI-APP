#!/bin/bash
set -e

echo "Running unit tests..."

# The binary is located in the build directory created during build.sh
BINARY="./build/pipeline_exec"

# Test 1: Executable runs without error
$BINARY > output.txt
if grep -q "Pipeline executado com sucesso!" output.txt; then
  echo "✅ Test 1 passed: basic execution"
else
  echo "❌ Test 1 failed: basic execution"
  cat output.txt
  exit 1
fi

echo "All unit tests passed!"
