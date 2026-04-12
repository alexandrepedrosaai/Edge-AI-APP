#!/bin/bash
# edge_ai_inference.sh
# Simulates inference of a lightweight model at the edge

predict() {
  input=$1
  if (( $(echo "$input > 0.5" | bc -l) )); then
    echo "active"
  else
    echo "inactive"
  fi
}

for d in 0.2 0.6 0.8 0.3; do
  result=$(predict $d)
  echo "Input: $d => Result: $result"
done
