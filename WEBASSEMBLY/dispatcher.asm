; dispatcher.asm
SECTION .data
    opcode dd 1   ; 1=Currents, 2=Power, 3=Flux, 4=EMF, 5=LayerForward

SECTION .text
global Dispatcher

extern SolveIonCurrents, CalcPower, CalcFlux, CalcEMF, LayerForward

Dispatcher:
    mov eax, [opcode]
    cmp eax, 1
    je RunCurrents
    cmp eax, 2
    je RunPower
    cmp eax, 3
    je RunFlux
    cmp eax, 4
    je RunEMF
    cmp eax, 5
    je RunLayer
    jmp EndProgram

RunCurrents: call SolveIonCurrents ; -> I[]
    jmp EndProgram
RunPower:    call CalcPower        ; -> P
    jmp EndProgram
RunFlux:     call CalcFlux         ; -> Phi
    jmp EndProgram
RunEMF:      call CalcEMF          ; -> EMF
    jmp EndProgram
RunLayer:    call LayerForward     ; -> I[], Phi, EMF
    jmp EndProgram

EndProgram:
    ret
