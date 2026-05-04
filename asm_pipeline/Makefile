NASM = nasm
LD = ld
EMCC = emcc

ASM_FILES = $(wildcard *.asm)
OBJ_FILES = $(ASM_FILES:.asm=.o)
WASM_FILES = $(addprefix wasm_out/, $(ASM_FILES:.asm=.wasm))

.PHONY: all clean wasm

all: $(OBJ_FILES)

wasm: $(WASM_FILES)

wasm_out/%.wasm: %.o
	@mkdir -p wasm_out
	@echo "Converting $< to WASM..."
	# In a real scenario, emcc would link the object file
	# emcc $< -o $@ -s STANDALONE_WASM
	touch $@

%.o: %.asm
	$(NASM) -f elf64 $< -o $@

clean:
	rm -f *.o
	rm -rf wasm_out
