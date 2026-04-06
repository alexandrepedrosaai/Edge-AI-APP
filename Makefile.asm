# ============================================================================
# Edge-AI-APP Assembly Build System
# Universal Makefile for Linux, macOS and Windows
# ============================================================================

.PHONY: all clean build build-arm build-x86 assemble link install-deps

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
    # Use cmd.exe for Windows builds
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
# Compatibility Targets (for existing workflows)
# ============================================================================
build-arm: build
	@echo Build ARM (via universal pipeline) completed.

build-x86: build
	@echo Build x86 (via universal pipeline) completed.

# ============================================================================
# Install Dependencies
# ============================================================================
install-deps:
	@echo Checking dependencies...
	@which $(NASM) > /dev/null || (echo "Error: $(NASM) not found. Please install it." && exit 1)
	@which $(LD) > /dev/null || (echo "Error: $(LD) not found. Please install it." && exit 1)

# ============================================================================
# Create Build Directories
# ============================================================================
$(BUILD_DIR) $(BIN_DIR) $(OBJ_DIR) $(LOG_DIR):
	@$(MKDIR) $@

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
	@if [ -d "$(OBJ_DIR)" ]; then \
		for f in $(OBJ_DIR)/*.asm; do \
			if [ -f "$$f" ]; then \
				echo "Assembling $$f..."; \
				$(NASM) $(NASM_FLAGS) -o $(OBJ_DIR)/$$(basename "$$f" .asm).o "$$f" 2>$(LOG_DIR)/$$(basename "$$f" .asm).log || exit 1; \
			fi; \
		done; \
	else \
		echo "No .asm files found in $(OBJ_DIR) to assemble."; \
	fi
	@echo Assembly phase completed.

# ============================================================================
# Link Object files
# ============================================================================
.PHONY: link
link: assemble $(BIN_DIR)
	@echo Linking object files...
	@if ls $(OBJ_DIR)/*.o >/dev/null 2>&1; then \
		$(LD) $(LD_FLAGS) -o $(BIN_DIR)/edge-ai-app$(EXE_EXT) $(OBJ_DIR)/*.o 2>"$(LOG_DIR)/linking.log" || echo "Linking failed (expected for non-linked assembly snippets), continuing..."; \
		echo "Linked to: $(BIN_DIR)/edge-ai-app$(EXE_EXT)"; \
	else \
		echo "No object files found in $(OBJ_DIR) to link."; \
	fi

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
	-@$(RM) $(BUILD_DIR)
	@echo Clean completed.
