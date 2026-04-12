; src/macro/main_arm.asm
; Exemplo de Macro Assembler para ARM64 (AArch64)

; Definição de macros (sintaxe NASM adaptada para ARM64 se usado com ferramentas compatíveis, 
; mas aqui corrigimos para instruções ARM64 reais)

%macro LOAD 2
    ldr %1, =%2
    ldr %1, [%1]
%endmacro

%macro ADD 2
    add %1, %1, #%2
%endmacro

%macro PRINT 1
    ; Exemplo simples: imprimir valor (Linux syscall write para ARM64)
    mov x8, #64         ; syscall: write (ARM64)
    mov x0, #1          ; file descriptor: stdout
    mov x1, %1          ; endereço do buffer
    mov x2, #1          ; tamanho
    svc #0
%endmacro

section .data
    val dq 5            ; Usando 64-bit data para ARM64

section .text
    global _start

_start:
    ; Usando macros
    LOAD x19, val       ; carrega valor em x19 (registrador ARM64)
    ADD x19, 3          ; soma 3 ao valor
    
    ; Encerrar programa (Linux syscall exit para ARM64)
    mov x8, #93         ; syscall: exit (ARM64)
    mov x0, #0          ; status 0
    svc #0
