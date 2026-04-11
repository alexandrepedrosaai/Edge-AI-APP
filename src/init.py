"""
Edge-AI-APP TensorFlow Package
==============================

Este pacote contém os módulos principais para:
- Carregamento de dados
- Definição de modelos
- Treinamento
- Avaliação
- Exportação
- Utilitários

O __init__.py organiza e expõe as funções mais importantes
para facilitar a importação em outros scripts.
"""

from .data_loader import load_mnist
from .model import build_model
from .train import train_model
from .evaluate import evaluate_model
from .export import export_model
from .utils import log

__all__ = [
    "load_mnist",
    "build_model",
    "train_model",
    "evaluate_model",
    "export_model",
    "log",
]
