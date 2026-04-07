# edge_ai_inference.py
# Simulates inference of a lightweight model at the edge

class EdgeModel:
    def predict(self, x):
        # Simple rule-based model: classify as 'active' if input > 0.5
        return "active" if x > 0.5 else "inactive"

model = EdgeModel()
data = [0.2, 0.6, 0.8, 0.3]

for d in data:
    print(f"Input: {d:.2f} => Result: {model.predict(d)}")
