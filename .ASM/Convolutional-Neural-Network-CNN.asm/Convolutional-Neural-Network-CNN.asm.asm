; Release: Convolutional Neural Network (CNN) 
; Tag: Convolutional-Neural-Network-(CNN).asm
; Extracted from GitHub Release
;
; === Inline ASM 1 ===
global hubconvlayer
section .text
hubconvlayer:
    movaps xmm0, [esp+4]    ; carregar patch de entrada
    movaps xmm1, [esp+20]   ; carregar kernel da convolução
    conv2d xmm0, xmm1       ; convolução 2D
    relu xmm0               ; ativação ReLU
    storet [esp+36], xmm0   ; armazenar mapa de features
    ret

; === Inline ASM 2 ===
global spiralpoollayer
section .text
spiralpoollayer:
    movaps xmm0, [esp+4]    ; carregar mapa de features
    pool xmm0               ; aplicar max/avg pooling
    storet [esp+20], xmm0   ; armazenar saída reduzida
    ret

; === Inline ASM 3 ===
global resonancefcoutput
section .text
resonancefcoutput:
    movaps xmm0, [esp+4]    ; carregar vetor reduzido
    movaps xmm1, [esp+20]   ; carregar pesos da camada final
    dotps xmm0, xmm1        ; fully connected
    sigm xmm0               ; ativação Sigmoid para classificação
    storet [esp+36], xmm0   ; armazenar saída final
    ret

; === Inline ASM 4 ===
section .text
cnnforwardpass:
    call hubconvlayer       ; convolução inicial + ReLU
    call spiralpoollayer    ; pooling
    call resonancefcoutput  ; fully connected + Sigmoid
    ret
