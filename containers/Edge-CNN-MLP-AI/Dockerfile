# Edge-CNN+MLP.AI | asm-hex + xAI (Grok)
# CNN + MLP Assembly/Hex sources assembled then analysed by xAI Grok API
# Author: Alexandre Pedrosa - EVP Multimodal AI Engineer (Meta / Microsoft Azure)

FROM ubuntu:22.04 AS asm-builder
LABEL container="Edge-CNN+MLP.AI" combination="asm-hex+xAI"
LABEL org.opencontainers.image.source="https://github.com/alexandrepedrosaai/Edge-AI-APP"
LABEL org.opencontainers.image.description="Edge-CNN+MLP.AI: asm-hex + xAI Grok analysis"

RUN apt-get update && apt-get install -y build-essential nasm yasm binutils python3 && apt-get clean

WORKDIR /cnn-mlp
COPY .ASM_HEX/ ./.ASM_HEX/
COPY build-assembly.sh .
RUN chmod +x build-assembly.sh && ./build-assembly.sh x86_64 linux || true

FROM python:3.11-slim AS xai-analyser
LABEL org.opencontainers.image.source="https://github.com/alexandrepedrosaai/Edge-AI-APP"

RUN pip install --no-cache-dir requests

WORKDIR /analysis
COPY --from=asm-builder /cnn-mlp/build/obj/ ./obj/
COPY containers/Edge-CNN-MLP-AI/analyse.py ./analyse.py
RUN python3 analyse.py

FROM python:3.11-slim AS runtime
LABEL container="Edge-CNN+MLP.AI"
LABEL org.opencontainers.image.source="https://github.com/alexandrepedrosaai/Edge-AI-APP"

RUN pip install --no-cache-dir requests

WORKDIR /app
COPY --from=xai-analyser /analysis/obj/       ./obj/
COPY --from=xai-analyser /analysis/analyse.py .

ENV XAI_API_KEY=""
CMD ["python3", "analyse.py"]
