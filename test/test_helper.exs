ExUnit.start()

# Opcional: configurar logger para não poluir saída de testes
Logger.configure(level: :warn)

# Se quiser rodar testes em paralelo:
ExUnit.configure(exclude: [:skip], trace: false)

# Caso use libcluster ou outros serviços distribuídos,
# pode-se inicializar mocks ou configurações aqui.
