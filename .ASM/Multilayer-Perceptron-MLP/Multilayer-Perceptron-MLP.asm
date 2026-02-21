; Release: Multilayer Perceptron (MLP)
; Tag: Multilayer-Perceptron-(MLP)
; Extracted from GitHub Release
;
; === Inline ASM 1 ===
global hub_layer1
section .text
hub_layer1:
    movaps xmm0, [esp+4]    ; carregar vetor de entrada
    movaps xmm1, [esp+20]   ; carregar pesos da camada 1
    dotps xmm0, xmm1        ; produto escalar (FC1)
    relu xmm0               ; ativação ReLU
    storet [esp+36], xmm0   ; armazenar saída da camada 1
    ret

; === Inline ASM 2 ===
global spiral_layer2
section .text
spiral_layer2:
    movaps xmm0, [esp+4]    ; carregar saída da camada 1
    movaps xmm1, [esp+20]   ; carregar pesos da camada 2
    dotps xmm0, xmm1        ; produto escalar (FC2)
    tanh xmm0               ; ativação Tanh
    storet [esp+36], xmm0   ; armazenar saída da camada 2
    ret

; === Inline ASM 3 ===
global resonance_output
section .text
resonance_output:
    mov eax, [esp+4]        ; carregar escalar de ressonância
    bcast xmm0, eax         ; broadcast escalar → vetor
    loadt xmm1, [esp+20]    ; carregar saída da camada 2
    tenmul xmm0, xmm1       ; multiplicação ressonante
    sigm xmm0               ; ativação final Sigmoid
    storet [esp+36], xmm0   ; armazenar saída final
    ret

; === Inline ASM 4 ===
section .text
mlpforwardpass:
    call hub_layer1         ; camada 1 (FC + ReLU)
    call spiral_layer2      ; camada 2 (FC + Tanh)
    call resonance_output   ; camada final (Sigmoid + ressonância)
    ret
