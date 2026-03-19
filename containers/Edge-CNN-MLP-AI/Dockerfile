# Edge-CNN+MLP.AI | asm-hex + xAI (Grok)
# CNN + MLP Assembly/Hex sources analysed by xAI Grok API
# Author: Alexandre Pedrosa - EVP Multimodal AI Engineer (Meta / Microsoft Azure)

FROM ubuntu:22.04 AS asm-builder
LABEL container="Edge-CNN+MLP.AI" combination="asm-hex+xAI"

RUN apt-get update && apt-get install -y build-essential nasm yasm binutils python3 && apt-get clean

WORKDIR /cnn-mlp
COPY .ASM_HEX/ ./.ASM_HEX/
COPY build-assembly.sh .
RUN chmod +x build-assembly.sh && ./build-assembly.sh x86_64 linux || true

FROM python:3.11-slim AS xai-analyser
RUN pip install --no-cache-dir requests
WORKDIR /analysis
COPY --from=asm-builder /cnn-mlp/build/obj/ ./obj/

RUN cat > analyse.py << 'PYEOF'
import os, glob, requests

api_key = os.getenv("XAI_API_KEY", "")
print("=== Edge-CNN+MLP.AI - xAI Grok Analysis ===")
files = glob.glob("obj/*.asm")
print(f"Decoded Assembly files: {len(files)}")
if not api_key:
    print("XAI_API_KEY not set - skipping live analysis")
    for f in files[:5]:
        print(f"  - {os.path.basename(f)}")
else:
    for f in files[:3]:
        with open(f) as fh:
            content = fh.read(500)
        r = requests.post("https://api.x.ai/v1/chat/completions",
            headers={"Authorization": f"Bearer {api_key}", "Content-Type": "application/json"},
            json={"model":"grok-3-mini","messages":[{"role":"user","content":f"Describe this Assembly:\n{content}"}],"max_tokens":120},
            timeout=30)
        if r.ok:
            print(f"\n--- {os.path.basename(f)} ---")
            print(r.json()["choices"][0]["message"]["content"])
PYEOF

FROM python:3.11-slim AS runtime
LABEL container="Edge-CNN+MLP.AI"
RUN pip install --no-cache-dir requests
WORKDIR /app
COPY --from=xai-analyser /analysis/obj/      ./obj/
COPY --from=xai-analyser /analysis/analyse.py .
ENV XAI_API_KEY=""
CMD ["python3", "analyse.py"]
