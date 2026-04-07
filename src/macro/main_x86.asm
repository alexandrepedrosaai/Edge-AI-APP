; src/macro/main_x86.asm
bits 64
%macro LOAD 2
    mov %1, %2
%endmacro

%macro ADD 2
    add %1, %2
%endmacro

section .data
    val db 5

section .text
    global _start

_start:
    LOAD rbx, [val]
    ADD rbx, 3

    mov rax, 60   ; syscall: exit
    xor rdi, rdi
    syscall
