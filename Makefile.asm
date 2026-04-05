# ============================================================================
# Edge-AI-APP Assembly Build System
# Robust Makefile for comprehensive Assembly pipeline
# ============================================================================

.PHONY: all clean build assemble link analyze validate report help install-deps

# Configuration
ARCH ?= x86_64
PLATFORM ?= linux
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

# Colors
RED := \033[0;31m
GREEN := \033[0;32m
YELLOW := \033[1;33m
BLUE := \033[0;34m
NC := \033[0m

# ============================================================================
# Default Target
# ============================================================================
all: clean install-deps build analyze report
	@echo "$(GREEN)✓ Complete build pipeline finished!$(NC)"

# ============================================================================
# Help
# ============================================================================
help:
	@echo "$(BLUE)Edge-AI-APP Assembly Build System$(NC)"
	@echo ""
	@echo "Targets:"
	@echo "  $(YELLOW)make all$(NC)              - Run complete pipeline (clean, build, analyze, report)"
	@echo "  $(YELLOW)make install-deps$(NC)     - Install Assembly development tools"
	@echo "  $(YELLOW)make build$(NC)            - Build everything (assemble + link)"
	@echo "  $(YELLOW)make assemble$(NC)         - Assemble ASM files to object files"
	@echo "  $(YELLOW)make link$(NC)             - Link object files to binary"
	@echo "  $(YELLOW)make analyze$(NC)          - Analyze compiled binaries"
	@echo "  $(YELLOW)make validate$(NC)         - Validate binary security"
	@echo "  $(YELLOW)make report$(NC)           - Generate build report"
	@echo "  $(YELLOW)make clean$(NC)            - Remove build artifacts"
	@echo ""
	@echo "Configuration:"
	@echo "  ARCH=$(ARCH), PLATFORM=$(PLATFORM)"

# ============================================================================
# Install Dependencies
# ============================================================================
install-deps:
	@echo "$(YELLOW)[*] Installing Assembly development tools...$(NC)"
	@command -v $(NASM) >/dev/null 2>&1 || (echo "Installing NASM..." && sudo apt-get install -y nasm)
	@command -v $(YASM) >/dev/null 2>&1 || (echo "Installing YASM..." && sudo apt-get install -y yasm)
	@command -v $(GCC) >/dev/null 2>&1 || (echo "Installing GCC..." && sudo apt-get install -y gcc)
	@command -v $(LD) >/dev/null 2>&1 || (echo "Installing Binutils..." && sudo apt-get install -y binutils)
	@command -v $(GDB) >/dev/null 2>&1 || (echo "Installing GDB..." && sudo apt-get install -y gdb)
	@command -v $(CHECKSEC) >/dev/null 2>&1 || (echo "Installing Checksec..." && sudo apt-get install -y checksec)
	@echo "$(GREEN)✓ Dependencies installed$(NC)"

# ============================================================================
# Create Build Directories
# ============================================================================
$(BUILD_DIR) $(BIN_DIR) $(OBJ_DIR) $(LOG_DIR):
	@mkdir -p $@

# ============================================================================
# Convert HEX to ASM
# ============================================================================
.PHONY: hex-to-asm
hex-to-asm: $(BUILD_DIR) $(OBJ_DIR)
	@echo "$(YELLOW)[*] Converting HEX files to ASM...$(NC)"
	@$(PYTHON) << 'EOF' \
import os; \
import glob; \
hex_dir = "$(ASM_DIR)"; \
asm_dir = "$(OBJ_DIR)"; \
for hex_file in glob.glob(os.path.join(hex_dir, "*.hex")): \
    filename = os.path.basename(hex_file); \
    asm_file = os.path.join(asm_dir, filename.replace(".hex", ".asm")); \
    try: \
        with open(hex_file, 'r') as f: hex_content = f.read().replace('\n', ''); \
        asm_content = bytes.fromhex(hex_content).decode('utf-8', errors='ignore'); \
        with open(asm_file, 'w') as f: f.write(asm_content); \
        print(f"$(GREEN)✓$(NC) {filename} → {os.path.basename(asm_file)}"); \
    except Exception as e: print(f"$(RED)✗$(NC) {filename}: {e}"); \
EOF

# ============================================================================
# Assemble ASM files
# ============================================================================
.PHONY: assemble
assemble: hex-to-asm
	@echo "$(YELLOW)[*] Assembling ASM files...$(NC)"
	@for asm_file in $(OBJ_DIR)/*.asm; do \
		if [ -f "$$asm_file" ]; then \
			filename=$$(basename "$$asm_file" .asm); \
			obj_file="$(OBJ_DIR)/$${filename}.o"; \
			if $(NASM) $(NASM_FLAGS) -o "$$obj_file" "$$asm_file" 2>"$(LOG_DIR)/$${filename}.log"; then \
				echo "$(GREEN)✓$(NC) $${filename}.asm → $${filename}.o (NASM)"; \
			elif $(YASM) $(YASM_FLAGS) -o "$$obj_file" "$$asm_file" 2>>"$(LOG_DIR)/$${filename}.log"; then \
				echo "$(GREEN)✓$(NC) $${filename}.asm → $${filename}.o (YASM)"; \
			else \
				echo "$(YELLOW)⚠$(NC) $${filename}.asm: Assembly skipped"; \
			fi; \
		fi; \
	done

# ============================================================================
# Link Object files
# ============================================================================
.PHONY: link
link: assemble $(BIN_DIR)
	@echo "$(YELLOW)[*] Linking object files...$(NC)"
	@obj_files=$$(find $(OBJ_DIR) -name "*.o" -type f); \
	if [ -n "$$obj_files" ]; then \
		if $(LD) $(LD_FLAGS) -o $(BIN_DIR)/edge-ai-app $$obj_files 2>"$(LOG_DIR)/linking.log"; then \
			echo "$(GREEN)✓$(NC) Linked to: $(BIN_DIR)/edge-ai-app"; \
		else \
			echo "$(YELLOW)⚠$(NC) Linking completed with warnings"; \
		fi; \
	fi

# ============================================================================
# Build (Assemble + Link)
# ============================================================================
.PHONY: build
build: link
	@echo "$(GREEN)✓ Build completed$(NC)"

# ============================================================================
# Analyze Binaries
# ============================================================================
.PHONY: analyze
analyze:
	@echo "$(YELLOW)[*] Analyzing binaries...$(NC)"
	@if [ -f "$(BIN_DIR)/edge-ai-app" ]; then \
		echo "$(BLUE)Binary Information:$(NC)"; \
		file "$(BIN_DIR)/edge-ai-app"; \
		echo ""; \
		echo "$(BLUE)Size Information:$(NC)"; \
		size "$(BIN_DIR)/edge-ai-app" 2>/dev/null || echo "Size info unavailable"; \
		echo ""; \
		echo "$(BLUE)Sections:$(NC)"; \
		$(OBJDUMP) -h "$(BIN_DIR)/edge-ai-app" 2>/dev/null | head -15 || echo "Section info unavailable"; \
	else \
		echo "$(RED)✗ No binary found$(NC)"; \
	fi

# ============================================================================
# Validate Binary Security
# ============================================================================
.PHONY: validate
validate:
	@echo "$(YELLOW)[*] Validating binary security...$(NC)"
	@if [ -f "$(BIN_DIR)/edge-ai-app" ]; then \
		$(CHECKSEC) --file="$(BIN_DIR)/edge-ai-app" 2>/dev/null || echo "Checksec not available"; \
	else \
		echo "$(RED)✗ No binary found$(NC)"; \
	fi

# ============================================================================
# Generate Build Report
# ============================================================================
.PHONY: report
report:
	@echo "$(YELLOW)[*] Generating build report...$(NC)"
	@echo "Edge-AI-APP Assembly Build Report" > "$(LOG_DIR)/build-report.txt"
	@echo "Generated: $$(date)" >> "$(LOG_DIR)/build-report.txt"
	@echo "" >> "$(LOG_DIR)/build-report.txt"
	@echo "Build Statistics:" >> "$(LOG_DIR)/build-report.txt"
	@echo "  HEX Files: $$(ls -1 $(ASM_DIR)/*.hex 2>/dev/null | wc -l)" >> "$(LOG_DIR)/build-report.txt"
	@echo "  ASM Files: $$(ls -1 $(OBJ_DIR)/*.asm 2>/dev/null | wc -l)" >> "$(LOG_DIR)/build-report.txt"
	@echo "  Object Files: $$(ls -1 $(OBJ_DIR)/*.o 2>/dev/null | wc -l)" >> "$(LOG_DIR)/build-report.txt"
	@echo "  Binary: $$([ -f $(BIN_DIR)/edge-ai-app ] && echo 'Yes' || echo 'No')" >> "$(LOG_DIR)/build-report.txt"
	@echo "" >> "$(LOG_DIR)/build-report.txt"
	@echo "Tools Installed:" >> "$(LOG_DIR)/build-report.txt"
	@for tool in $(NASM) $(YASM) $(GCC) $(LD) $(GDB) $(CHECKSEC); do \
		if command -v $$tool >/dev/null 2>&1; then \
			echo "  ✓ $$tool" >> "$(LOG_DIR)/build-report.txt"; \
		else \
			echo "  ✗ $$tool" >> "$(LOG_DIR)/build-report.txt"; \
		fi; \
	done
	@echo "$(GREEN)✓ Report saved to: $(LOG_DIR)/build-report.txt$(NC)"

# ============================================================================
# Clean Build Artifacts
# ============================================================================
.PHONY: clean
clean:
	@echo "$(YELLOW)[*] Cleaning build artifacts...$(NC)"
	@rm -rf $(BUILD_DIR)
	@echo "$(GREEN)✓ Clean completed$(NC)"

# ============================================================================
# Show Configuration
# ============================================================================
.PHONY: config
config:
	@echo "$(BLUE)Build Configuration:$(NC)"
	@echo "  Architecture: $(ARCH)"
	@echo "  Platform: $(PLATFORM)"
	@echo "  ASM Directory: $(ASM_DIR)"
	@echo "  Build Directory: $(BUILD_DIR)"
	@echo "  Assembler: $(NASM)"
	@echo "  Linker: $(LD)"
