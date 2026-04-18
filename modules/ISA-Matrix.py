"""
ISA-Matrix Module
Instruction Set Architecture (ISA) Matrix binding for Edge-AI-APP.
Provides ISA classification and mapping for CPU/GPU/NPU/FPGA execution targets.
"""

import sys
import json

# ISA classification matrix
ISA_MATRIX = {
    "x86_64": {
        "target": "CPU",
        "simd": ["SSE4.2", "AVX2", "AVX-512"],
        "precision": ["FP32", "FP64", "INT8"],
        "edge_support": False,
    },
    "ARM_Cortex-A": {
        "target": "CPU",
        "simd": ["NEON", "SVE"],
        "precision": ["FP32", "FP16", "INT8"],
        "edge_support": True,
    },
    "ARM_Cortex-M": {
        "target": "MCU",
        "simd": ["DSP", "MVE"],
        "precision": ["FP32", "INT8", "INT4"],
        "edge_support": True,
    },
    "RISC-V": {
        "target": "CPU/FPGA",
        "simd": ["RVV"],
        "precision": ["FP32", "FP16", "INT8"],
        "edge_support": True,
    },
    "CUDA_SM89": {
        "target": "GPU",
        "simd": ["Tensor Cores", "WMMA"],
        "precision": ["FP32", "FP16", "BF16", "INT8", "FP8"],
        "edge_support": False,
    },
    "NPU_Generic": {
        "target": "NPU",
        "simd": ["MAC Array"],
        "precision": ["INT8", "INT4", "FP16"],
        "edge_support": True,
    },
    "FPGA_LUT": {
        "target": "FPGA",
        "simd": ["DSP48", "Custom"],
        "precision": ["FP32", "FP16", "INT8", "Custom"],
        "edge_support": True,
    },
}


def build_isa_matrix():
    """Build and return the ISA compatibility matrix."""
    matrix = []
    for isa_name, props in ISA_MATRIX.items():
        row = {
            "ISA": isa_name,
            "Target": props["target"],
            "SIMD_Extensions": ", ".join(props["simd"]),
            "Precision_Formats": ", ".join(props["precision"]),
            "Edge_Capable": props["edge_support"],
        }
        matrix.append(row)
    return matrix


def print_matrix(matrix):
    """Print the ISA matrix in a readable table format."""
    header = f"{'ISA':<20} {'Target':<12} {'Edge':<6} {'Precision'}"
    print("=" * 80)
    print("ISA-Matrix: Instruction Set Architecture Binding Table")
    print("=" * 80)
    print(header)
    print("-" * 80)
    for row in matrix:
        print(
            f"{row['ISA']:<20} {row['Target']:<12} {str(row['Edge_Capable']):<6} {row['Precision_Formats']}"
        )
    print("=" * 80)


def select_isa_for_workload(workload_type: str) -> list:
    """Select suitable ISAs for a given workload type."""
    recommendations = []
    workload_map = {
        "inference": ["ARM_Cortex-A", "NPU_Generic", "FPGA_LUT", "CUDA_SM89"],
        "training": ["CUDA_SM89", "x86_64"],
        "edge": ["ARM_Cortex-M", "ARM_Cortex-A", "RISC-V", "NPU_Generic", "FPGA_LUT"],
        "fpga": ["FPGA_LUT", "RISC-V"],
    }
    targets = workload_map.get(workload_type.lower(), list(ISA_MATRIX.keys()))
    for isa in targets:
        if isa in ISA_MATRIX:
            recommendations.append({"ISA": isa, **ISA_MATRIX[isa]})
    return recommendations


def main():
    print("Initializing ISA-Matrix module...")
    matrix = build_isa_matrix()
    print_matrix(matrix)

    print("\nRecommended ISAs for edge inference:")
    edge_isas = select_isa_for_workload("edge")
    for item in edge_isas:
        print(f"  - {item['ISA']} ({item['target']})")

    # Export matrix as JSON for downstream pipeline consumption
    output = {"module": "ISA-Matrix", "version": "1.0.0", "matrix": matrix}
    print("\nISA-Matrix JSON output (summary):")
    print(json.dumps(output, indent=2)[:500] + "...")

    print("\nISA-Matrix module completed successfully.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
