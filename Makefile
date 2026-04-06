# ============================================================================
# Edge-AI-APP Main Build System
# Proxy to Makefile.asm for CI-CD Opcode Pipeline
# ============================================================================

.PHONY: all build clean help install-deps build-x86 build-arm build-riscv

all:
	@$(MAKE) -f Makefile.asm all

build:
	@$(MAKE) -f Makefile.asm build

build-x86:
	@$(MAKE) -f Makefile.asm build-x86

build-arm:
	@$(MAKE) -f Makefile.asm build-arm

build-riscv:
	@$(MAKE) -f Makefile.asm build-riscv

clean:
	@$(MAKE) -f Makefile.asm clean

install-deps:
	@$(MAKE) -f Makefile.asm install-deps

help:
	@$(MAKE) -f Makefile.asm help
