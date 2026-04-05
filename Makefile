# ============================================================================
# Edge-AI-APP Main Build System
# Proxy to Makefile.asm for CI-CD Opcode Pipeline
# ============================================================================

.PHONY: all build clean help install-deps

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
