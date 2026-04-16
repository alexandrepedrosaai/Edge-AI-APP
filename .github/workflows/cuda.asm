name: CI/CD CUDA ASM
on: [push, pull_request, workflow_dispatch]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3
    - run: sudo apt-get update && sudo apt-get install -y nasm
    - run: |
        nasm -f elf src/ASM/cuda.asm -o cuda.o
        ld -m elf_i386 -s -o cuda cuda.o
    - uses: actions/upload-artifact@v3
      with:
        name: cuda-artifact
        path: cuda
    - uses: softprops/action-gh-release@v1
      with:
        tag_name: v${{ github.run_number }}
        files: cuda
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
