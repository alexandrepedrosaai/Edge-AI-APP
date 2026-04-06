import os
import glob
import sys
import io

# Forçar a saída do console para UTF-8 no Windows
if sys.platform == "win32":
    sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
    sys.stderr = io.TextIOWrapper(sys.stderr.buffer, encoding='utf-8')

def convert_hex_to_asm(hex_dir, asm_dir):
    print(f"[*] HEX source directory: {os.path.abspath(hex_dir)}")
    print(f"[*] ASM output directory: {os.path.abspath(asm_dir)}")
    
    os.makedirs(asm_dir, exist_ok=True)
    
    # Tentar encontrar arquivos .hex de forma recursiva e com extensões variadas
    hex_files = glob.glob(os.path.join(hex_dir, "*.hex")) + glob.glob(os.path.join(hex_dir, "*.HEX"))
    
    if not hex_files:
        print(f"[!] No .hex files found in {hex_dir}")
        # Listar o que existe no diretório para debug
        if os.path.exists(hex_dir):
            print(f"[*] Files in {hex_dir}: {os.listdir(hex_dir)}")
        else:
            print(f"[!] Directory {hex_dir} does not exist!")
        return

    print(f"[*] Found {len(hex_files)} HEX files to process.")

    for hex_file in hex_files:
        filename = os.path.basename(hex_file)
        # Gerar nome do arquivo ASM preservando a estrutura
        asm_filename = os.path.splitext(filename)[0] + ".asm"
        asm_file = os.path.join(asm_dir, asm_filename)
        
        try:
            # Abrir arquivo hex com codificação UTF-8 explícita
            with open(hex_file, 'r', encoding='utf-8', errors='ignore') as f:
                hex_content = f.read().strip().replace('\n', '').replace(' ', '')
            
            # Tentar converter hex para bytes e depois decodificar
            try:
                # Se o conteúdo for hex puro (0-9, A-F)
                asm_content = bytes.fromhex(hex_content).decode('utf-8', errors='ignore')
            except ValueError:
                # Se não for hex válido, talvez já seja o conteúdo final ou texto
                asm_content = hex_content
                
            # Salvar como ASM em UTF-8
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
