#!/bin/bash
set -e

echo "=== Crowley Copilot Build Script ==="

# Step 1: Clean previous builds
echo "Cleaning old build artifacts..."
rm -rf build
mkdir build

# Step 2: Compile Assembly + C++ wrapper
echo "Compiling sources..."
g++ -c pipeline.S -o build/pipeline.o
g++ -c wrapper.cpp -o build/wrapper.o
g++ build/pipeline.o build/wrapper.o -o build/pipeline_exec

# Step 3: Run unit tests
echo "Running unit tests..."
./tests/run_tests.sh

# Step 4: Package artifacts
echo "Packaging binaries..."
tar -czf build/release.tar.gz build/pipeline_exec

echo "✅ Build completed successfully!"
