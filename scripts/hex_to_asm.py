import os
import glob
import sys
import io

# Forçar a saída do console para UTF-8 no Windows
if sys.platform == "win32":
    sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
    sys.stderr = io.TextIOWrapper(sys.stderr.buffer, encoding='utf-8')

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
            # Abrir arquivo hex com codificação UTF-8 explícita
            with open(hex_file, 'r', encoding='utf-8', errors='ignore') as f:
                hex_content = f.read().strip().replace('\n', '').replace(' ', '')
            
            # Tentar converter hex para bytes e depois decodificar
            try:
                # Se o conteúdo já for hex puro (0-9, A-F)
                asm_content = bytes.fromhex(hex_content).decode('utf-8', errors='ignore')
            except ValueError:
                # Se não for hex válido, talvez já seja o conteúdo final
                asm_content = hex_content
                
            # Salvar como ASM em UTF-8
            with open(asm_file, 'w', encoding='utf-8') as f:
                f.write(asm_content)
            
            print(f"[+] {filename} -> {os.path.basename(asm_file)}")
        except Exception as e:
            # Usar repr(e) para evitar problemas de encode ao imprimir a exceção
            print(f"[!] Error processing {filename}: {repr(e)}")

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: python3 hex_to_asm.py <hex_dir> <asm_dir>")
        sys.exit(1)
    
    convert_hex_to_asm(sys.argv[1], sys.argv[2])
