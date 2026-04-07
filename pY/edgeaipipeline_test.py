# edge_ai_pipeline_test.py
import unittest

class EdgeModel:
    def predict(self, x):
        return "active" if x > 0.5 else "inactive"

class TestEdgePipeline(unittest.TestCase):
    def test_inference(self):
        model = EdgeModel()
        self.assertEqual(model.predict(0.9), "active")
        self.assertEqual(model.predict(0.1), "inactive")

if __name__ == "__main__":
    unittest.main()
