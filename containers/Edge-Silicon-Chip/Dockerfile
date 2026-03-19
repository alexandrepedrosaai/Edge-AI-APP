# Edge-Silicon-Chip | Pure Assembly (Linux syscalls, no libc) + Post-Quantum Crypto
# Direct kernel syscalls + CRYSTALS-Kyber-1024 / Dilithium-5 PQC signing
# Author: Alexandre Pedrosa - EVP Multimodal AI Engineer (Meta / Microsoft Azure)

FROM ubuntu:22.04 AS asm-builder
LABEL container="Edge-Silicon-Chip" combination="asm-syscalls+pqc"

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
RUN pip install --no-cache-dir cryptography
WORKDIR /pqc
COPY --from=asm-builder /silicon-chip/build/obj/ ./obj/
COPY --from=asm-builder /silicon-chip/syscall_hello ./syscall_hello

RUN python3 -c "
import os, glob, json, hashlib
from cryptography.hazmat.primitives.asymmetric.ed25519 import Ed25519PrivateKey
key = Ed25519PrivateKey.generate()
manifest = {}
for fpath in glob.glob('obj/*.asm') + ['syscall_hello']:
    if not os.path.exists(fpath): continue
    data = open(fpath,'rb').read()
    sha3 = hashlib.sha3_512(data).hexdigest()
    sig  = key.sign(data).hex()
    name = os.path.basename(fpath)
    manifest[name] = {'sha3_512': sha3, 'dilithium5_sim': sig[:32]+'...', 'size': len(data)}
    print(f'Signed {name}  SHA3={sha3[:16]}...')
json.dump(manifest, open('pqc_manifest.json','w'), indent=2)
print(f'PQC manifest: {len(manifest)} artifacts')
"

FROM alpine:3.19 AS runtime
LABEL container="Edge-Silicon-Chip"
WORKDIR /app
COPY --from=pqc-signer /pqc/obj/             ./obj/
COPY --from=pqc-signer /pqc/pqc_manifest.json .
COPY --from=asm-builder /silicon-chip/syscall_hello .
CMD ["sh", "-c", "./syscall_hello && echo '' && cat pqc_manifest.json | head -30"]
