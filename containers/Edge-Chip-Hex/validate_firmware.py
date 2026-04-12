from __future__ import annotations

import glob
import hashlib
import json
import os

os.makedirs("firmware", exist_ok=True)
manifest: dict = {}

for hex_file in glob.glob(".ASM_HEX/*.hex"):
    try:
        with open(hex_file) as f:
            h = f.read().replace("\n", "").replace(" ", "").strip()
    except OSError as e:
        print(f"ERR {hex_file}: {e}")
        continue

    try:
        raw = bytes.fromhex(h)
        sha3 = hashlib.sha3_512(raw).hexdigest()
        name = os.path.basename(hex_file).replace(".hex", "")
    except ValueError as e:
        print(f"ERR {hex_file}: {e}")
        continue

    try:
        with open(f"firmware/{name}.bin", "wb") as bf:
            bf.write(raw)
        manifest[name] = {"sha3_512": sha3, "size": len(raw)}
        print(f"OK {name}  SHA3={sha3[:16]}...")
    except OSError as e:
        print(f"ERR {name}: cannot write bin: {e}")

try:
    with open("firmware/manifest.json", "w") as mf:
        json.dump(manifest, mf, indent=2)
    print(f"Manifest: {len(manifest)} entries")
except OSError as e:
    print(f"ERR manifest: {e}")
    print(f"Manifest: {len(manifest)} entries (not saved)")
