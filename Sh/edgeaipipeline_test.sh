#!/bin/bash
# edge_ai_pipeline_test.sh
# Basic test script for edge inference

predict() {
  input=$1
  if (( $(echo "$input > 0.5" | bc -l) )); then
    echo "active"
  else
    echo "inactive"
  fi
}

echo "Running pipeline tests..."
test1=$(predict 0.9)
test2=$(predict 0.1)

if [[ "$test1" == "active" && "$test2" == "inactive" ]]; then
  echo "✅ Tests passed"
else
  echo "❌ Tests failed"
  exit 1
fi
