import torch
from model import build_model

# Instancia modelo
model = build_model()
model.eval()

# Input fictício
dummy_input = torch.randint(0, 1000, (1, 16))

# Exporta para ONNX
torch.onnx.export(
    model,
    dummy_input,
    "onnx-llm-matrix/models/llm_model.onnx",
    input_names=["input_ids"],
    output_names=["logits"],
    opset_version=17
)

print("✅ Modelo exportado para ONNX com sucesso!")
