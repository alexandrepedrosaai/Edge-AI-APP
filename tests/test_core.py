import os
import sys
import pytest
import tensorflow as tf

# Ensure the src directory is in the Python path
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from src.data_loader import load_mnist
from src.model import build_model
from src.train import train_model
from src.evaluate import evaluate_model
from src.export import export_model

def test_load_mnist():
    (x_train, y_train), (x_test, y_test) = load_mnist()
    assert x_train.shape[1:] == (28, 28)
    assert x_test.shape[1:] == (28, 28)
    assert len(x_train) == len(y_train)
    assert len(x_test) == len(y_test)

def test_build_model():
    model = build_model()
    assert isinstance(model, tf.keras.Model)
    assert model.layers[0].input_shape == (None, 28, 28)
    assert model.layers[-1].output_shape == (None, 10)

def test_full_workflow(tmp_path):
    # Use a temporary directory for model files
    model_h5 = str(tmp_path / "test_model.h5")
    model_onnx = str(tmp_path / "test_model.onnx")
    model_tflite = str(tmp_path / "test_model.tflite")

    # Test training (1 epoch for speed)
    train_model(epochs=1, save_path=model_h5)
    assert os.path.exists(model_h5)

    # Test evaluation
    acc, loss = evaluate_model(model_h5)
    assert isinstance(acc, float)
    assert isinstance(loss, float)

    # Test export
    export_model(model_h5, model_onnx, model_tflite)
    assert os.path.exists(model_onnx)
    assert os.path.exists(model_tflite)
