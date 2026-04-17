section .data
msg db "Quantum Circuit Artifact",0

section .text
global _start
_start:
    ; print message
    mov edx, 24
    mov ecx, msg
    mov ebx, 1
    mov eax, 4
    int 0x80
    ; exit
    mov eax, 1
    int 0x80
