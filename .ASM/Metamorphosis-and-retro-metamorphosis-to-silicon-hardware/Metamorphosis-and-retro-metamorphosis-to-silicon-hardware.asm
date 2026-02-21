; Release: Metamorphosis and retro metamorphosis to silicon hardware's 
; Tag: Metamorphosis-and-retro-metamorphosis-to-silicon-hardware
; Extracted from GitHub Release
;
; === Inline ASM 1 ===
global add_numbers
section .text
add_numbers:
    mov eax, [esp+4]   ; first operand
    mov ebx, [esp+8]   ; second operand
    add eax, ebx       ; addition
    ret

global multiply_numbers
section .text
multiply_numbers:
    mov eax, [esp+4]
    mov ebx, [esp+8]
    imul eax, ebx      ; multiplication
    ret

; === Inline ASM 2 ===
global compareandbranch
section .text
compareandbranch:
    mov eax, [esp+4]
    mov ebx, [esp+8]
    cmp eax, ebx
    jg greater_label
    jl lesser_label
    je equal_label

greater_label:
    mov eax, 1
    ret
lesser_label:
    mov eax, -1
    ret
equal_label:
    mov eax, 0
    ret

; === Inline ASM 3 ===
; Dot Product
global dotps
section .text
dotps:
    ; pseudo-op for vector dot product
    ; result in xmm0
    ; cycles: 5–10
    ret

; Convolution 2D
global conv2d
section .text
conv2d:
    ; pseudo-op for 2D convolution
    ; input patch in xmm0, kernel in xmm1
    ; result in xmm2
    ret

; Activation Functions
global relu
section .text
relu:
    ; apply ReLU: max(0,x)
    ; input in xmm0, output in xmm0
    ret
