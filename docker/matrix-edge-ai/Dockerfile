FROM ubuntu:22.04
LABEL org.opencontainers.image.title="matrix-edge-ai" \
      org.opencontainers.image.description="Edge-AI-APP Multi-OS Matrix build with SBOM — Linux, macOS, Windows" \
      org.opencontainers.image.source="https://github.com/alexandrepedrosaai/Edge-AI-APP" \
      org.opencontainers.image.version="multi-os-v5"

RUN apt-get update -qq && apt-get install -y --no-install-recommends \
    nasm yasm binutils curl ca-certificates jq \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /edge-ai/matrix

# Copy all ASM/HEX sources
COPY *.asm ./
COPY .ASM_HEX/ ./.ASM_HEX/

# Copy SBOM
COPY docker/matrix-edge-ai/sbom.json ./sbom.json

# Assemble all three platform targets
RUN mkdir -p build/linux build/macos build/windows && \
    for f in manifest.asm Symbolic.asm; do \
      nasm -f elf64 "$f" -o "build/linux/${f%.asm}.o"       2>/dev/null || true; \
      nasm -f bin   "$f" -o "build/macos/${f%.asm}.macho.bin" 2>/dev/null || true; \
      nasm -f win64 "$f" -o "build/windows/${f%.asm}.obj"    2>/dev/null || true; \
    done

# Embed SBOM metadata
RUN echo "=== SBOM ===" && cat sbom.json

CMD ["sh", "-c", "echo 'Edge-AI-APP Matrix — Linux + macOS + Windows' && cat /edge-ai/matrix/sbom.json"]
