; Release: Developer-Manual-for-AI-Silicon-Chips
; Tag: Developer-Manual-for-AI-Silicon-Chips
; Extracted from GitHub Release
;
; === Inline ASM 1 ===
global hub_cpu
section .text
hub_cpu:
    mov eax, [esp+4]
    call conv2d
    call relu
    call storet
    ret

; === Inline ASM 2 ===
global spiral_cpu
section .text
spiral_cpu:
    movaps xmm0, [esp+4]
    movaps xmm1, [esp+20]
    dotps xmm0, xmm1
    conv2d xmm0, xmm1
    storet [esp+36], xmm0
    ret

; === Inline ASM 3 ===
global resonance_cpu
section .text
resonance_cpu:
    mov eax, [esp+4]
    bcast xmm0, eax
    loadt xmm1, [esp+20]
    tenmul xmm0, xmm1
    storet [esp+36], xmm0
    ret

; === Inline ASM 4 ===
call hub_cpu        ; preprocess input
call spiral_cpu     ; cognition search
call resonance_cpu  ; resonance output
