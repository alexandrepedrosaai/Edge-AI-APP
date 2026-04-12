# Edge-Chip-Hex | Hex firmware + Azure ACS / WhatsApp
# Decodes hex chip firmware, validates SHA3-512, dispatches via Azure ACS WhatsApp
# Author: Alexandre Pedrosa - EVP Multimodal AI Engineer (Meta / Microsoft Azure)

FROM python:3.11-slim AS hex-validator
LABEL container="Edge-Chip-Hex" combination="hex+azure-acs+whatsapp"
LABEL org.opencontainers.image.source="https://github.com/alexandrepedrosaai/Edge-AI-APP"
LABEL org.opencontainers.image.description="Edge-Chip-Hex: hex firmware + Azure ACS + WhatsApp"

RUN pip install --no-cache-dir cryptography

WORKDIR /chip
COPY .ASM_HEX/ ./.ASM_HEX/
COPY containers/Edge-Chip-Hex/validate_firmware.py ./validate_firmware.py
RUN python3 validate_firmware.py

FROM python:3.11-slim AS runtime
LABEL container="Edge-Chip-Hex"
LABEL org.opencontainers.image.source="https://github.com/alexandrepedrosaai/Edge-AI-APP"

RUN pip install --no-cache-dir requests

WORKDIR /app
COPY --from=hex-validator /chip/firmware/ ./firmware/
COPY containers/Edge-Chip-Hex/dispatch.py ./dispatch.py

ENV ACS_ENDPOINT="" ACS_ACCESS_KEY="" WHATSAPP_FROM="" WHATSAPP_TO=""
CMD ["python3", "dispatch.py"]
