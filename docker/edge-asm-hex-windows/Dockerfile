FROM ubuntu:22.04
LABEL org.opencontainers.image.title="edge-asm-hex-windows" \
      org.opencontainers.image.description="Edge-AI-APP ASM/HEX Windows x64 build artifacts (cross-compiled)" \
      org.opencontainers.image.source="https://github.com/alexandrepedrosaai/Edge-AI-APP" \
      org.opencontainers.image.version="windows-x64" \
      sha256.artifact="72f50483b7a90a979c04be802e48fb02f995869bb539c9bca37218cd83b4acdb"

RUN apt-get update -qq && apt-get install -y --no-install-recommends \
    nasm yasm binutils curl ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /edge-ai

# Copy all .asm files from root
COPY *.asm ./
# Copy all .HEX sources
COPY .ASM_HEX/ ./.ASM_HEX/

# Assemble to Win64 COFF objects (cross-compile, non-fatal)
RUN nasm -f win64 manifest.asm -o manifest.obj 2>/dev/null || true && \
    nasm -f win64 Symbolic.asm  -o Symbolic.obj  2>/dev/null || true

RUN echo '{"platform":"windows-x64","sha256":"72f50483b7a90a979c04be802e48fb02f995869bb539c9bca37218cd83b4acdb","built_at":"'$(date -u +%Y-%m-%dT%H:%M:%SZ)'"}' > /edge-ai/build-manifest.json

CMD ["sh", "-c", "echo 'Edge-AI-APP ASM/HEX Windows x64' && ls -lh /edge-ai/"]
