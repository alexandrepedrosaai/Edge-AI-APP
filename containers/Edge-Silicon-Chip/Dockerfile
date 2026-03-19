# Edge-Silicon-Chip | Pure Assembly (Linux syscalls, no libc) + Post-Quantum Crypto
# Direct kernel syscalls + CRYSTALS-Kyber-1024 / Dilithium-5 PQC signing
# Author: Alexandre Pedrosa - EVP Multimodal AI Engineer (Meta / Microsoft Azure)

FROM ubuntu:22.04 AS asm-builder
LABEL container="Edge-Silicon-Chip" combination="asm-syscalls+pqc"
LABEL org.opencontainers.image.source="https://github.com/alexandrepedrosaai/Edge-AI-APP"
LABEL org.opencontainers.image.description="Edge-Silicon-Chip: pure Assembly syscalls + PQC"

RUN apt-get update && apt-get install -y nasm yasm binutils python3 && apt-get clean

WORKDIR /silicon-chip
COPY .ASM_HEX/ ./.ASM_HEX/
COPY build-assembly.sh .
RUN chmod +x build-assembly.sh && ./build-assembly.sh x86_64 linux || true

# Minimal syscall-only Assembly hello (no libc)
RUN printf '%s\n' \
    'section .data' \
    '    msg  db "Edge-Silicon-Chip: direct Linux kernel syscall - no libc", 0x0A' \
    '    mlen equ $ - msg' \
    'section .text' \
    '    global _start' \
    '_start:' \
    '    mov rax, 1' \
    '    mov rdi, 1' \
    '    lea rsi, [rel msg]' \
    '    mov rdx, mlen' \
    '    syscall' \
    '    mov rax, 60' \
    '    xor rdi, rdi' \
    '    syscall' \
    > syscall_hello.asm && \
    nasm -f elf64 -o syscall_hello.o syscall_hello.asm && \
    ld -o syscall_hello syscall_hello.o && \
    echo "syscall_hello built OK" && ./syscall_hello

FROM python:3.11-slim AS pqc-signer
LABEL org.opencontainers.image.source="https://github.com/alexandrepedrosaai/Edge-AI-APP"

RUN pip install --no-cache-dir cryptography

WORKDIR /pqc
COPY --from=asm-builder /silicon-chip/build/obj/ ./obj/
COPY --from=asm-builder /silicon-chip/syscall_hello ./syscall_hello
COPY containers/Edge-Silicon-Chip/sign_artifacts.py ./sign_artifacts.py
RUN python3 sign_artifacts.py

FROM alpine:3.19 AS runtime
LABEL container="Edge-Silicon-Chip"
LABEL org.opencontainers.image.source="https://github.com/alexandrepedrosaai/Edge-AI-APP"

WORKDIR /app
COPY --from=pqc-signer /pqc/obj/              ./obj/
COPY --from=pqc-signer /pqc/pqc_manifest.json .
COPY --from=asm-builder /silicon-chip/syscall_hello .
CMD ["sh", "-c", "./syscall_hello && echo '' && cat pqc_manifest.json | head -30"]
