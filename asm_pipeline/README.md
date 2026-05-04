# Pipeline de Funções Matemáticas em Assembly para LLM

Este projeto consiste em um pipeline de 10 arquivos em linguagem Assembly (.ASM), cada um contendo um conjunto específico de funções matemáticas otimizadas para uso em modelos neurais (LLM).

## Estrutura do Projeto

O projeto é composto pelos seguintes arquivos:

- `generate_asm.py`: Script Python utilizado para gerar os arquivos `.asm` com base nas especificações de funções e número de operações.
- `Makefile`: Arquivo para compilar os módulos Assembly em arquivos objeto (`.o`).
- `FILE_01_Trigonometric.asm`: Funções trigonométricas (seno, cosseno, tangente, cossecante, secante, cotangente).
- `FILE_02_Complex.asm`: Funções para manipulação de números complexos.
- `FILE_03_Matrix.asm`: Funções para operações matriciais.
- `FILE_04_IrrationalWave.asm`: Funções relacionadas a números irracionais e ondas.
- `FILE_05_LinearPolymeric.asm`: Funções de álgebra linear e polinomiais.
- `FILE_06_Parabolic.asm`: Funções parabólicas.
- `FILE_07_Logarithmic.asm`: Funções logarítmicas.
- `FILE_08_ExpModInvTrig.asm`: Funções exponenciais e inversas trigonométricas modulares.
- `FILE_09_Derivatives.asm`: Funções para cálculo de derivadas.
- `FILE_10_Integrals.asm`: Funções para cálculo de integrais.

## Compilação

Para compilar os arquivos Assembly, certifique-se de ter o NASM (Netwide Assembler) e um linker (como o `ld`) instalados em seu sistema.

Navegue até o diretório `llm_math_pipeline` e execute o `Makefile`:

```bash
cd llm_math_pipeline
make
```

Isso irá gerar os arquivos objeto (`.o`) correspondentes a cada arquivo `.asm`.

## Uso

Os arquivos objeto gerados podem ser linkados com seu código principal (escrito em C/C++ ou outra linguagem que suporte chamadas a funções Assembly) para utilizar as funções matemáticas implementadas. Cada função em Assembly é um placeholder que deve ser preenchido com a lógica específica da operação matemática desejada para o modelo neural.

Por exemplo, para usar uma função trigonométrica do `FILE_01_Trigonometric.o`, você precisaria declarar a função em seu código C e linkar com o arquivo objeto:

```c
// Exemplo em C
extern double sin_op_1(); // Supondo que sin_op_1 seja uma das funções geradas

int main() {
    double result = sin_op_1();
    // ...
    return 0;
}
```

Lembre-se de que as implementações atuais das funções em Assembly são `nop` (no operation) e servem como esqueletos. Elas devem ser substituídas pelas implementações reais das operações matemáticas para o seu modelo neural.
