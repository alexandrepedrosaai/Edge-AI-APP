; src/macro/main.asm
; Exemplo de Macro Assembler com instruções expandidas

; Definição de macros
%macro LOAD 2
    mov %1, %2
%endmacro

%macro ADD 2
    add %1, %2
%endmacro

%macro PRINT 1
    ; Exemplo simples: imprimir valor em registrador
    ; (Linux syscall write)
    mov rax, 1          ; syscall: write
    mov rdi, 1          ; file descriptor: stdout
    mov rsi, %1         ; endereço do buffer
    mov rdx, 1          ; tamanho
    syscall
%endmacro

section .data
    val db 5

section .text
    global _start

_start:
    ; Usando macros
    LOAD rbx, [val]     ; carrega valor em rbx
    ADD rbx, 3          ; soma 3 ao valor
    ; imprimir resultado (apenas exemplo, não imprime número real)
    PRINT rbx

    ; Encerrar programa
    mov rax, 60         ; syscall: exit
    xor rdi, rdi
    syscall
