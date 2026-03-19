import os, glob

os.makedirs("decoded", exist_ok=True)
files = glob.glob(".ASM_HEX/*MLP*") + glob.glob(".ASM_HEX/*CNN*") + glob.glob(".ASM_HEX/*Hybrid*")
if not files:
    files = glob.glob(".ASM_HEX/*.hex")[:10]
for hex_file in files:
    with open(hex_file) as f:
        h = f.read().replace("\n","").replace(" ","").strip()
    try:
        content = bytes.fromhex(h).decode("utf-8", errors="replace")
        out = "decoded/" + os.path.basename(hex_file).replace(".hex",".asm")
        open(out,"w").write(content)
        print("OK", os.path.basename(hex_file))
    except Exception as e:
        print("ERR", hex_file, e)
