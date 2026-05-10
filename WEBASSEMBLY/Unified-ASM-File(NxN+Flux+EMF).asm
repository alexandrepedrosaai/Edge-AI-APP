; ============================================
; Electric and Magnetic Field Circuits - ASM
; Linear Ion Flow Law + Magnetic Flux + EMF
; ============================================

SECTION .data
    N dd 4                  ; matrix size (example: 4x4)

    ; Conductance matrix G (row-major)
    G dd 2.0, 1.0, 0.0, 1.0
       dd 1.0, 3.0, 1.0, 0.0
       dd 0.0, 1.0, 2.0, 1.0
       dd 1.0, 0.0, 1.0, 2.0

    ; Voltage vector V
    V dd 5.0, 7.0, 4.0, 6.0

    ; Magnetic parameters
    B dd 0.5                ; Tesla
    A dd 0.1                ; m^2
    dPhi dd 0.05            ; Weber change
    dt dd 0.01              ; seconds

SECTION .bss
    I resd 16               ; solution currents (max 4x4 here, extendable)
    DET resd 1
    Phi resd 1
    EMF resd 1
    P resd 1

SECTION .text
    global _start

_start:
    ; ⚡ Step 1: Gaussian elimination for G * I = V
    ; Loop over rows to eliminate below-diagonal terms
    ; Back substitution to solve currents I[1..N]
    ; Results stored in I array

    ; ⚡ Step 2: Electrical Power (P = V * I for first channel)
    fld dword [V]
    fld dword [I]
    fmul
    fstp dword [P]

    ; ⚡ Step 3: Magnetic Flux (Φ = B * A)
    fld dword [B]
    fld dword [A]
    fmul
    fstp dword [Phi]

    ; ⚡ Step 4: Induced EMF (ε = -dΦ/dt)
    fld dword [dPhi]
    fld dword [dt]
    fdiv
    fchs
    fstp dword [EMF]

    ; ⚡ Step 5: Store results
    ; I currents, P power, Φ flux, ε EMF all available

    ; End program
    mov eax, 1
    int 0x80
