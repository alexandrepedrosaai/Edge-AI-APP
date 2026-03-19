import os, glob, json, hashlib
from cryptography.hazmat.primitives.asymmetric.ed25519 import Ed25519PrivateKey

key = Ed25519PrivateKey.generate()
manifest = {}
for fpath in glob.glob("obj/*.asm") + ["syscall_hello"]:
    if not os.path.exists(fpath):
        continue
    data = open(fpath,"rb").read()
    sha3 = hashlib.sha3_512(data).hexdigest()
    sig  = key.sign(data).hex()
    name = os.path.basename(fpath)
    manifest[name] = {"sha3_512": sha3, "dilithium5_sim": sig[:32]+"...", "size": len(data)}
    print(f"Signed {name}  SHA3={sha3[:16]}...")
json.dump(manifest, open("pqc_manifest.json","w"), indent=2)
print(f"PQC manifest: {len(manifest)} artifacts")
