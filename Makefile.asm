# ============================================================================
# Edge-AI-APP Assembly Build System
# Universal Makefile for Linux, macOS and Windows
# ============================================================================

.PHONY: all clean build assemble link install-deps

# Configuration
ARCH ?= x86_64
ASM_DIR := .ASM_HEX
BUILD_DIR := build
BIN_DIR := $(BUILD_DIR)/bin
OBJ_DIR := $(BUILD_DIR)/obj
LOG_DIR := $(BUILD_DIR)/logs

# Tools
NASM := nasm
LD := ld
PYTHON := python3

# Detect OS and set platform-specific commands
ifeq ($(OS),Windows_NT)
    PLATFORM := windows
    RM := del /Q /S
    MKDIR := mkdir
    NASM_FLAGS := -f win64
    LD_FLAGS := 
    EXE_EXT := .exe
    # No Windows, usamos o shell padrão (cmd)
    SHELL := cmd.exe
else
    PLATFORM := $(shell uname -s | tr '[:upper:]' '[:lower:]')
    RM := rm -rf
    MKDIR := mkdir -p
    EXE_EXT := 
    ifeq ($(PLATFORM),darwin)
        NASM_FLAGS := -f macho64
    else
        NASM_FLAGS := -f elf64
    endif
    LD_FLAGS := -e _start
endif

# ============================================================================
# Default Target
# ============================================================================
all: clean install-deps build

# ============================================================================
# Install Dependencies
# ============================================================================
install-deps:
	@echo Checking dependencies...

# ============================================================================
# Create Build Directories
# ============================================================================
$(BUILD_DIR) $(BIN_DIR) $(OBJ_DIR) $(LOG_DIR):
	-@$(MKDIR) $@ 2>nul || $(MKDIR) $@

# ============================================================================
# Convert HEX to ASM
# ============================================================================
.PHONY: hex-to-asm
hex-to-asm: | $(BUILD_DIR) $(OBJ_DIR)
	@echo Converting HEX files to ASM...
	@$(PYTHON) scripts/hex_to_asm.py "$(ASM_DIR)" "$(OBJ_DIR)"

# ============================================================================
# Assemble ASM files
# ============================================================================
.PHONY: assemble
assemble: hex-to-asm $(LOG_DIR)
	@echo Starting assembly phase...
	@# Usar um comando shell simples para compilar todos os .asm encontrados no OBJ_DIR
	@# Isso evita problemas com a expansão de variáveis do Make no Windows
	@for %%f in ($(OBJ_DIR)/*.asm) do ( \
		echo Assembling %%f... & \
		$(NASM) $(NASM_FLAGS) -o $(OBJ_DIR)/%%~nf.o %%f 2>$(LOG_DIR)/%%~nf.log \
	)
	@echo Assembly phase completed.

# ============================================================================
# Link Object files
# ============================================================================
.PHONY: link
link: assemble $(BIN_DIR)
	@echo Linking object files...
	@# No Windows, o comando para coletar arquivos .o e linkar
	@for /F %%f in ('dir /b $(OBJ_DIR)\*.o 2^>nul') do @set OBJS=!OBJS! $(OBJ_DIR)\%%f
	-@$(LD) $(LD_FLAGS) -o $(BIN_DIR)/edge-ai-app$(EXE_EXT) $(OBJ_DIR)/*.o 2>"$(LOG_DIR)/linking.log"
	@echo Linked to: $(BIN_DIR)/edge-ai-app$(EXE_EXT)

# ============================================================================
# Build
# ============================================================================
.PHONY: build
build: link
	@echo Build completed.

# ============================================================================
# Clean
# ============================================================================
.PHONY: clean
clean:
	@echo Cleaning build artifacts...
	-@$(RM) $(BUILD_DIR) 2>nul || $(RM) $(BUILD_DIR)
	@echo Clean completed.
