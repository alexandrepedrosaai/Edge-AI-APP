/*
 * ISA-Matrix.c
 * Instruction Set Architecture Matrix binding for Edge-AI-APP.
 * Compiled to output/ISA-Matrix.bin by the CI/CD workflow.
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define NUM_ISA 7

typedef struct {
    const char *name;
    const char *target;
    const char *precision;
    int edge_capable;
} ISAEntry;

static const ISAEntry ISA_TABLE[NUM_ISA] = {
    {"x86_64",       "CPU",      "FP32/FP64/INT8",           0},
    {"ARM_Cortex-A", "CPU",      "FP32/FP16/INT8",           1},
    {"ARM_Cortex-M", "MCU",      "FP32/INT8/INT4",           1},
    {"RISC-V",       "CPU/FPGA", "FP32/FP16/INT8",           1},
    {"CUDA_SM89",    "GPU",      "FP32/FP16/BF16/INT8/FP8",  0},
    {"NPU_Generic",  "NPU",      "INT8/INT4/FP16",            1},
    {"FPGA_LUT",     "FPGA",     "FP32/FP16/INT8/Custom",    1},
};

void print_isa_table(void) {
    printf("%-20s %-12s %-6s %s\n", "ISA", "Target", "Edge", "Precision");
    printf("%-20s %-12s %-6s %s\n",
           "--------------------", "------------", "------",
           "----------------------------");
    for (int i = 0; i < NUM_ISA; i++) {
        printf("%-20s %-12s %-6s %s\n",
               ISA_TABLE[i].name,
               ISA_TABLE[i].target,
               ISA_TABLE[i].edge_capable ? "Yes" : "No",
               ISA_TABLE[i].precision);
    }
}

int main(int argc, char *argv[]) {
    printf("ISA-Matrix Binary v1.0.0\n");
    printf("========================\n\n");
    print_isa_table();
    printf("\nISA-Matrix binary executed successfully.\n");
    return 0;
}
