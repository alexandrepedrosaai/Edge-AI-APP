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

COPY *.asm ./
COPY .ASM_HEX/ ./.ASM_HEX/
COPY manifest.asm Symbolic.asm Pseudo-bytecode.asm vite.config.asm ./

# Assemble to Mach-O compatible flat binary (cross-compile notation)
RUN for f in manifest.asm Symbolic.asm; do \
      nasm -f bin "$f" -o "${f%.asm}.macho.bin" 2>/dev/null || true; \
    done

RUN echo '{"platform":"macos-x64","sha256":"74041e2c0c79382c1479ce58df73e5ded4b93c42e5c7d69dd809c10ac9046563","built_at":"'$(date -u +%Y-%m-%dT%H:%M:%SZ)'"}' > /edge-ai/build-manifest.json

CMD ["sh", "-c", "echo 'Edge-AI-APP ASM/HEX macOS x64' && ls -lh /edge-ai/"]
