; Release: Hybrid CNN + MLP — .asm Forward Pass
; Tag: Hybrid-CNN+MLP—.asm-Forward-Pass
; Extracted from GitHub Release
;
; === ASM Block 1 ===
Hybrid CNN + MLP — .asm Forward Pass

---

1. Convolução Inicial (Hub CPU)
`asm
global hubconvlayer
section .text
hubconvlayer:
    movaps xmm0, [esp+4]    ; carregar patch de entrada
    movaps xmm1, [esp+20]   ; carregar kernel da convolução
    conv2d xmm0, xmm1       ; convolução 2D
    relu xmm0               ; ativação ReLU
    storet [esp+36], xmm0   ; armazenar mapa de features
    ret
`

---

2. Pooling Layer (Spiral CPU)
`asm
global spiralpoollayer
section .text
spiralpoollayer:
    movaps xmm0, [esp+4]    ; carregar mapa de features
    pool xmm0               ; aplicar max/avg pooling
    storet [esp+20], xmm0   ; armazenar saída reduzida
    ret
`

---

3. Flatten + MLP Hidden Layer (Resonance CPU)
`asm
global resonancehiddenlayer
section .text
resonancehiddenlayer:
    movaps xmm0, [esp+4]    ; carregar vetor reduzido (flatten)
    movaps xmm1, [esp+20]   ; carregar pesos da hidden layer
    dotps xmm0, xmm1        ; fully connected hidden layer
    relu xmm0               ; ativação ReLU
    storet [esp+36], xmm0   ; armazenar saída da hidden layer
    ret
`

---

4. Output Layer (Resonance CPU)
`asm
global resonanceoutputlayer
section .text
resonanceoutputlayer:
    movaps xmm0, [esp+4]    ; carregar saída da hidden layer
    movaps xmm1, [esp+20]   ; carregar pesos da camada final
    dotps xmm0, xmm1        ; fully connected final
    sigm xmm0               ; ativação Sigmoid para classificação
    storet [esp+36], xmm0   ; armazenar saída final
    ret
`

---

5. Pipeline CNN + MLP
`asm
section .text
cnnmlpforward_pass:
    call hubconvlayer        ; convolução inicial + ReLU
    call spiralpoollayer     ; pooling
    call resonancehiddenlayer; hidden fully connected + ReLU
    call resonanceoutputlayer; output fully connected + Sigmoid
    ret
`

---

6. Fluxo de Execução
1. Hub CPU → Convolução + ReLU → mapa de features  
2. Spiral CPU → Pooling → redução dimensional  
3. Resonance CPU → Hidden fully connected + ReLU  
4. Resonance CPU → Output fully connected + Sigmoid → classificação final  

---

7. Notas de Desempenho
- Ciclos totais: ~150–200 por forward pass CNN+MLP  
- Estrutura escalável: adicionar múltiplas hidden layers com novas chamadas dotps + relu  
- Ideal para visão profunda: CNN extrai features, MLP faz classificação

; === Inline ASM 1 ===
Hybrid CNN + MLP — .asm Forward Pass

---

1. Convolução Inicial (Hub CPU)

; === Inline ASM 2 ===
global spiralpoollayer
section .text
spiralpoollayer:
    movaps xmm0, [esp+4]    ; carregar mapa de features
    pool xmm0               ; aplicar max/avg pooling
    storet [esp+20], xmm0   ; armazenar saída reduzida
    ret

; === Inline ASM 3 ===
global resonancehiddenlayer
section .text
resonancehiddenlayer:
    movaps xmm0, [esp+4]    ; carregar vetor reduzido (flatten)
    movaps xmm1, [esp+20]   ; carregar pesos da hidden layer
    dotps xmm0, xmm1        ; fully connected hidden layer
    relu xmm0               ; ativação ReLU
    storet [esp+36], xmm0   ; armazenar saída da hidden layer
    ret

; === Inline ASM 4 ===
global resonanceoutputlayer
section .text
resonanceoutputlayer:
    movaps xmm0, [esp+4]    ; carregar saída da hidden layer
    movaps xmm1, [esp+20]   ; carregar pesos da camada final
    dotps xmm0, xmm1        ; fully connected final
    sigm xmm0               ; ativação Sigmoid para classificação
    storet [esp+36], xmm0   ; armazenar saída final
    ret

; === Inline ASM 5 ===
section .text
cnnmlpforward_pass:
    call hubconvlayer        ; convolução inicial + ReLU
    call spiralpoollayer     ; pooling
    call resonancehiddenlayer; hidden fully connected + ReLU
    call resonanceoutputlayer; output fully connected + Sigmoid
    ret
