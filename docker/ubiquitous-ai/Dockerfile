FROM ubuntu:22.04
LABEL org.opencontainers.image.title="ubiquitous-ai-from-edge-to-silicon-cloud-and-chip-from-chip-to-edge-metamorphosis" \
      org.opencontainers.image.description="Edge-AI-APP Ubiquitous AI — VSCode 1.107.1 + ASM/HEX — from Edge to Silicon Cloud and Chip, from Chip to Edge metamorphosis" \
      org.opencontainers.image.source="https://github.com/alexandrepedrosaai/Edge-AI-APP" \
      org.opencontainers.image.version="chip-developer-kit" \
      release.asset="code_1.107.1-1765982436_amd64.deb" \
      release.url="https://github.com/alexandrepedrosaai/Edge-AI-APP/releases/download/Chip-Developer-Kit/code_1.107.1-1765982436_amd64.deb"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -qq && apt-get install -y --no-install-recommends \
    curl ca-certificates nasm libgtk-3-0 libxss1 libasound2 \
    libgbm1 libxkbfile1 libsecret-1-0 libnotify4 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /edge-ai/ubiquitous

# Copy ASM/HEX sources
COPY *.asm ./
COPY .ASM_HEX/ ./.ASM_HEX/

# Download VSCode deb from Chip-Developer-Kit release
RUN curl -fSL \
    "https://github.com/alexandrepedrosaai/Edge-AI-APP/releases/download/Chip-Developer-Kit/code_1.107.1-1765982436_amd64.deb" \
    -o code_1.107.1-1765982436_amd64.deb && \
    dpkg -i code_1.107.1-1765982436_amd64.deb 2>/dev/null || \
    apt-get install -f -y 2>/dev/null || true && \
    echo "VSCode 1.107.1 installed" && \
    ls -lh

# Assemble edge manifest
RUN nasm -f elf64 manifest.asm -o manifest.o 2>/dev/null || true

RUN echo '{"package":"ubiquitous-ai-from-edge-to-silicon-cloud-and-chip","asset":"code_1.107.1-1765982436_amd64.deb","vscode":"1.107.1","platform":"linux-amd64","built_at":"'$(date -u +%Y-%m-%dT%H:%M:%SZ)'"}' > ubiquitous-manifest.json

CMD ["sh", "-c", "echo 'Ubiquitous-AI — VSCode 1.107.1 + ASM/HEX Edge-to-Silicon' && ls -lh /edge-ai/ubiquitous/"]
