import os
import glob
import sys

def convert_hex_to_asm(hex_dir, asm_dir):
    print(f"[*] Converting HEX files from {hex_dir} to ASM in {asm_dir}...")
    os.makedirs(asm_dir, exist_ok=True)
    
    hex_files = glob.glob(os.path.join(hex_dir, "*.hex"))
    if not hex_files:
        print(f"[!] No .hex files found in {hex_dir}")
        return

    for hex_file in hex_files:
        filename = os.path.basename(hex_file)
        asm_file = os.path.join(asm_dir, filename.replace(".hex", ".asm"))
        
        try:
            with open(hex_file, 'r') as f:
                hex_content = f.read().strip().replace('\n', '').replace(' ', '')
            
            # Tentar converter hex para bytes e depois decodificar
            try:
                asm_content = bytes.fromhex(hex_content).decode('utf-8', errors='ignore')
            except ValueError:
                print(f"[-] {filename}: Invalid hex format, skipping.")
                continue
                
            with open(asm_file, 'w') as f:
                f.write(asm_content)
            
            print(f"[+] {filename} -> {os.path.basename(asm_file)}")
        except Exception as e:
            print(f"[!] Error processing {filename}: {e}")

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: python3 hex_to_asm.py <hex_dir> <asm_dir>")
        sys.exit(1)
    
    convert_hex_to_asm(sys.argv[1], sys.argv[2])
