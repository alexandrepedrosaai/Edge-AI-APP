# Silicon-Hardwere | asm_hex
# x86-64 Assembly (NASM) + Hex-encoded source decoding
# Author: Alexandre Pedrosa - EVP Multimodal AI Engineer (Meta / Microsoft Azure)

FROM ubuntu:22.04 AS builder
LABEL container="Silicon-Hardwere" combination="asm_hex"

RUN apt-get update && apt-get install -y build-essential nasm yasm binutils python3 git \
 && apt-get clean

WORKDIR /silicon
COPY .ASM_HEX/ ./.ASM_HEX/
COPY build-assembly.sh .
RUN chmod +x build-assembly.sh && ./build-assembly.sh x86_64 linux || true

FROM alpine:3.19 AS runtime
LABEL container="Silicon-Hardwere"
WORKDIR /artifacts
COPY --from=builder /silicon/build/ ./build/
VOLUME ["/artifacts/build/obj"]
CMD ["sh", "-c", "echo '=== Silicon-Hardwere: Decoded ASM files ===' && ls -lh /artifacts/build/obj/ 2>/dev/null"]
