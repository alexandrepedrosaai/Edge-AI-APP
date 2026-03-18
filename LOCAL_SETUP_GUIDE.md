# 🚀 Local Setup Guide - Edge AI App

Execute este guia no seu computador local para configurar completamente o Azure e GitHub.

## 📋 Pré-requisitos

- ✅ Azure CLI instalado (`az --version`)
- ✅ GitHub CLI instalado (`gh --version`)
- ✅ Conta Azure ativa
- ✅ Acesso ao repositório GitHub

## 🔧 Passo 1: Fazer Login no Azure

```bash
# Login interativo
az login

# Ou com device code
az login --use-device-code
```

## 🔧 Passo 2: Copiar e Executar Script

Copie o script abaixo e execute no seu terminal:

```bash
#!/bin/bash

set -e

# Configuration
SUBSCRIPTION_ID="f7fc86dd-bd9f-43a6-80a4-0bb6cab950ec"
RESOURCE_GROUP="edge-ai-rg"
LOCATION="eastus"
SERVICE_PRINCIPAL_NAME="github-edge-ai-app"
CONTAINER_APP_ENV="edge-ai-env"
CONTAINER_APP_NAME="edge-ai-app"
FUNCTION_APP_NAME="edge-ai-functions"
STORAGE_ACCOUNT_NAME="edgaistorageacct"
GITHUB_OWNER="alexandrepedrosaai"
GITHUB_REPO="Edge-AI-APP"

echo "Setting subscription..."
az account set --subscription "$SUBSCRIPTION_ID"

echo "Creating Resource Group..."
az group create \
  --name "$RESOURCE_GROUP" \
  --location "$LOCATION" || true

echo "Creating Service Principal..."
SP_OUTPUT=$(az ad sp create-for-rbac \
  --name "$SERVICE_PRINCIPAL_NAME" \
  --role contributor \
  --scopes "/subscriptions/$SUBSCRIPTION_ID" \
  --json-auth 2>/dev/null || echo "{}")

if [ "$SP_OUTPUT" = "{}" ]; then
  CLIENT_ID=$(az ad sp list --display-name "$SERVICE_PRINCIPAL_NAME" --query "[0].appId" -o tsv)
  TENANT_ID=$(az account show --query tenantId -o tsv)
else
  CLIENT_ID=$(echo "$SP_OUTPUT" | jq -r '.clientId')
  TENANT_ID=$(echo "$SP_OUTPUT" | jq -r '.tenantId')
fi

echo "Creating Managed Identity..."
az identity create \
  --name "$SERVICE_PRINCIPAL_NAME" \
  --resource-group "$RESOURCE_GROUP" || true

echo "Creating Federated Identity Credential..."
CRED_NAME="github-${GITHUB_REPO}-main"
az identity federated-credential create \
  --name "$CRED_NAME" \
  --identity-name "$SERVICE_PRINCIPAL_NAME" \
  --resource-group "$RESOURCE_GROUP" \
  --issuer "https://token.actions.githubusercontent.com" \
  --subject "repo:${GITHUB_OWNER}/${GITHUB_REPO}:ref:refs/heads/main" \
  --audiences "api://AzureADTokenExchange" 2>/dev/null || true

echo "Creating Container App Environment..."
az containerapp env create \
  --name "$CONTAINER_APP_ENV" \
  --resource-group "$RESOURCE_GROUP" \
  --location "$LOCATION" || true

echo "Creating Container App..."
az containerapp create \
  --name "$CONTAINER_APP_NAME" \
  --resource-group "$RESOURCE_GROUP" \
  --environment "$CONTAINER_APP_ENV" \
  --image "ghcr.io/${GITHUB_OWNER}/Edge-AI-APP:latest" \
  --target-port 3000 \
  --ingress external \
  --cpu 0.5 \
  --memory 1Gi \
  --min-replicas 1 \
  --max-replicas 5 \
  --env-vars \
    VITE_ANALYTICS_ENDPOINT="https://analytics.example.com" \
    VITE_ANALYTICS_WEBSITE_ID="default" \
    VITE_APP_TITLE="Edge AI App" \
    VITE_APP_LOGO="/logo.svg" || true

CONTAINER_APP_FQDN=$(az containerapp show \
  --name "$CONTAINER_APP_NAME" \
  --resource-group "$RESOURCE_GROUP" \
  --query "properties.configuration.ingress.fqdn" -o tsv)

echo "Creating Storage Account..."
az storage account create \
  --name "$STORAGE_ACCOUNT_NAME" \
  --resource-group "$RESOURCE_GROUP" \
  --location "$LOCATION" \
  --sku Standard_LRS || true

echo "Creating Function App..."
az functionapp create \
  --resource-group "$RESOURCE_GROUP" \
  --consumption-plan-location "$LOCATION" \
  --runtime node \
  --runtime-version 20 \
  --functions-version 4 \
  --name "$FUNCTION_APP_NAME" \
  --storage-account "$STORAGE_ACCOUNT_NAME" || true

FUNCTION_APP_HOSTNAME=$(az functionapp show \
  --name "$FUNCTION_APP_NAME" \
  --resource-group "$RESOURCE_GROUP" \
  --query "defaultHostName" -o tsv)

echo "Getting Function App Publish Profile..."
PUBLISH_PROFILE=$(az functionapp deployment list-publishing-profiles \
  --name "$FUNCTION_APP_NAME" \
  --resource-group "$RESOURCE_GROUP" \
  --xml | base64 -w 0)

echo "Configuring Function App settings..."
az functionapp config appsettings set \
  --name "$FUNCTION_APP_NAME" \
  --resource-group "$RESOURCE_GROUP" \
  --settings \
    VITE_ANALYTICS_ENDPOINT="https://analytics.example.com" \
    VITE_ANALYTICS_WEBSITE_ID="default" \
    VITE_APP_TITLE="Edge AI App" \
    VITE_APP_LOGO="/logo.svg" \
    ENABLE_MSAL_LOGGING="false" \
    ASPNETCORE_ENVIRONMENT="Production"

# Save values to file
cat > azure-values.env << EOF
AZURE_CLIENT_ID=$CLIENT_ID
AZURE_TENANT_ID=$TENANT_ID
AZURE_SUBSCRIPTION_ID=$SUBSCRIPTION_ID
AZURE_RESOURCE_GROUP=$RESOURCE_GROUP
AZURE_CONTAINER_APP_NAME=$CONTAINER_APP_NAME
AZURE_FUNCTION_APP_NAME=$FUNCTION_APP_NAME
AZURE_FUNCTION_PUBLISH_PROFILE=$PUBLISH_PROFILE
CONTAINER_APP_URL=https://$CONTAINER_APP_FQDN
FUNCTION_APP_URL=https://$FUNCTION_APP_HOSTNAME
EOF

echo ""
echo "✓ Azure setup completed!"
echo ""
echo "📋 Values saved to: azure-values.env"
echo ""
echo "📝 Next step: Add secrets to GitHub"
echo ""
```

## 🔐 Passo 3: Adicionar Secrets no GitHub

Depois que o script terminar, execute:

```bash
# Fazer login no GitHub
gh auth login

# Adicionar secrets
gh secret set AZURE_CLIENT_ID --body "$(grep AZURE_CLIENT_ID azure-values.env | cut -d'=' -f2)" \
  --repo alexandrepedrosaai/Edge-AI-APP

gh secret set AZURE_TENANT_ID --body "$(grep AZURE_TENANT_ID azure-values.env | cut -d'=' -f2)" \
  --repo alexandrepedrosaai/Edge-AI-APP

gh secret set AZURE_RESOURCE_GROUP --body "$(grep AZURE_RESOURCE_GROUP azure-values.env | cut -d'=' -f2)" \
  --repo alexandrepedrosaai/Edge-AI-APP

gh secret set AZURE_CONTAINER_APP_NAME --body "$(grep AZURE_CONTAINER_APP_NAME azure-values.env | cut -d'=' -f2)" \
  --repo alexandrepedrosaai/Edge-AI-APP

gh secret set AZURE_FUNCTION_APP_NAME --body "$(grep AZURE_FUNCTION_APP_NAME azure-values.env | cut -d'=' -f2)" \
  --repo alexandrepedrosaai/Edge-AI-APP

gh secret set AZURE_FUNCTION_PUBLISH_PROFILE --body "$(grep AZURE_FUNCTION_PUBLISH_PROFILE azure-values.env | cut -d'=' -f2)" \
  --repo alexandrepedrosaai/Edge-AI-APP
```

## ✅ Passo 4: Verificar Configuração

```bash
# Verificar secrets no GitHub
gh secret list --repo alexandrepedrosaai/Edge-AI-APP

# Verificar variáveis
gh variable list --repo alexandrepedrosaai/Edge-AI-APP
```

## 🚀 Passo 5: Testar Workflows

```bash
# Disparar build workflow
gh workflow run build-and-test.yml --ref main

# Disparar Azure Container App deployment
gh workflow run azure-container-app.yml --ref main

# Ver status
gh run list --repo alexandrepedrosaai/Edge-AI-APP
```

## 📊 Valores Esperados

Após executar o script, você terá:

| Recurso | Valor |
|---------|-------|
| **Resource Group** | `edge-ai-rg` |
| **Container App** | `edge-ai-app` |
| **Function App** | `edge-ai-functions` |
| **Storage Account** | `edgaistorageacct` |
| **Client ID** | `<gerado>` |
| **Tenant ID** | `<gerado>` |

## 🆘 Troubleshooting

### Erro: "Subscription not found"

```bash
# Verificar subscriptions
az account list --output table

# Definir subscription
az account set --subscription "f7fc86dd-bd9f-43a6-80a4-0bb6cab950ec"
```

### Erro: "Resource already exists"

O script já trata isso com `|| true`, então pode executar novamente com segurança.

### Erro: "GitHub secret not found"

```bash
# Verificar se gh está autenticado
gh auth status

# Fazer login novamente
gh auth login
```

## 📝 Checklist

- [ ] Azure CLI instalado
- [ ] GitHub CLI instalado
- [ ] Fazer login no Azure
- [ ] Executar script de setup
- [ ] Copiar valores de `azure-values.env`
- [ ] Adicionar secrets no GitHub
- [ ] Verificar secrets
- [ ] Testar workflows
- [ ] Verificar Container App
- [ ] Verificar Function App

## 📞 Suporte

Se encontrar problemas:

1. Verificar logs: `az group list --output table`
2. Verificar secrets: `gh secret list`
3. Verificar workflows: `gh run list`
4. Consultar documentação: `SETUP_INSTRUCTIONS.md`

---

**Última atualização**: 2026-03-18
**Status**: ✅ Pronto para execução local
