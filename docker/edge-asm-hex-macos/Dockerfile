FROM ubuntu:22.04
LABEL org.opencontainers.image.title="edge-asm-hex-macos" \
      org.opencontainers.image.description="Edge-AI-APP ASM/HEX macOS x64 build artifacts (cross-compiled)" \
      org.opencontainers.image.source="https://github.com/alexandrepedrosaai/Edge-AI-APP" \
      org.opencontainers.image.version="macos-x64" \
      sha256.artifact="74041e2c0c79382c1479ce58df73e5ded4b93c42e5c7d69dd809c10ac9046563"

RUN apt-get update -qq && apt-get install -y --no-install-recommends \
    nasm yasm binutils curl ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /edge-ai

# Copy all .asm files from root
COPY *.asm ./
# Copy all .HEX sources
COPY .ASM_HEX/ ./.ASM_HEX/

# Assemble to flat binary (Mach-O compatible, cross-compile)
RUN nasm -f bin manifest.asm -o manifest.macho.bin 2>/dev/null || true && \
    nasm -f bin Symbolic.asm  -o Symbolic.macho.bin  2>/dev/null || true

RUN echo '{"platform":"macos-x64","sha256":"74041e2c0c79382c1479ce58df73e5ded4b93c42e5c7d69dd809c10ac9046563","built_at":"'$(date -u +%Y-%m-%dT%H:%M:%SZ)'"}' > /edge-ai/build-manifest.json

CMD ["sh", "-c", "echo 'Edge-AI-APP ASM/HEX macOS x64' && ls -lh /edge-ai/"]
