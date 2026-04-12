import wasmtime

# Carrega o engine e store
engine = wasmtime.Engine()
store = wasmtime.Store(engine)

# Compila o módulo
module = wasmtime.Module.from_file(engine, "mega_math.wasm")

# Instancia
instance = wasmtime.Instance(store, module, [])

# Acessa funções exportadas
sin_func = instance.exports(store)["sin"]
cos_func = instance.exports(store)["cos"]
pi_func = instance.exports(store)["pi"]
mat_mul_func = instance.exports(store)["mat_mul"]

# Exemplo: calcular sin(1.0)
result = sin_func(store, 1.0)
print("sin(1.0) ≈", result)

# Exemplo: obter π
print("pi ≈", pi_func(store))

# Exemplo: multiplicação de matriz (precisa passar ponteiros/memória linear)
# Aqui você teria que mapear a memória WASM e escrever os dados antes de chamar
