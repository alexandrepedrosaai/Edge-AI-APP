; ============================================
; Ionic & Magnetic Neural Network Training Loop
; Procedural Gradient Descent in ASM
; ============================================

SECTION .data
    N dd 4                  ; neurons per layer
    Epochs dd 10            ; training iterations
    LearningRate dd 0.01    ; adjustment step

    ; Conductance matrix G (weights)
    G dd 2.0, 1.0, 0.0, 1.0
       dd 1.0, 3.0, 1.0, 0.0
       dd 0.0, 1.0, 2.0, 1.0
       dd 1.0, 0.0, 1.0, 2.0

    ; Input voltages (tokens)
    V dd 5.0, 7.0, 4.0, 6.0

    ; Target currents (desired outputs)
    TargetI dd 1.0, 2.0, 1.5, 2.5

SECTION .bss
    I resd 16               ; computed currents
    Error resd 16           ; error vector
    DET resd 1

SECTION .text
    global _start

extern SolveIonCurrents

; --------------------------------------------
; Routine: ComputeError
; Purpose: Error = TargetI - I
; --------------------------------------------
ComputeError:
    mov ecx, [N]
    xor esi, esi
LoopError:
    fld dword [TargetI + esi*4]
    fld dword [I + esi*4]
    fsub
    fstp dword [Error + esi*4]
    inc esi
    loop LoopError
    ret

; --------------------------------------------
; Routine: UpdateWeights
; Purpose: G = G + LearningRate * Error
; --------------------------------------------
UpdateWeights:
    mov ecx, [N]
    xor esi, esi
LoopWeights:
    fld dword [Error + esi*4]
    fld dword [LearningRate]
    fmul
    fld dword [G + esi*4]
    fadd
    fstp dword [G + esi*4]
    inc esi
    loop LoopWeights
    ret

; --------------------------------------------
; Routine: TrainNetwork
; Purpose: Iterative training loop
; --------------------------------------------
TrainNetwork:
    mov ecx, [Epochs]
LoopEpochs:
    call SolveIonCurrents
    call ComputeError
    call UpdateWeights
    loop LoopEpochs
    ret

; --------------------------------------------
; Entry point
; --------------------------------------------
_start:
    call TrainNetwork
    mov eax, 1
    int 0x80
