.section .data
INPUT:   .word 1, 2, 3,
         .word 4, 5, 6,
         .word 7, 8, 9

FILTER:  .word 1, 0,
         .word 0, -1

WEIGHTS: .word 2, 2, 2, 2   // pesos para dot product
RESULT:  .word 0

    .section .text
    .global _start

_start:
    // --- Conv2D (janela 2x2 no canto superior esquerdo) ---
    LDR x0, =INPUT
    LDR x1, =FILTER

    LDR w2, [x0]        // INPUT[0][0]
    LDR w3, [x0, #4]    // INPUT[0][1]
    LDR w4, [x0, #12]   // INPUT[1][0]
    LDR w5, [x0, #16]   // INPUT[1][1]

    LDR w6, [x1]        // FILTER[0][0]
    LDR w7, [x1, #4]    // FILTER[0][1]
    LDR w8, [x1, #8]    // FILTER[1][0]
    LDR w9, [x1, #12]   // FILTER[1][1]

    MUL w10, w2, w6
    MUL w11, w3, w7
    ADD w10, w10, w11
    MUL w11, w4, w8
    ADD w10, w10, w11
    MUL w11, w5, w9
    ADD w10, w10, w11   // w10 = resultado conv2d

    // --- Pooling (max entre 2 valores simulados) ---
    MOV w12, #7         // exemplo valor extraído
    CMP w10, w12
    CSEL w13, w10, w12, GT   // w13 = max(conv2d, 7)

    // --- Dot Product (com pesos) ---
    LDR x2, =WEIGHTS
    LDR w14, [x2]       // peso 0
    MUL w15, w13, w14   // dot product simplificado

    // --- ReLU ---
    CMP w15, #0
    CSEL w16, w15, wzr, GT   // w16 = max(0, w15)

    // --- Output ---
    LDR x3, =RESULT
    STR w16, [x3]

    // Encerrar
    MOV x8, #93
    MOV x0, #0
    SVC #0
