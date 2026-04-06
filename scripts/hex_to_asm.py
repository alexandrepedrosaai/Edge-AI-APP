import os
import glob
import sys
import io

# Forçar a saída do console para UTF-8 no Windows
if sys.platform == "win32":
    sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
    sys.stderr = io.TextIOWrapper(sys.stderr.buffer, encoding='utf-8')

def convert_hex_to_asm(hex_dir, asm_dir):
    # Resolver caminhos absolutos para evitar problemas com diretórios relativos no Windows
    abs_hex_dir = os.path.abspath(hex_dir)
    abs_asm_dir = os.path.abspath(asm_dir)
    
    print(f"[*] HEX source directory (resolved): {abs_hex_dir}")
    print(f"[*] ASM output directory (resolved): {abs_asm_dir}")
    
    os.makedirs(abs_asm_dir, exist_ok=True)
    
    # Tentar encontrar arquivos .hex de forma resiliente
    # No Windows, glob.glob pode ter problemas com diretórios ocultos se não for absoluto
    patterns = [
        os.path.join(abs_hex_dir, "*.hex"),
        os.path.join(abs_hex_dir, "*.HEX"),
        os.path.join(hex_dir, "*.hex"),
        os.path.join(hex_dir, "*.HEX")
    ]
    
    hex_files = []
    for pattern in patterns:
        hex_files.extend(glob.glob(pattern))
    
    # Remover duplicatas mantendo a ordem
    hex_files = list(dict.fromkeys(hex_files))
    
    if not hex_files:
        print(f"[!] No .hex files found.")
        # Debug: Listar o que existe no diretório pai se o alvo não existir
        parent_dir = os.path.dirname(abs_hex_dir)
        if os.path.exists(parent_dir):
            print(f"[*] Parent directory contents: {os.listdir(parent_dir)}")
        return

    print(f"[*] Found {len(hex_files)} HEX files to process.")

    for hex_file in hex_files:
        filename = os.path.basename(hex_file)
        asm_filename = os.path.splitext(filename)[0] + ".asm"
        asm_file = os.path.join(abs_asm_dir, asm_filename)
        
        try:
            with open(hex_file, 'r', encoding='utf-8', errors='ignore') as f:
                hex_content = f.read().strip().replace('\n', '').replace(' ', '')
            
            try:
                asm_content = bytes.fromhex(hex_content).decode('utf-8', errors='ignore')
            except ValueError:
                asm_content = hex_content
                
            with open(asm_file, 'w', encoding='utf-8') as f:
                f.write(asm_content)
            
            print(f"[+] {filename} -> {asm_filename}")
        except Exception as e:
            print(f"[!] Error processing {filename}: {repr(e)}")

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: python3 hex_to_asm.py <hex_dir> <asm_dir>")
        sys.exit(1)
    
    convert_hex_to_asm(sys.argv[1], sys.argv[2])
