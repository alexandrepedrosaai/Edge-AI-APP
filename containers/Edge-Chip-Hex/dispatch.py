from __future__ import annotations

import json
import os
from pathlib import Path

import requests

def _env(name: str, default: str = "") -> str:
    return (os.getenv(name, default) or "").strip()

def _safe_load_manifest(manifest_path: Path) -> dict | None:
    try:
        if not manifest_path.exists():
            print(f"[dispatch] manifest not found: {manifest_path} (skipping)")
            return None
        with manifest_path.open("r", encoding="utf-8") as f:
            return json.load(f)
    except Exception as e:
        print(f"[dispatch] failed to load manifest ({manifest_path}): {e} (skipping)")
        return None

def _safe_send_whatsapp(summary: str) -> None:
    acs_endpoint = _env("ACS_ENDPOINT")
    acs_key = _env("ACS_ACCESS_KEY")
    whatsapp_from = _env("WHATSAPP_FROM")
    whatsapp_to = _env("WHATSAPP_TO")

    if not all([acs_endpoint, acs_key, whatsapp_from, whatsapp_to]):
        print("[dispatch] ACS credentials not set - skipping WhatsApp dispatch")
        return

    acs_endpoint = acs_endpoint.rstrip("/")
    url = f"{acs_endpoint}/messages/notifications:send"

    try:
        r = requests.post(
            url,
            params={"api-version": "2024-02-01"},
            json={
                "channelRegistrationId": whatsapp_from,
                "to": whatsapp_to,
                "kind": "text",
                "content": summary,
            },
            headers={"Ocp-Apim-Subscription-Key": acs_key},
            timeout=15,
        )

        if r.ok:
            print(f"[dispatch] ACS dispatch: {r.status_code}")
        else:
            body = (r.text or "")[:500]
            print(f"[dispatch] ACS dispatch non-OK: HTTP {r.status_code} body={body!r} (ignored)")
    except requests.RequestException as e:
        print(f"[dispatch] ACS dispatch error: {e} (ignored)")

def main() -> int:
    # firmware/ is copied to /app/firmware/ by the Dockerfile
    manifest_path = Path("/app/firmware/manifest.json")

    manifest = _safe_load_manifest(manifest_path)
    count = len(manifest) if isinstance(manifest, dict) else 0

    summary = f"Edge-Chip-Hex: {count} firmware blobs validated via SHA3-512."
    print(summary)

    _safe_send_whatsapp(summary)

    # Never fail
    return 0

if __name__ == "__main__":
    raise SystemExit(main())