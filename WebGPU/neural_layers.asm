; neural_layers.asm
SECTION .text
global LayerForward

extern SolveIonCurrents, CalcFlux, CalcEMF

LayerForward:
    call SolveIonCurrents
    call CalcFlux
    call CalcEMF
    ; Combine I + EMF for output vector
    ret
