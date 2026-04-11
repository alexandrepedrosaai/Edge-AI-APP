import tensorflow as tf
import tf2onnx


def export_model(h5_path: str, onnx_path: str, tflite_path: str):
    model = tf.keras.models.load_model(h5_path)

    # Export to ONNX
    spec = (tf.TensorSpec((None, 28, 28), tf.float32, name="input"),)
    onnx_model, _ = tf2onnx.convert.from_keras(
        model,
        input_signature=spec,
        opset=13,
    )
    with open(onnx_path, "wb") as f:
        f.write(onnx_model.SerializeToString())
    print(f"Model exported to {onnx_path}")

    # Export to TFLite
    converter = tf.lite.TFLiteConverter.from_keras_model(model)
    tflite_model = converter.convert()
    with open(tflite_path, "wb") as f:
        f.write(tflite_model)
    print(f"Model exported to {tflite_path}")
