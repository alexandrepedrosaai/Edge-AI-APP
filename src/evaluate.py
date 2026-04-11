import argparse
import tensorflow as tf
from src.data_loader import load_mnist


def evaluate_model(model_path: str):
    # Use consistent data loading from src.data_loader
    (_, _), (x_test, y_test) = load_mnist()
    
    model = tf.keras.models.load_model(model_path)
    loss, acc = model.evaluate(x_test, y_test, verbose=2)
    
    # Ensure the output format matches what CI expects
    print(f"Accuracy: {acc:.4f}, Loss: {loss:.4f}")
    
    # Also append to the log file as requested in the solution
    with open('dist/eval_output.log', 'a') as f:
        f.write(f'Accuracy: {acc:.4f}\n')
        
    return acc, loss


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("model_path", type=str, help="Path to the saved model file")
    args = parser.parse_args()
    evaluate_model(args.model_path)
