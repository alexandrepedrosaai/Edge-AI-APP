from src.train import train_model

if __name__ == "__main__":
    # Executa o treinamento e salva o modelo em dist/model.h5
    train_model(epochs=5, save_path="dist/model.h5")
