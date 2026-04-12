# ============================================================================
# Edge-AI-APP Main Build System
# Proxy to Makefile.asm for CI-CD Opcode Pipeline
# ============================================================================

.PHONY: all build clean help install-deps build-x86 build-arm build-riscv

all:
	@$(MAKE) -f Makefile.asm all

build:
	@$(MAKE) -f Makefile.asm build

clean:
	@$(MAKE) -f Makefile.asm clean

install-deps:
	@$(MAKE) -f Makefile.asm install-deps

help:
	@$(MAKE) -f Makefile.asm help

# ============================================================================
# Multi-ISA Build Targets (used by CI-CD Multi-OS Multi-ISA Binary Releases)
# Uses Python for cross-platform compatibility (Linux, macOS, Windows).
# ============================================================================

build-x86:
	python -c "import os; os.makedirs('build/x86', exist_ok=True); f = open('build/x86/bin', 'w'); f.write('x86 stub binary\n'); f.close()"
	@echo "Built x86 stub binary -> build/x86/bin"

build-arm:
	python -c "import os; os.makedirs('build/arm', exist_ok=True); f = open('build/arm/bin', 'w'); f.write('arm stub binary\n'); f.close()"
	@echo "Built arm stub binary -> build/arm/bin"

build-riscv:
	python -c "import os; os.makedirs('build/riscv', exist_ok=True); f = open('build/riscv/bin', 'w'); f.write('riscv stub binary\n'); f.close()"
	@echo "Built riscv stub binary -> build/riscv/bin"
