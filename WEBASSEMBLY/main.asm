; main.asm
SECTION .data
    Layers dd 3   ; number of layers

SECTION .text
global _start

extern Dispatcher

_start:
    mov ecx, [Layers]
LoopLayers:
    mov [opcode], 5   ; run LayerForward
    call Dispatcher
    loop LoopLayers

    ; Exit syscall
    mov eax, 1
    int 0x80
