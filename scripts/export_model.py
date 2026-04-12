from src.export import export_model

if __name__ == "__main__":
    # Exporta o modelo para ONNX e TFLite
    export_model("dist/model.h5", "dist/model.onnx", "dist/model.tflite")
