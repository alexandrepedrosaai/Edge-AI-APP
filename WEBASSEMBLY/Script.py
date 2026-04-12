import wasmtime
import struct

# Engine e store
engine = wasmtime.Engine()
store = wasmtime.Store(engine)

# Carrega módulo WASM
module = wasmtime.Module.from_file(engine, "mega_math.wasm")
instance = wasmtime.Instance(store, module, [])

# Acessa memória e funções
memory = instance.exports(store)["memory"]
mat_mul = instance.exports(store)["mat_mul"]
sin_func = instance.exports(store)["sin"]
pi_func = instance.exports(store)["pi"]
phi_func = instance.exports(store)["phi"]

# Helpers para matrizes
def write_matrix(ptr, mat, N):
    for i in range(N):
        for j in range(N):
            offset = ptr + (i * N + j) * 4
            memory.data_ptr(store)[offset:offset+4] = struct.pack("<f", mat[i][j])

def read_matrix(ptr, N):
    mat = []
    for i in range(N):
        row = []
        for j in range(N):
            offset = ptr + (i * N + j) * 4
            val = struct.unpack("<f", memory.data_ptr(store)[offset:offset+4])[0]
            row.append(val)
        mat.append(row)
    return mat

# Matrizes de exemplo
A = [[1.0, 2.0], [3.0, 4.0]]
B = [[5.0, 6.0], [7.0, 8.0]]
N = 2

# Ponteiros
ptr_A = 0
ptr_B = N*N*4
ptr_C = 2*N*N*4

# Escreve A e B
write_matrix(ptr_A, A, N)
write_matrix(ptr_B, B, N)

# Multiplica
mat_mul(store, ptr_A, ptr_B, ptr_C, N)
C = read_matrix(ptr_C, N)
print("Matrix multiplication result:", C)

# Lê irracionais
pi_val = pi_func(store)
phi_val = phi_func(store)
print("π ≈", pi_val)
print("φ (golden ratio) ≈", phi_val)

# Usa trigonometria: sin(pi/4)
sin_val = sin_func(store, pi_val/4)
print("sin(π/4) ≈", sin_val)
