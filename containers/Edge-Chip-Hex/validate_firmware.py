import os, glob, hashlib, json

os.makedirs("firmware", exist_ok=True)
manifest = {}
for hex_file in glob.glob(".ASM_HEX/*.hex"):
    with open(hex_file) as f:
        h = f.read().replace("\n","").replace(" ","").strip()
    try:
        raw  = bytes.fromhex(h)
        sha3 = hashlib.sha3_512(raw).hexdigest()
        name = os.path.basename(hex_file).replace(".hex","")
        open(f"firmware/{name}.bin","wb").write(raw)
        manifest[name] = {"sha3_512": sha3, "size": len(raw)}
        print(f"OK {name}  SHA3={sha3[:16]}...")
    except Exception as e:
        print(f"ERR {hex_file}: {e}")
json.dump(manifest, open("firmware/manifest.json","w"), indent=2)
print(f"Manifest: {len(manifest)} entries")
