FROM ubuntu:22.04
LABEL org.opencontainers.image.title="edge-border-ai" \
      org.opencontainers.image.description="Edge-AI-APP Border AI — Telegram Desktop 6.6.2 + ASM/HEX Edge runtime" \
      org.opencontainers.image.source="https://github.com/alexandrepedrosaai/Edge-AI-APP" \
      org.opencontainers.image.version="chip-developer-kit" \
      release.asset="tsetup.6.6.2.tar.xz" \
      release.url="https://github.com/alexandrepedrosaai/Edge-AI-APP/releases/download/Chip-Developer-Kit/tsetup.6.6.2.tar.xz"

RUN apt-get update -qq && apt-get install -y --no-install-recommends \
    curl ca-certificates xz-utils nasm \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /edge-ai/border

# Copy ASM/HEX sources
COPY *.asm ./
COPY .ASM_HEX/ ./.ASM_HEX/

# Download Telegram Desktop from Chip-Developer-Kit release
RUN curl -fSL \
    "https://github.com/alexandrepedrosaai/Edge-AI-APP/releases/download/Chip-Developer-Kit/tsetup.6.6.2.tar.xz" \
    -o tsetup.6.6.2.tar.xz && \
    tar -xJf tsetup.6.6.2.tar.xz 2>/dev/null || true && \
    echo "Telegram Desktop 6.6.2 extracted" && \
    ls -lh

# Assemble edge manifest
RUN nasm -f elf64 manifest.asm -o manifest.o 2>/dev/null || true

RUN echo '{"package":"edge-border-ai","asset":"tsetup.6.6.2.tar.xz","platform":"linux-x64","built_at":"'$(date -u +%Y-%m-%dT%H:%M:%SZ)'"}' > border-manifest.json

CMD ["sh", "-c", "echo 'Edge-Border-AI — Telegram Desktop 6.6.2 + ASM/HEX' && ls -lh /edge-ai/border/"]
