# Edge-AI-APP Assembly Build Pipeline

Complete documentation for the robust Assembly development and build system.

## Overview

The Edge-AI-APP Assembly Pipeline provides a comprehensive system for:

- **Assembling** HEX-encoded Assembly files to object files
- **Linking** object files into executable binaries
- **Analyzing** compiled binaries for security and structure
- **Validating** binary integrity and security properties
- **Reporting** build statistics and diagnostics

## Installed Tools

### Assemblers

| Tool | Version | Purpose |
|------|---------|---------|
| **NASM** | 2.15.05 | Netwide Assembler - primary assembler for x86/x86-64 |
| **YASM** | 1.3.0 | Yet Another Assembler - alternative with improved compatibility |

### Compilers & Linkers

| Tool | Version | Purpose |
|------|---------|---------|
| **GCC** | 11.4.0 | GNU C Compiler - C/C++ compilation |
| **Clang** | 14.0.0 | LLVM C/C++ compiler - modern compiler frontend |
| **LD** | GNU ld | GNU Linker - object file linking |
| **LLD** | 14.0 | LLVM Linker - modern linking alternative |

### Debuggers & Analysis Tools

| Tool | Purpose |
|------|---------|
| **GDB** | GNU Debugger - interactive debugging |
| **LLDB** | LLVM Debugger - modern debugging alternative |
| **Objdump** | Binary analysis and disassembly |
| **Readelf** | ELF file analysis |
| **Checksec** | Binary security property validation |
| **Strace** | System call tracing |
| **Ltrace** | Library call tracing |
| **Valgrind** | Memory debugging and profiling |

## Build System

### Using Makefile

The `Makefile.asm` provides a complete build system with multiple targets:

```bash
# Show all available targets
make -f Makefile.asm help

# Install dependencies
make -f Makefile.asm install-deps

# Run complete pipeline
make -f Makefile.asm all

# Build only (assemble + link)
make -f Makefile.asm build

# Assemble ASM files
make -f Makefile.asm assemble

# Link object files
make -f Makefile.asm link

# Analyze binaries
make -f Makefile.asm analyze

# Validate security
make -f Makefile.asm validate

# Generate report
make -f Makefile.asm report

# Clean build artifacts
make -f Makefile.asm clean
```

### Using Build Script

The `build-assembly.sh` script provides an automated pipeline:

```bash
# Make script executable
chmod +x build-assembly.sh

# Run with default settings (x86_64, linux)
./build-assembly.sh

# Run with custom architecture
./build-assembly.sh x86_64 linux

# Run with ARM architecture
./build-assembly.sh arm linux
```

## Build Directory Structure

After building, the following structure is created:

```
build/
├── bin/
│   └── edge-ai-app          # Final executable binary
├── obj/
│   ├── *.asm                # Converted ASM files
│   └── *.o                  # Object files
└── logs/
    ├── *.log                # Assembly logs per file
    ├── linking.log          # Linker output
    └── build-report.txt     # Build summary report
```

## Workflow

### 1. HEX to ASM Conversion

The pipeline automatically converts HEX-encoded files back to ASM:

```bash
# Manual conversion
python3 << 'EOF'
with open('file.hex', 'r') as f:
    hex_content = f.read().replace('\n', '')
asm_content = bytes.fromhex(hex_content).decode('utf-8')
with open('file.asm', 'w') as f:
    f.write(asm_content)
EOF
```

### 2. Assembly

Convert ASM files to object files:

```bash
# Using NASM (primary)
nasm -f elf64 -o output.o input.asm

# Using YASM (fallback)
yasm -f elf64 -o output.o input.asm
```

### 3. Linking

Link object files into executable:

```bash
ld -e _start -o edge-ai-app *.o
```

### 4. Analysis

Analyze compiled binaries:

```bash
# File information
file edge-ai-app

# Binary size
size edge-ai-app

# Section information
objdump -h edge-ai-app

# Symbol table
readelf -s edge-ai-app

# Disassembly
objdump -d edge-ai-app
```

### 5. Validation

Validate binary security:

```bash
# Security properties
checksec --file=edge-ai-app

# Memory analysis
valgrind ./edge-ai-app

# System calls
strace ./edge-ai-app
```

## Configuration

### Environment Variables

```bash
# Set architecture
export ARCH=x86_64

# Set platform
export PLATFORM=linux

# Set custom build directory
export BUILD_DIR=custom_build
```

### Makefile Variables

```bash
# Override in command line
make -f Makefile.asm ARCH=arm PLATFORM=linux build

# Or in Makefile.asm
ARCH ?= x86_64
PLATFORM ?= linux
```

## Examples

### Example 1: Complete Build Pipeline

```bash
# Navigate to repository
cd /home/ubuntu/Edge-AI-APP

# Run complete pipeline
make -f Makefile.asm all

# Check results
ls -la build/bin/
cat build/logs/build-report.txt
```

### Example 2: Debug Assembly

```bash
# Assemble with debug symbols
nasm -f elf64 -g -o debug.o input.asm

# Link with debug symbols
ld -o debug_binary debug.o

# Debug with GDB
gdb ./debug_binary
```

### Example 3: Security Analysis

```bash
# Check security properties
checksec --file=edge-ai-app

# Analyze with Valgrind
valgrind --leak-check=full ./edge-ai-app

# Trace system calls
strace -e trace=all ./edge-ai-app
```

### Example 4: Binary Analysis

```bash
# Disassemble binary
objdump -d edge-ai-app | less

# View sections
readelf -S edge-ai-app

# Extract symbols
nm edge-ai-app

# View headers
readelf -h edge-ai-app
```

## Troubleshooting

### Assembly Errors

**Problem**: "Error: unknown directive" in NASM

**Solution**: Check syntax compatibility. NASM uses different syntax than GAS.

```bash
# Convert GAS syntax to NASM
# GAS: movl $0, %eax
# NASM: mov eax, 0
```

### Linking Errors

**Problem**: "undefined reference to '_start'"

**Solution**: Ensure entry point is defined:

```asm
global _start
_start:
    ; code here
```

### Missing Tools

**Problem**: "command not found: nasm"

**Solution**: Install tools:

```bash
sudo apt-get install nasm yasm binutils gcc gdb checksec
```

## Performance Optimization

### Compiler Optimization

```bash
# Enable optimization
gcc -O2 -c source.c -o output.o

# Maximum optimization
gcc -O3 -c source.c -o output.o
```

### Linker Optimization

```bash
# Strip symbols for smaller binary
strip edge-ai-app

# Link with optimization
ld -O2 -o edge-ai-app *.o
```

## Security Best Practices

### Binary Hardening

```bash
# Check security features
checksec --file=edge-ai-app

# Enable ASLR
echo 2 | sudo tee /proc/sys/kernel/randomize_va_space

# Verify NX bit
readelf -l edge-ai-app | grep GNU_STACK
```

### Memory Safety

```bash
# Run with Valgrind
valgrind --leak-check=full --show-leak-kinds=all ./edge-ai-app

# Check for buffer overflows
valgrind --tool=memcheck ./edge-ai-app
```

## Continuous Integration

### GitHub Actions Integration

Create `.github/workflows/assembly-build.yml`:

```yaml
name: Assembly Build Pipeline

on: [push, pull_request]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Install dependencies
        run: sudo apt-get install -y nasm yasm binutils gcc gdb checksec
      - name: Build
        run: make -f Makefile.asm all
      - name: Upload artifacts
        uses: actions/upload-artifact@v3
        with:
          name: build-artifacts
          path: build/
```

## References

- [NASM Documentation](https://www.nasm.us/doc/)
- [YASM Documentation](https://yasm.tortall.net/documentation.html)
- [GDB Documentation](https://sourceware.org/gdb/documentation/)
- [GNU Binutils](https://sourceware.org/binutils/docs/)
- [Checksec Documentation](https://github.com/slimm609/checksec.sh)

## Support

For issues or questions:

1. Check the build logs in `build/logs/`
2. Review the build report in `build/logs/build-report.txt`
3. Enable verbose output: `make -f Makefile.asm build V=1`
4. Check individual tool documentation

---

**Last Updated**: 2026-02-20  
**Version**: 1.0  
**Maintainer**: Edge-AI-APP Team
