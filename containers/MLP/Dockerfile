# MLP | hex_asm
# Hex-encoded MLP neural-network bytecode + Assembly forward-pass
# Author: Alexandre Pedrosa - EVP Multimodal AI Engineer (Meta / Microsoft Azure)

FROM ubuntu:22.04 AS hex-decoder
LABEL org.opencontainers.image.source="https://github.com/alexandrepedrosaai/Edge-AI-APP"
LABEL org.opencontainers.image.description="Edge-AI-APP container: mlp"
LABEL org.opencontainers.image.licenses="All rights reserved"
LABEL container="MLP" combination="hex_asm"

RUN apt-get update && apt-get install -y python3 && apt-get clean

WORKDIR /mlp
COPY .ASM_HEX/ ./.ASM_HEX/

RUN python3 -c "
import os, glob
os.makedirs('decoded', exist_ok=True)
files = glob.glob('.ASM_HEX/*MLP*') + glob.glob('.ASM_HEX/*CNN*') + glob.glob('.ASM_HEX/*Hybrid*')
if not files:
    files = glob.glob('.ASM_HEX/*.hex')[:10]
for hex_file in files:
    with open(hex_file) as f:
        h = f.read().replace('\n','').replace(' ','').strip()
    try:
        content = bytes.fromhex(h).decode('utf-8', errors='replace')
        out = 'decoded/' + os.path.basename(hex_file).replace('.hex','.asm')
        open(out,'w').write(content)
        print('OK', os.path.basename(hex_file))
    except Exception as e:
        print('ERR', hex_file, e)
"

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
WORKDIR /mlp
COPY --from=assembler /mlp/decoded/ ./decoded/
COPY --from=assembler /mlp/obj/     ./obj/
CMD ["sh", "-c", "echo '=== MLP: hex_asm ===' && ls -lh decoded/ && echo '--- objects ---' && ls -lh obj/ 2>/dev/null || echo none"]
