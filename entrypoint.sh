#!/bin/bash
echo "Starting Edge AI APP Multi-Language Environment..."

# Exemplo de como rodar as partes do sistema
# Você pode customizar qual serviço inicia primeiro
echo "Running Python Orchestrator..."
python3 Project/main.py &

echo "Running Go Integration..."
./Project/edge-ai-go &

echo "Running Rust Core..."
./Project/edge-ai-rust &

# Mantém o container rodando
wait
