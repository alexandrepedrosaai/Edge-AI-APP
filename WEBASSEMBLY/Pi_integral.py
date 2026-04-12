import wasmtime

# Engine e store
engine = wasmtime.Engine()
store = wasmtime.Store(engine)

# Carrega módulo WASM (já compilado de mega_math.wat para mega_math.wasm)
module = wasmtime.Module.from_file(engine, "mega_math.wasm")
instance = wasmtime.Instance(store, module, [])

# Função integral de π
pi_integral = instance.exports(store)["pi_integral"]

# Testa com diferentes números de passos
for steps in [10, 100, 1000, 10000, 100000]:
    approx_pi = pi_integral(store, steps)
    print(f"Steps={steps}, π ≈ {approx_pi}")
