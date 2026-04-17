FROM nvcr.io/nvidia/l4t-pytorch:r35.2.1-pth2.0-py3

# Instala dependências básicas
RUN apt-get update && apt-get install -y \
    python3-pip \
    tensorrt \
    libnvinfer-dev \
    && rm -rf /var/lib/apt/lists/*

# Instala pacotes Python necessários
RUN pip3 install --upgrade pip
RUN pip3 install torch onnx onnxruntime-gpu numpy

# Copia os arquivos do projeto
WORKDIR /workspace
COPY onnx-llm-matrix/ ./onnx-llm-matrix/

# Comando padrão: rodar inferência ONNX
CMD ["python3", "onnx-llm-matrix/src/inference.py"]
