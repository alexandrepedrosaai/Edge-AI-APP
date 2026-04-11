import tensorflow as tf

def evaluate_model(model_path: str):
    (_, _), (x_test, y_test) = tf.keras.datasets.mnist.load_data()
    x_test = x_test / 255.0
    model = tf.keras.models.load_model(model_path)
    loss, acc = model.evaluate(x_test, y_test, verbose=2)
    print(f"Accuracy: {acc:.4f}, Loss: {loss:.4f}")
    return acc, loss
