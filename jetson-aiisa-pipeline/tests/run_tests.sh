#!/bin/bash
set -e

echo "Running unit tests..."

# Test 1: Executable runs without error
./pipeline_exec > output.txt
if grep -q "Pipeline executed successfully!" output.txt; then
  echo "✅ Test 1 passed: basic execution"
else
  echo "❌ Test 1 failed"
  exit 1
fi

# Test 2: Output matches expected result
EXPECTED=42
RESULT=$(cat result.txt)
if [ "$RESULT" -eq "$EXPECTED" ]; then
  echo "✅ Test 2 passed: correct output"
else
  echo "❌ Test 2 failed (expected $EXPECTED, got $RESULT)"
  exit 1
fi

echo "All unit tests passed!"
