import numpy as np
import onnxruntime as ort

# Carrega modelo ONNX
ort_session = ort.InferenceSession("onnx-llm-matrix/models/llm_model.onnx")

# Input fictício
dummy_input = np.random.randint(0, 1000, (1, 16)).astype(np.int64)

# Executa inferência
outputs = ort_session.run(None, {"input_ids": dummy_input})

print("✅ Inferência ONNX concluída!")
print("Logits:", outputs[0])
