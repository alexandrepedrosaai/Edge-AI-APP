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
        r = requests.post(
            "https://api.x.ai/v1/chat/completions",
            headers={"Authorization": f"Bearer {api_key}", "Content-Type": "application/json"},
            json={"model": "grok-3-mini",
                  "messages": [{"role": "user", "content": f"Describe this Assembly:\n{content}"}],
                  "max_tokens": 120},
            timeout=30)
        if r.ok:
            print(f"\n--- {os.path.basename(f)} ---")
            print(r.json()["choices"][0]["message"]["content"])
