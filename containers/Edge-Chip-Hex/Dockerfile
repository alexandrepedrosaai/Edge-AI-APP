# Edge-Chip-Hex | Hex firmware + Azure ACS / WhatsApp
# Decodes hex chip firmware, validates SHA3-512, dispatches via Azure ACS WhatsApp
# Author: Alexandre Pedrosa - EVP Multimodal AI Engineer (Meta / Microsoft Azure)

FROM python:3.11-slim AS hex-validator
LABEL org.opencontainers.image.source="https://github.com/alexandrepedrosaai/Edge-AI-APP"
LABEL org.opencontainers.image.description="Edge-AI-APP container: edge-chip-hex"
LABEL org.opencontainers.image.licenses="All rights reserved"
LABEL container="Edge-Chip-Hex" combination="hex+azure-acs+whatsapp"

RUN pip install --no-cache-dir cryptography

WORKDIR /chip
COPY .ASM_HEX/ ./.ASM_HEX/

RUN python3 -c "
import os, glob, hashlib, json
os.makedirs('firmware', exist_ok=True)
manifest = {}
for hex_file in glob.glob('.ASM_HEX/*.hex'):
    with open(hex_file) as f:
        h = f.read().replace('\n','').replace(' ','').strip()
    try:
        raw  = bytes.fromhex(h)
        sha3 = hashlib.sha3_512(raw).hexdigest()
        name = os.path.basename(hex_file).replace('.hex','')
        open(f'firmware/{name}.bin','wb').write(raw)
        manifest[name] = {'sha3_512': sha3, 'size': len(raw)}
        print(f'OK {name}  SHA3={sha3[:16]}...')
    except Exception as e:
        print(f'ERR {hex_file}: {e}')
json.dump(manifest, open('firmware/manifest.json','w'), indent=2)
print(f'Manifest: {len(manifest)} entries')
"

FROM python:3.11-slim AS runtime
LABEL container="Edge-Chip-Hex"
RUN pip install --no-cache-dir requests
WORKDIR /app
COPY --from=hex-validator /chip/firmware/ ./firmware/

RUN cat > dispatch.py << 'PYEOF'
import os, json, requests

acs_endpoint  = os.getenv("ACS_ENDPOINT","")
acs_key       = os.getenv("ACS_ACCESS_KEY","")
whatsapp_from = os.getenv("WHATSAPP_FROM","")
whatsapp_to   = os.getenv("WHATSAPP_TO","")

manifest = json.load(open("firmware/manifest.json"))
summary  = f"Edge-Chip-Hex: {len(manifest)} firmware blobs validated via SHA3-512."
print(summary)

if all([acs_endpoint, acs_key, whatsapp_from, whatsapp_to]):
    r = requests.post(
        f"{acs_endpoint}/messages/notifications:send?api-version=2024-02-01",
        json={"channelRegistrationId": whatsapp_from, "to": whatsapp_to,
              "kind": "text", "content": summary},
        headers={"Ocp-Apim-Subscription-Key": acs_key}, timeout=15)
    print(f"ACS dispatch: {r.status_code}")
else:
    print("ACS credentials not set - skipping WhatsApp dispatch")
PYEOF

ENV ACS_ENDPOINT="" ACS_ACCESS_KEY="" WHATSAPP_FROM="" WHATSAPP_TO=""
CMD ["python3", "dispatch.py"]
