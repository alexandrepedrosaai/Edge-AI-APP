import numpy as np
import onnxruntime as ort

ort_session = ort.InferenceSession("onnx-llm-matrix/models/llm_model.onnx")
dummy_input = np.random.randint(0, 1000, (1, 16)).astype(np.int64)
outputs = ort_session.run(None, {"input_ids": dummy_input})
print(outputs[0])
