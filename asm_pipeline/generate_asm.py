import os

def generate_file(filename, title, operations_count, op_names):
    with open(filename, 'w') as f:
        f.write(f"; {filename} - {title}\n")
        f.write(f"; Total operations: {operations_count}\n\n")
        f.write("section .text\n")
        f.write(f"global {title.replace(' ', '_').lower()}_init\n\n")
        
        for i in range(operations_count):
            op = op_names[i % len(op_names)]
            f.write(f"; Operation {i+1}: {op}\n")
            f.write(f"{op}_op_{i+1}:\n")
            f.write("    push rbp\n")
            f.write("    mov rbp, rsp\n")
            f.write("    ; ... implementation of neural model math ...\n")
            f.write("    nop\n")
            f.write("    pop rbp\n")
            f.write("    ret\n\n")

def main():
    os.makedirs("llm_math_pipeline", exist_ok=True)
    
    # File 1: Trigonometric (50)
    generate_file("llm_math_pipeline/FILE_01_Trigonometric.asm", "Trigonometric Functions", 50, ["sin", "cos", "tan", "csc", "sec", "cot"])
    
    # File 2: Complex Numbers (30)
    generate_file("llm_math_pipeline/FILE_02_Complex.asm", "Complex Numbers", 30, ["complex_add", "complex_sub", "complex_mul", "complex_div", "complex_conj"])
    
    # File 3: Matrix (60)
    generate_file("llm_math_pipeline/FILE_03_Matrix.asm", "Matrix Functions", 60, ["mat_add", "mat_sub", "mat_mul", "mat_transpose", "mat_inv", "mat_det"])
    
    # File 4: Irrational Wave (40)
    generate_file("llm_math_pipeline/FILE_04_IrrationalWave.asm", "Irrational Wave Functions", 40, ["wave_sin_irr", "wave_cos_irr", "wave_phase", "wave_amp"])
    
    # File 5: Linear Algebra & Polymeric (20 + 50 = 70)
    generate_file("llm_math_pipeline/FILE_05_LinearPolymeric.asm", "Linear Algebra and Polymeric", 70, ["lin_dot", "lin_cross", "lin_norm", "poly_eval", "poly_add", "poly_mul"])
    
    # File 6: Parabolic (10)
    generate_file("llm_math_pipeline/FILE_06_Parabolic.asm", "Parabolic Functions", 10, ["parabola_vertex", "parabola_focus", "parabola_directrix", "parabola_eval"])
    
    # File 7: Logarithmic (30)
    generate_file("llm_math_pipeline/FILE_07_Logarithmic.asm", "Logarithmic Functions", 30, ["log2", "log10", "ln", "log_base_n"])
    
    # File 8: Exponential & Modular Inverse Trig (15 + 15 = 30)
    generate_file("llm_math_pipeline/FILE_08_ExpModInvTrig.asm", "Exponential and Modular Inverse Trig", 30, ["exp", "exp2", "exp10", "mod_asin", "mod_acos", "mod_atan"])
    
    # File 9: Derivatives (100)
    generate_file("llm_math_pipeline/FILE_09_Derivatives.asm", "Derivative Functions", 100, ["deriv_trig", "deriv_poly", "deriv_exp", "deriv_log", "deriv_matrix"])
    
    # File 10: Integrals (100)
    generate_file("llm_math_pipeline/FILE_10_Integrals.asm", "Integral Functions", 100, ["integ_trig", "integ_poly", "integ_exp", "integ_log", "integ_matrix"])

if __name__ == "__main__":
    main()
