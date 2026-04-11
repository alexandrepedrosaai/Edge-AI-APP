from src.evaluate import evaluate_model

if __name__ == "__main__":
    # Avalia o modelo salvo e imprime métricas
    acc, loss = evaluate_model("dist/model.h5")
    print(f"Final evaluation -> Accuracy: {acc:.4f}, Loss: {loss:.4f}")
