import wasmtime
import struct

# Carrega módulo
engine = wasmtime.Engine()
store = wasmtime.Store(engine)
module = wasmtime.Module.from_file(engine, "mega_math.wasm")
instance = wasmtime.Instance(store, module, [])

# Acessa memória
memory = instance.exports(store)["memory"]
mat_mul = instance.exports(store)["mat_mul"]

# Helpers
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

# Matrizes
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

# Executa multiplicação
mat_mul(store, ptr_A, ptr_B, ptr_C, N)

# Lê resultado
C = read_matrix(ptr_C, N)
print("Resultado:", C)
