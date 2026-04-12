FROM ubuntu:22.04
LABEL org.opencontainers.image.title="immutable-edge-ai" \
      org.opencontainers.image.description="Edge-AI-APP Immutable Inscription — eternal build 5 — from cloud sky to silicon metal" \
      org.opencontainers.image.source="https://github.com/alexandrepedrosaai/Edge-AI-APP" \
      org.opencontainers.image.version="multi-os-v5" \
      inscription="Edge-AI-APP — from cloud sky to silicon metal — exoteric hex chip — eternal build 5" \
      sha256.commit="6ae9ec7598252fe3113b2f25c56c9d5128c3ec61"

RUN apt-get update -qq && apt-get install -y --no-install-recommends \
    ca-certificates curl jq \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /edge-ai/immutable

# Copy all ASM/HEX sources for immutable record
COPY *.asm ./
COPY .ASM_HEX/ ./.ASM_HEX/

# Embed the immutable inscription manifest
COPY docker/immutable-edge-ai/immutable.json ./immutable.json

# Create immutable hash record
RUN sha256sum *.asm > asm-checksums.sha256 2>/dev/null || true && \
    find .ASM_HEX -name "*.hex" -exec sha256sum {} \; >> asm-checksums.sha256 2>/dev/null || true

CMD ["sh", "-c", "echo '=== IMMUTABLE INSCRIPTION ===' && cat /edge-ai/immutable/immutable.json && echo '' && echo '=== ASM CHECKSUMS ===' && cat /edge-ai/immutable/asm-checksums.sha256"]
