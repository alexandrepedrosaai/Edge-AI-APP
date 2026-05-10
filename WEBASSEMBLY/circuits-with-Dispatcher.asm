; ============================================
; Electric and Magnetic Field Circuits Library
; Dispatcher for Ion Flow + EM Routines
; ============================================

SECTION .data
    opcode dd 1             ; 1=Currents, 2=Power, 3=Flux, 4=EMF

    ; Example parameters
    N dd 4
    B dd 0.5
    A dd 0.1
    dPhi dd 0.05
    dt dd 0.01
    V dd 5.0, 7.0, 4.0, 6.0

SECTION .bss
    I resd 16
    DET resd 1
    Phi resd 1
    EMF resd 1
    P resd 1

SECTION .text
    global _start

; --------------------------------------------
; Routine: SolveIonCurrents
; --------------------------------------------
SolveIonCurrents:
    ; Gaussian elimination + back substitution
    ; Results stored in I[]
    ret

; --------------------------------------------
; Routine: CalcPower
; --------------------------------------------
CalcPower:
    fld dword [V]
    fld dword [I]
    fmul
    fstp dword [P]
    ret

; --------------------------------------------
; Routine: CalcFlux
; --------------------------------------------
CalcFlux:
    fld dword [B]
    fld dword [A]
    fmul
    fstp dword [Phi]
    ret

; --------------------------------------------
; Routine: CalcEMF
; --------------------------------------------
CalcEMF:
    fld dword [dPhi]
    fld dword [dt]
    fdiv
    fchs
    fstp dword [EMF]
    ret

; --------------------------------------------
; Dispatcher
; --------------------------------------------
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
    jmp EndProgram

RunCurrents:
    call SolveIonCurrents
    jmp EndProgram

RunPower:
    call CalcPower
    jmp EndProgram

RunFlux:
    call CalcFlux
    jmp EndProgram

RunEMF:
    call CalcEMF
    jmp EndProgram

EndProgram:
    mov eax, 1
    int 0x80

; --------------------------------------------
; Entry point
; --------------------------------------------
_start:
    call Dispatcher
