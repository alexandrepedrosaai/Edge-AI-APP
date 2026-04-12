# edge_ai_sensor.py
# Simulates sensor readings on an edge device

import random

class Sensor:
    def __init__(self, name):
        self.name = name

    def read_value(self):
        return random.uniform(0.0, 1.0)  # normalized value

sensor = Sensor("Temperature")
value = sensor.read_value()
print(f"Sensor {sensor.name} => value: {value:.2f}")

# Simple AI logic at the edge
if value > 0.7:
    print("⚠️ Alert: value above threshold!")
else:
    print("✅ Value within safe range.")
