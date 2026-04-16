#!/bin/bash
set -e

VERSION=$1
APP_NAME="Edge-AI-APP"
REGISTRY="dockerhub.io/edge-ai"

echo "🚀 Iniciando deploy do $APP_NAME versão $VERSION para Azure IoT Edge..."

# Login no Azure (assumindo que já existe um service principal configurado)
az login --service-principal -u $AZURE_CLIENT_ID -p $AZURE_CLIENT_SECRET --tenant $AZURE_TENANT_ID

# Atualizar o módulo no IoT Edge
az iot edge set-modules \
  --device-id edgeDevice01 \
  --hub-name MyIoTHub \
  --content ./deployment.json

# Substituir a imagem no deployment.json dinamicamente
sed -i "s|${REGISTRY}/${APP_NAME}:.*|${REGISTRY}/${APP_NAME}:${VERSION}|g" deployment.json

# Aplicar novamente
az iot edge set-modules \
  --device-id edgeDevice01 \
  --hub-name MyIoTHub \
  --content ./deployment.json

echo "✅ Deploy concluído: $APP_NAME versão $VERSION rodando no dispositivo Edge."
