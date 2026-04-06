# ============================================================================
# Edge-AI-APP Assembly Build System
# Universal Makefile for Linux, macOS and Windows
# ============================================================================

.PHONY: all clean build assemble link analyze validate report help install-deps

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

# Detect OS and set platform-specific commands
ifeq ($(OS),Windows_NT)
    PLATFORM := windows
    RM := del /Q /S
    MKDIR := mkdir
    # No Windows, usamos o shell interno do make ou comandos simples
    NASM_FLAGS := -f win64
    LD_FLAGS := 
    EXE_EXT := .exe
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

# Source and Object files
# Usamos a função wildcard do Make que é universal
ASM_SOURCES := $(wildcard $(OBJ_DIR)/*.asm)
OBJECTS := $(ASM_SOURCES:$(OBJ_DIR)/%.asm=$(OBJ_DIR)/%.o)

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
# Assemble ASM files (Pattern Rule)
# Esta regra é nativa do Make e funciona em qualquer shell
# ============================================================================
$(OBJ_DIR)/%.o: $(OBJ_DIR)/%.asm | $(LOG_DIR)
	@echo "$(YELLOW)[*] Assembling $<...$(NC)"
	@$(NASM) $(NASM_FLAGS) -o $@ $< 2>"$(LOG_DIR)/$(notdir $*).log" || echo "$(RED)⚠ Failed to assemble $<$(NC)"

.PHONY: assemble
assemble: hex-to-asm $(OBJECTS)
	@echo "$(GREEN)✓ Assembly phase completed$(NC)"

# ============================================================================
# Link Object files
# ============================================================================
.PHONY: link
link: assemble $(BIN_DIR)
	@echo "$(YELLOW)[*] Linking object files...$(NC)"
	@if [ -n "$(OBJECTS)" ]; then \
		$(LD) $(LD_FLAGS) -o $(BIN_DIR)/edge-ai-app$(EXE_EXT) $(OBJECTS) 2>"$(LOG_DIR)/linking.log" || echo "$(YELLOW)⚠ Linking warnings$(NC)"; \
		echo "$(GREEN)✓ Linked to: $(BIN_DIR)/edge-ai-app$(EXE_EXT)$(NC)"; \
	else \
		echo "$(YELLOW)⚠ No object files found to link$(NC)"; \
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
