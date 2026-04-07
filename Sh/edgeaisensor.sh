#!/bin/bash
# edge_ai_sensor.sh
# Simulates sensor readings on an edge device

value=$(awk -v min=0 -v max=1 'BEGIN{srand(); print min+rand()*(max-min)}')
echo "Sensor Temperature => value: $value"

# Simple AI logic at the edge
if (( $(echo "$value > 0.7" | bc -l) )); then
  echo "⚠️ Alert: value above threshold!"
else
  echo "✅ Value within safe range."
fi
