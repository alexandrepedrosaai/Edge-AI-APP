from __future__ import annotations

import glob
import os

import requests

print("=== Edge-CNN+MLP.AI - xAI Grok Analysis ===")

files = glob.glob("obj/*.asm")
print(f"Decoded Assembly files: {len(files)}")

if not files:
    print("No obj/*.asm files found - nothing to analyse")
else:
    api_key = os.getenv("XAI_API_KEY", "")

    if not api_key:
        print("XAI_API_KEY not set - skipping live analysis")
        for f in files[:5]:
            print(f"  - {os.path.basename(f)}")
    else:
        for f in files[:3]:
            try:
                with open(f) as fh:
                    content = fh.read(500)
            except OSError as e:
                print(f"ERR {os.path.basename(f)}: {e}")
                continue

            try:
                r = requests.post(
                    "https://api.x.ai/v1/chat/completions",
                    headers={"Authorization": f"Bearer {api_key}", "Content-Type": "application/json"},
                    json={
                        "model": "grok-3-mini",
                        "messages": [{"role": "user", "content": f"Describe this Assembly:\n{content}"}],
                        "max_tokens": 120,
                    },
                    timeout=30,
                )
            except requests.RequestException as e:
                print(f"ERR {os.path.basename(f)}: network error: {e}")
                continue

            if not r.ok:
                print(f"ERR {os.path.basename(f)}: HTTP {r.status_code} (ignored)")
                continue

            try:
                result = r.json()["choices"][0]["message"]["content"]
                print(f"\n--- {os.path.basename(f)} ---")
                print(result)
            except (KeyError, IndexError, ValueError) as e:
                print(f"ERR {os.path.basename(f)}: unexpected response: {e}")
