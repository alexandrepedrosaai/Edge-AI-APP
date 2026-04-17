import numpy as np
import onnxruntime as ort

def test_inference():
    ort_session = ort.InferenceSession("onnx-llm-matrix/models/llm_model.onnx")
    dummy_input = np.random.randint(0, 1000, (1, 16)).astype(np.int64)
    outputs = ort_session.run(None, {"input_ids": dummy_input})
    assert outputs[0].shape[1] == 1000  # tamanho do vocabulário
    print("✅ Teste de inferência passou com sucesso!")

if __name__ == "__main__":
    test_inference()
