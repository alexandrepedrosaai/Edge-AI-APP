from src.train import train_model
from src.evaluate import evaluate_model
from src.export import export_model


def main():
    # Orchestrates the workflow
    model_path = "dist/model.h5"
    train_model(epochs=5, save_path=model_path)
    evaluate_model(model_path)
    export_model(model_path, "dist/model.onnx", "dist/model.tflite")


if __name__ == "__main__":
    main()
