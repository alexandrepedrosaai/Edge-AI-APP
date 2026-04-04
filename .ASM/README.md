# .ASM — Conceptual Pseudocode Collection

> **Note:** These files contain **conceptual/pseudocode** representations of neural-network and chip-architecture routines. They use a pseudo-ISA invented for this project (Hub CPU, Spiral CPU, Resonance CPU) and are **not intended to be assembled** by any real assembler (e.g. NASM, GAS, Motorola 68k). They are documentation artifacts extracted from GitHub Releases.

Esta pasta contém pseudocódigos conceituais extraídos das releases do projeto Edge-AI-APP.

## Estrutura

Cada subpasta representa uma release específica e contém:
- **`{release-name}.asm`**: Pseudocódigo conceitual extraído da release (não montável)
- **`README.md`**: Descrição e metadados da release

## Releases Incluídas

1. **Hybrid-CNN+MLP—.asm-Forward-Pass**
   - Pipeline completo CNN + MLP em Assembly
   - Convolução, Pooling, Hidden Layer e Output Layer

2. **Convolutional-Neural-Network-CNN.asm**
   - Implementação de Rede Neural Convolucional

3. **Multilayer-Perceptron-MLP**
   - Implementação de Perceptron Multicamadas

4. **Neural-Forward-Pass-Unified.asm**
   - Forward Pass Neural unificado

5. **Developer-Manual-for-AI-Silicon-Chips**
   - Manual do desenvolvedor para chips de silício AI

6. **Chip-Developer-Kit**
   - Kit de desenvolvimento de chips

7. **Metamorphosis-and-retro-metamorphosis-to-silicon-hardware**
   - Metamorfose e retro-metamorfose para hardware de silício

## Origem

Todos os arquivos foram extraídos automaticamente das releases do GitHub:
https://github.com/alexandrepedrosaai/Edge-AI-APP/releases

## Data de Extração

18 de Fevereiro de 2026

## Notas

- Os arquivos `.asm` são **pseudocódigo conceitual** — representam operações de IA em uma pseudo-ISA customizada (Hub CPU, Spiral CPU, Resonance CPU), não código assembly real.
- Não são compatíveis com nenhum assembler real (NASM, GAS, Motorola 68k, etc.).
- Cada arquivo mantém comentários originais em português e um aviso de pseudocódigo no cabeçalho.
- A estrutura foi organizada para facilitar navegação e referência.
