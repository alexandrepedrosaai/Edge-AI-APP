# MLP | hex_asm
# Hex-encoded MLP/CNN neural-network bytecode decoded to Assembly and assembled
# Author: Alexandre Pedrosa - EVP Multimodal AI Engineer (Meta / Microsoft Azure)

FROM ubuntu:22.04 AS hex-decoder
LABEL container="MLP" combination="hex_asm"
LABEL org.opencontainers.image.source="https://github.com/alexandrepedrosaai/Edge-AI-APP"
LABEL org.opencontainers.image.description="MLP: hex_asm neural-network container"

RUN apt-get update && apt-get install -y python3 && apt-get clean

WORKDIR /mlp
COPY .ASM_HEX/ ./.ASM_HEX/
COPY containers/MLP/decode_mlp.py ./decode_mlp.py
RUN python3 decode_mlp.py

FROM ubuntu:22.04 AS assembler
RUN apt-get update && apt-get install -y nasm yasm binutils && apt-get clean
WORKDIR /mlp
COPY --from=hex-decoder /mlp/decoded/ ./decoded/
RUN mkdir -p obj && for f in decoded/*.asm; do \
    name=$(basename "$f" .asm); \
    nasm -f elf64 -o "obj/${name}.o" "$f" 2>/dev/null && echo "OK ${name}" || echo "SKIP ${name}"; \
done

FROM alpine:3.19 AS runtime
LABEL container="MLP"
LABEL org.opencontainers.image.source="https://github.com/alexandrepedrosaai/Edge-AI-APP"
WORKDIR /mlp
COPY --from=assembler /mlp/decoded/ ./decoded/
COPY --from=assembler /mlp/obj/     ./obj/
CMD ["sh", "-c", "echo '=== MLP: hex_asm ===' && ls -lh decoded/ && echo '--- objects ---' && ls -lh obj/ 2>/dev/null || echo none"]
