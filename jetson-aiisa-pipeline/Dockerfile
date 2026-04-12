FROM nvcr.io/nvidia/l4t-base:r35.1.0

RUN apt-get update && apt-get install -y \
    build-essential \
    gcc-aarch64-linux-gnu \
    g++-aarch64-linux-gnu \
    cmake git \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace
COPY src/asm/ ./src/asm/
COPY src/cpp/ ./src/cpp/
COPY scripts/build.sh ./scripts/
COPY tests/ ./tests/

RUN chmod +x ./scripts/build.sh ./tests/run_tests.sh && ./scripts/build.sh
CMD ["./pipeline_exec"]
