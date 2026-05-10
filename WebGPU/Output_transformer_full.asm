; ============================================
; Ionic & Magnetic Procedural Transformer
; Encoder + Decoder + Output Sequence
; ============================================

SECTION .data
01. N dd 4                  ; largura da camada
02. Layers dd 2             ; profundidade encoder/decoder
03. Heads dd 2              ; número de cabeças de atenção
04. Scale1 dd 0.5           ; head1 scaling
05. Scale2 dd 0.8           ; head2 scaling
06. FFWeight dd 1.2         ; feedforward weight
07. ResidualScale dd 1.0    ; residual scaling
08. ScaleQ dd 0.6           ; query scaling
09. ScaleK dd 0.7           ; key scaling
10. ScaleV dd 0.8           ; value scaling

11. ; Matriz de condutâncias (Keys)
12. G dd 2.1, 1.2, 0.1, 1.0
13.    dd 1.1, 2.9, 1.0, 0.2
14.    dd 0.0, 1.1, 2.2, 1.0
15.    dd 1.0, 0.1, 1.2, 2.1

16. ; Tensões de entrada (Queries)
17. V dd 5.0, 7.0, 4.0, 6.0

18. ; Saídas alvo para cross-attention
19. Target dd 1.0, 2.0, 1.5, 2.5

SECTION .bss
20. I resd 16
21. Phi resd 1
22. EMF resd 1
23. AttentionHead1 resd 16
24. AttentionHead2 resd 16
25. MultiHeadOut resd 16
26. FeedForwardOut resd 16
27. ResidualOut resd 16
28. EncoderOut resd 16
29. CrossAttentionOut resd 16
30. DecoderFFOut resd 16
31. DecoderResidualOut resd 16
32. DecoderOut resd 16
33. SequenceOut resd 64

SECTION .text
34. global _start
35. extern SolveIonCurrents, CalcFlux, CalcEMF

; --------------------------------------------
; Encoder: Multi-Head Attention
; --------------------------------------------
36. ComputeHead1:
37.     call SolveIonCurrents
38.     call CalcFlux
39.     call CalcEMF
40.     mov ecx, [N]
41.     xor esi, esi
42. LoopHead1:
43.     fld dword [I + esi*4]
44.     fld dword [EMF]
45.     fadd
46.     fld dword [Scale1]
47.     fmul
48.     fstp dword [AttentionHead1 + esi*4]
49.     inc esi
50.     loop LoopHead1
51.     ret

52. ComputeHead2:
53.     call SolveIonCurrents
54.     call CalcFlux
55.     call CalcEMF
56.     mov ecx, [N]
57.     xor esi, esi
58. LoopHead2:
59.     fld dword [I + esi*4]
60.     fld dword [EMF]
61.     fadd
62.     fld dword [Scale2]
63.     fmul
64.     fstp dword [AttentionHead2 + esi*4]
65.     inc esi
66.     loop LoopHead2
67.     ret

68. CombineHeads:
69.     mov ecx, [N]
70.     xor esi, esi
71. LoopCombine:
72.     fld dword [AttentionHead1 + esi*4]
73.     fld dword [AttentionHead2 + esi*4]
74.     fadd
75.     fld1
76.     fdiv
77.     fstp dword [MultiHeadOut + esi*4]
78.     inc esi
79.     loop LoopCombine
80.     ret

81. FeedForwardEnc:
82.     mov ecx, [N]
83.     xor esi, esi
84. LoopFFEnc:
85.     fld dword [MultiHeadOut + esi*4]
86.     fld dword [FFWeight]
87.     fmul
88.     fstp dword [FeedForwardOut + esi*4]
89.     inc esi
90.     loop LoopFFEnc
91.     ret

92. ResidualEnc:
93.     mov ecx, [N]
94.     xor esi, esi
95. LoopResEnc:
96.     fld dword [FeedForwardOut + esi*4]
97.     fld dword [V + esi*4]
98.     fadd
99.     fld dword [ResidualScale]
100.    fmul
101.    fstp dword [ResidualOut + esi*4]
102.    inc esi
103.    loop LoopResEnc
104.    ret

105. EncoderBlock:
106.    call ComputeHead1
107.    call ComputeHead2
108.    call CombineHeads
109.    call FeedForwardEnc
110.    call ResidualEnc
111.    mov ecx, [N]
112.    xor esi, esi
113. LoopEncOut:
114.    fld dword [ResidualOut + esi*4]
115.    fstp dword [EncoderOut + esi*4]
116.    inc esi
117.    loop LoopEncOut
118.    ret

; --------------------------------------------
; Decoder: Cross-Attention
; --------------------------------------------
119. CrossAttention:
120.    mov ecx, [N]
121.    xor esi, esi
122. LoopCross:
123.    fld dword [Target + esi*4]   ; Query
124.    fld dword [ScaleQ]
125.    fmul
126.    fld dword [EncoderOut + esi*4] ; Key/Value
127.    fld dword [ScaleK]
128.    fmul
129.    fadd
130.    fld dword [ScaleV]
131.    fmul
132.    fstp dword [CrossAttentionOut + esi*4]
133.    inc esi
134.    loop LoopCross
135.    ret

136. FeedForwardDec:
137.    mov ecx, [N]
138.    xor esi, esi
139. LoopFFDec:
140.    fld dword [CrossAttentionOut + esi*4]
141.    fld dword [FFWeight]
142.    fmul
143.    fstp dword [DecoderFFOut + esi*4]
144.    inc esi
145.    loop LoopFFDec
146.    ret

147. ResidualDec:
148.    mov ecx, [N]
149.    xor esi, esi
150. LoopResDec:
151.    fld dword [DecoderFFOut + esi*4]
152.    fld dword [Target + esi*4]
153.    fadd
154.    fld dword [ResidualScale]
155.    fmul
156.    fstp dword [DecoderResidualOut + esi*4]
157.    inc esi
158.    loop LoopResDec
159.    ret

160. DecoderBlock:
161.    call CrossAttention
162.    call FeedForwardDec
163.    call ResidualDec
164.    mov ecx, [N]
165.    xor esi, esi
166. LoopDecOut:
167.    fld dword [DecoderResidualOut + esi*4]
168.    fstp dword [DecoderOut + esi*4]
169.    inc esi
170.    loop LoopDecOut
171.    ret

; --------------------------------------------
; Output Sequence
; --------------------------------------------
172. SequenceOutput:
173.    mov ecx, [Layers]
174.    xor esi, esi
175. LoopSeq:
176.    fld dword [DecoderOut + esi*4]
177.    fstp dword [SequenceOut + esi*4]
178.    inc esi
179.    loop LoopSeq
180.    ret

; --------------------------------------------
; Entry point
; --------------------------------------------
181. _start:
182.    mov ecx, [Layers]
183. LoopTransformer:
184.    call EncoderBlock
185.    call DecoderBlock
186.    loop LoopTransformer
187.    call SequenceOutput
188.    mov eax, 1
189.    int 0x80
