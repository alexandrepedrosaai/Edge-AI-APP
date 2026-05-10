------------------------------------------------------------
Electric & Magnetic Field Circuits Virtual Chip - Instruction Set
------------------------------------------------------------

[General Notes]
01. All instructions are dispatched via the opcode register.
02. Opcode values: 1=Currents, 2=Power, 3=Flux, 4=EMF.
03. Inputs must be preloaded in data section before execution.
04. Outputs are stored in reserved memory (I[], P, Phi, EMF).
05. Execution ends with syscall exit (mov eax,1 ; int 0x80).
06. Gaussian elimination is used for NxN current solving.
07. Floating point stack (FPU) handles real-number math.
08. Each routine is modular and callable independently.
09. Dispatcher acts as microcontroller instruction decoder.
10. Designed for WebGPU/Docker integration pipelines.

[Opcode 1 - SolveIonCurrents]
11. Purpose: Solve G * I = V for NxN system.
12. Inputs: Conductance matrix G[NxN], Voltage vector V[N].
13. Outputs: Current vector I[N].
14. Algorithm: Gaussian elimination + back substitution.
15. Registers used: general purpose + FPU stack.
16. Memory: I array stores currents.
17. Notes: Supports N up to 16 (extendable).
18. Example: G11=2, G12=1, V1=5 → I1 solved.
19. Application: Ion channel flow simulation.
20. Physics law: Linear ion flow law.

[Opcode 2 - CalcPower]
21. Purpose: Compute electrical power.
22. Formula: P = V * I.
23. Inputs: Voltage V, Current I.
24. Outputs: Scalar P (Watts).
25. Registers: FPU stack for multiplication.
26. Memory: P reserved variable.
27. Notes: Uses first channel values by default.
28. Extendable: Can sum across all channels.
29. Application: Energy consumption in circuits.
30. Physics law: Ohm’s law + power definition.

[Opcode 3 - CalcFlux]
31. Purpose: Compute magnetic flux.
32. Formula: Φ = B * A.
33. Inputs: Magnetic field B (Tesla), Area A (m^2).
34. Outputs: Scalar Phi (Weber).
35. Registers: FPU stack for multiplication.
36. Memory: Phi reserved variable.
37. Notes: Single surface calculation.
38. Extendable: Multiple surfaces via loop.
39. Application: Electromagnetic field analysis.
40. Physics law: Maxwell’s flux definition.

[Opcode 4 - CalcEMF]
41. Purpose: Compute induced EMF.
42. Formula: ε = -dΦ/dt.
43. Inputs: dPhi (flux change), dt (time interval).
44. Outputs: Scalar EMF (Volts).
45. Registers: FPU stack for division + negation.
46. Memory: EMF reserved variable.
47. Notes: Negative sign enforces Lenz’s law.
48. Extendable: Time series for dynamic EMF.
49. Application: Induction in coils/circuits.
50. Physics law: Faraday’s law of induction.

[Dispatcher Logic]
51. Reads opcode from memory.
52. Compares value with instruction table.
53. Jumps to corresponding routine.
54. Executes routine.
55. Returns to EndProgram.
56. If opcode invalid → EndProgram directly.
57. Modular design allows selective execution.
58. Acts like instruction decoder in CPU.
59. Provides flexibility in workflow.
60. Integrates seamlessly with CI/CD pipelines.

[Memory Map]
61. I[] currents vector (size N).
62. P scalar power.
63. Phi scalar flux.
64. EMF scalar induced voltage.
65. DET determinant (for matrix solving).
66. Opcode register (instruction selector).
67. G matrix (conductances).
68. V vector (voltages).
69. B, A, dPhi, dt parameters.
70. Reserved space for expansion.

[Registers Usage]
71. eax: general purpose, opcode handling.
72. ebx, ecx, edx: matrix indices.
73. esi, edi: voltage values.
74. ebp: determinant storage.
75. r8d, r9d: intermediate currents.
76. FPU stack: floating point math.
77. Flags: comparison in dispatcher.
78. Syscall: exit program.
79. Modular register allocation.
80. Optimized for clarity.

[Integration Notes]
81. ASM routines compiled into object file.
82. Linked with higher-level WebGPU pipeline.
83. Docker builds include circuits.asm.
84. CI/CD triggers execution on commit.
85. Results stored in artifacts.
86. GitHub Actions deploy outputs.
87. Pages serve docs + index.html.
88. Container registry stores images.
89. Modular design ensures scalability.
90. Instruction set acts like virtual chip.

[Future Extensions]
91. Add Opcode 5: Resistance calculation.
92. Add Opcode 6: Capacitance simulation.
93. Add Opcode 7: Inductance simulation.
94. Add Opcode 8: FFT analysis of signals.
95. Add Opcode 9: Neural ion channel coupling.
96. Add Opcode 10: Energy spectrum logging.
97. Expand matrix solver to NxN generic loop.
98. Add dispatcher table in memory for dynamic mapping.
99. Provide external API for opcode injection.
100. Treat circuits.asm as hardware datasheet.
