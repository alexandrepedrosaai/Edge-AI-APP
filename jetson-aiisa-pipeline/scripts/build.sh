#!/bin/bash
set -e

echo "=== Jetson AI-ISA Build Script ==="

# Step 1: Clean previous builds
echo "Cleaning old build artifacts..."
rm -rf build
mkdir -p build

# Step 2: Compile Assembly + C++ wrapper
echo "Compiling sources..."
g++ -c src/asm/pipeline.s -o build/pipeline.o
g++ -c src/cpp/wrapper.cpp -o build/wrapper.o
g++ build/pipeline.o build/wrapper.o -o build/pipeline_exec

# Step 4: Package artifacts
echo "Packaging binaries..."
tar -czf build/release.tar.gz build/pipeline_exec

echo "✅ Build completed successfully!"
