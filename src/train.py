from src.data_loader import load_mnist
from src.model import build_model


def train_model(epochs: int, save_path: str):
    (x_train, y_train), (x_test, y_test) = load_mnist()
    model = build_model()
    model.compile(
        optimizer="adam", loss="sparse_categorical_crossentropy", metrics=["accuracy"]
    )
    model.fit(x_train, y_train, epochs=epochs, validation_data=(x_test, y_test))
    model.save(save_path)
    print(f"Model saved to {save_path}")
