# src/macro/main_riscv.asm
        .globl _start

        .macro LOAD reg, addr
        la \reg, \addr
        lw \reg, 0(\reg)
        .endm

        .macro ADD reg, val
        addi \reg, \reg, \val
        .endm

_start:
        LOAD t0, val
        ADD t0, 3

        li a7, 93       # syscall: exit
        li a0, 0
        ecall

        .data
val:    .word 5
