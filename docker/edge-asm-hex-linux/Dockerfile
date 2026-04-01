FROM ubuntu:22.04
LABEL org.opencontainers.image.title="edge-asm-hex-linux" \
      org.opencontainers.image.description="Edge-AI-APP ASM/HEX Linux x64 build artifacts" \
      org.opencontainers.image.source="https://github.com/alexandrepedrosaai/Edge-AI-APP" \
      org.opencontainers.image.version="linux-x64" \
      sha256.artifact="15206001eacc685c24c8cd3c448d23822a90f833a0dc57176a4bfdcb86319ad0"

RUN apt-get update -qq && apt-get install -y --no-install-recommends \
    nasm yasm binutils curl ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /edge-ai

# Copy all .asm and .HEX sources
COPY *.asm ./
COPY .ASM_HEX/ ./.ASM_HEX/
COPY manifest.asm Symbolic.asm Pseudo-bytecode.asm vite.config.asm ./

# Assemble to ELF64 objects
RUN for f in manifest.asm Symbolic.asm; do \
      nasm -f elf64 "$f" -o "${f%.asm}.o" 2>/dev/null || true; \
    done

# Generate build manifest
RUN echo '{"platform":"linux-x64","sha256":"15206001eacc685c24c8cd3c448d23822a90f833a0dc57176a4bfdcb86319ad0","built_at":"'$(date -u +%Y-%m-%dT%H:%M:%SZ)'"}' > /edge-ai/build-manifest.json

CMD ["sh", "-c", "echo 'Edge-AI-APP ASM/HEX Linux x64' && ls -lh /edge-ai/"]
