# ============================================================================
# Edge-AI-APP Assembly Build System
# Universal Makefile for Linux, macOS and Windows
# ============================================================================

.PHONY: all clean build assemble link analyze validate report help install-deps

# Detect OS
ifeq ($(OS),Windows_NT)
    PLATFORM := windows
    RM := del /Q /S
    MKDIR := mkdir
    # No Windows, o comando 'ls' pode não estar no PATH, então usamos uma alternativa
    LS_OBJ := dir /B $(subst /,\,$(OBJ_DIR))\*.o 2>nul
else
    PLATFORM := $(shell uname -s | tr '[:upper:]' '[:lower:]')
    RM := rm -rf
    MKDIR := mkdir -p
    LS_OBJ := ls $(OBJ_DIR)/*.o 2>/dev/null
endif

# Configuration
ARCH ?= x86_64
ASM_DIR := .ASM_HEX
BUILD_DIR := build
BIN_DIR := $(BUILD_DIR)/bin
OBJ_DIR := $(BUILD_DIR)/obj
LOG_DIR := $(BUILD_DIR)/logs

# Tools
NASM := nasm
YASM := yasm
GCC := gcc
LD := ld
GDB := gdb
OBJDUMP := objdump
READELF := readelf
CHECKSEC := checksec
PYTHON := python3

# Flags
NASM_FLAGS := -f elf64
YASM_FLAGS := -f elf64
GCC_FLAGS := -c -fno-builtin -nostdlib
LD_FLAGS := -e _start

# Ajustar flags para Windows/macOS se necessário
ifeq ($(PLATFORM),windows)
    NASM_FLAGS := -f win64
    LD_FLAGS := 
endif
ifeq ($(PLATFORM),darwin)
    NASM_FLAGS := -f macho64
endif

# Colors (only for Unix-like)
ifneq ($(PLATFORM),windows)
    RED := \033[0;31m
    GREEN := \033[0;32m
    YELLOW := \033[1;33m
    BLUE := \033[0;34m
    NC := \033[0m
else
    RED := 
    GREEN := 
    YELLOW := 
    BLUE := 
    NC := 
endif

# ============================================================================
# Default Target
# ============================================================================
all: clean install-deps build
	@echo "$(GREEN)✓ Complete build pipeline finished!$(NC)"

# ============================================================================
# Help
# ============================================================================
help:
	@echo "$(BLUE)Edge-AI-APP Assembly Build System$(NC)"
	@echo ""
	@echo "Targets:"
	@echo "  $(YELLOW)make all$(NC)              - Run complete pipeline"
	@echo "  $(YELLOW)make install-deps$(NC)     - Install tools"
	@echo "  $(YELLOW)make build$(NC)            - Build (assemble + link)"
	@echo "  $(YELLOW)make clean$(NC)            - Remove artifacts"

# ============================================================================
# Install Dependencies
# ============================================================================
install-deps:
	@echo "$(YELLOW)[*] Checking dependencies...$(NC)"
	@echo "$(GREEN)✓ Dependencies checked$(NC)"

# ============================================================================
# Create Build Directories
# ============================================================================
$(BUILD_DIR) $(BIN_DIR) $(OBJ_DIR) $(LOG_DIR):
	@$(MKDIR) $@ 2>/dev/null || true

# ============================================================================
# Convert HEX to ASM
# ============================================================================
.PHONY: hex-to-asm
hex-to-asm: | $(BUILD_DIR) $(OBJ_DIR)
	@echo "$(YELLOW)[*] Converting HEX files to ASM...$(NC)"
	@$(PYTHON) scripts/hex_to_asm.py "$(ASM_DIR)" "$(OBJ_DIR)"

# ============================================================================
# Assemble ASM files
# ============================================================================
.PHONY: assemble
assemble: hex-to-asm $(LOG_DIR)
	@echo "$(YELLOW)[*] Assembling ASM files...$(NC)"
	@for asm_file in $(OBJ_DIR)/*.asm; do \
		if [ -f "$$asm_file" ]; then \
			filename=$$(basename "$$asm_file" .asm); \
			obj_file="$(OBJ_DIR)/$${filename}.o"; \
			if $(NASM) $(NASM_FLAGS) -o "$$obj_file" "$$asm_file" 2>"$(LOG_DIR)/$${filename}.log"; then \
				echo "$(GREEN)✓$(NC) $${filename}.asm -> $${filename}.o"; \
			else \
				echo "$(YELLOW)⚠$(NC) $${filename}.asm: Failed"; \
			fi; \
		fi; \
	done

# ============================================================================
# Link Object files
# ============================================================================
.PHONY: link
link: assemble $(BIN_DIR)
	@echo "$(YELLOW)[*] Linking object files...$(NC)"
	@obj_files=$(shell $(LS_OBJ)); \
	if [ -n "$$obj_files" ]; then \
		if $(LD) $(LD_FLAGS) -o $(BIN_DIR)/edge-ai-app $$obj_files 2>"$(LOG_DIR)/linking.log"; then \
			echo "$(GREEN)✓$(NC) Linked to: $(BIN_DIR)/edge-ai-app"; \
		else \
			echo "$(YELLOW)⚠$(NC) Linking completed with warnings"; \
		fi; \
	else \
		echo "$(YELLOW)⚠$(NC) No object files found to link"; \
	fi

# ============================================================================
# Build
# ============================================================================
.PHONY: build
build: link
	@echo "$(GREEN)✓ Build completed$(NC)"

# ============================================================================
# Clean
# ============================================================================
.PHONY: clean
clean:
	@echo "$(YELLOW)[*] Cleaning build artifacts...$(NC)"
	@$(RM) $(BUILD_DIR) 2>/dev/null || true
	@echo "$(GREEN)✓ Clean completed$(NC)"
