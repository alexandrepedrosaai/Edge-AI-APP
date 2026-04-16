section .data
msg db "CUDA Artifact",0

section .text
global _start
_start:
    mov edx, 14
    mov ecx, msg
    mov ebx, 1
    mov eax, 4
    int 0x80
    mov eax, 1
    int 0x80
