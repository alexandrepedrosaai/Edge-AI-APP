# Setup Completo - Edge AI App

Guia passo-a-passo para configurar o projeto Edge AI App com Azure e GitHub Actions.

## 📋 Índice

1. [Pré-requisitos](#pré-requisitos)
2. [Configuração Azure](#configuração-azure)
3. [Configuração GitHub](#configuração-github)
4. [Verificação](#verificação)
5. [Troubleshooting](#troubleshooting)

## 🔧 Pré-requisitos

- ✅ Conta Azure ativa
- ✅ Subscription ID: `f7fc86dd-bd9f-43a6-80a4-0bb6cab950ec`
- ✅ Conta GitHub com acesso ao repositório
- ✅ Azure CLI instalado (`az --version`)
- ✅ GitHub CLI instalado (`gh --version`)

## 🏗️ Configuração Azure

### Passo 1: Fazer Login no Azure

```bash
# Login interativo
az login

# Ou com credenciais
az login -u seu_email@example.com -p sua_senha
```

### Passo 2: Definir Subscription

```bash
az account set --subscription "f7fc86dd-bd9f-43a6-80a4-0bb6cab950ec"

# Verificar
az account show
```

### Passo 3: Criar Resource Group

```bash
az group create \
  --name edge-ai-rg \
  --location eastus
```

### Passo 4: Criar Service Principal

```bash
# Criar Service Principal
az ad sp create-for-rbac \
  --name github-edge-ai-app \
  --role contributor \
  --scopes "/subscriptions/f7fc86dd-bd9f-43a6-80a4-0bb6cab950ec" \
  --json-auth
```

**Salve a saída JSON com:**
- `clientId` → `AZURE_CLIENT_ID`
- `tenantId` → `AZURE_TENANT_ID`
- `subscriptionId` → `AZURE_SUBSCRIPTION_ID`

### Passo 5: Criar Managed Identity

```bash
az identity create \
  --name github-edge-ai-app \
  --resource-group edge-ai-rg
```

### Passo 6: Criar Federated Identity Credential

```bash
az identity federated-credential create \
  --name github-edge-ai-app-main \
  --identity-name github-edge-ai-app \
  --resource-group edge-ai-rg \
  --issuer "https://token.actions.githubusercontent.com" \
  --subject "repo:alexandrepedrosaai/Edge-AI-APP:ref:refs/heads/main" \
  --audiences "api://AzureADTokenExchange"
```

### Passo 7: Criar Container App Environment

```bash
az containerapp env create \
  --name edge-ai-env \
  --resource-group edge-ai-rg \
  --location eastus
```

### Passo 8: Criar Container App

```bash
az containerapp create \
  --name edge-ai-app \
  --resource-group edge-ai-rg \
  --environment edge-ai-env \
  --image ghcr.io/alexandrepedrosaai/Edge-AI-APP:latest \
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
    VITE_APP_LOGO="/logo.svg"
```

### Passo 9: Criar Storage Account

```bash
az storage account create \
  --name edgaistorageacct \
  --resource-group edge-ai-rg \
  --location eastus \
  --sku Standard_LRS
```

### Passo 10: Criar Function App

```bash
az functionapp create \
  --resource-group edge-ai-rg \
  --consumption-plan-location eastus \
  --runtime node \
  --runtime-version 20 \
  --functions-version 4 \
  --name edge-ai-functions \
  --storage-account edgaistorageacct
```

### Passo 11: Obter Publish Profile

```bash
# Salvar em arquivo
az functionapp deployment list-publishing-profiles \
  --name edge-ai-functions \
  --resource-group edge-ai-rg \
  --xml > publish-profile.xml

# Converter para base64
cat publish-profile.xml | base64 -w 0 > publish-profile.b64
```

## 🔐 Configuração GitHub

### Passo 1: Fazer Login no GitHub CLI

```bash
gh auth login

# Selecione:
# - GitHub.com
# - HTTPS
# - Y (authenticate with GitHub credentials)
# - Paste authentication token
```

### Passo 2: Adicionar Secrets

```bash
# Substitua os valores pelos reais do Azure
gh secret set AZURE_CLIENT_ID --body "seu_client_id" \
  --repo alexandrepedrosaai/Edge-AI-APP

gh secret set AZURE_TENANT_ID --body "seu_tenant_id" \
  --repo alexandrepedrosaai/Edge-AI-APP

gh secret set AZURE_RESOURCE_GROUP --body "edge-ai-rg" \
  --repo alexandrepedrosaai/Edge-AI-APP

gh secret set AZURE_CONTAINER_APP_NAME --body "edge-ai-app" \
  --repo alexandrepedrosaai/Edge-AI-APP

gh secret set AZURE_FUNCTION_APP_NAME --body "edge-ai-functions" \
  --repo alexandrepedrosaai/Edge-AI-APP

gh secret set AZURE_FUNCTION_PUBLISH_PROFILE --body "$(cat publish-profile.b64)" \
  --repo alexandrepedrosaai/Edge-AI-APP
```

### Passo 3: Adicionar Variáveis

```bash
gh variable set VITE_ANALYTICS_ENDPOINT --body "https://analytics.example.com" \
  --repo alexandrepedrosaai/Edge-AI-APP

gh variable set VITE_ANALYTICS_WEBSITE_ID --body "default" \
  --repo alexandrepedrosaai/Edge-AI-APP

gh variable set VITE_APP_TITLE --body "Edge AI App" \
  --repo alexandrepedrosaai/Edge-AI-APP

gh variable set VITE_APP_LOGO --body "/logo.svg" \
  --repo alexandrepedrosaai/Edge-AI-APP

gh variable set AZURE_SUBSCRIPTION_ID --body "f7fc86dd-bd9f-43a6-80a4-0bb6cab950ec" \
  --repo alexandrepedrosaai/Edge-AI-APP
```

### Passo 4: Verificar Secrets

```bash
gh secret list --repo alexandrepedrosaai/Edge-AI-APP
gh variable list --repo alexandrepedrosaai/Edge-AI-APP
```

## ✅ Verificação

### Verificar Recursos Azure

```bash
# Listar resource groups
az group list --output table

# Listar container apps
az containerapp list --resource-group edge-ai-rg --output table

# Listar function apps
az functionapp list --resource-group edge-ai-rg --output table
```

### Verificar Secrets GitHub

```bash
# Listar secrets
gh secret list --repo alexandrepedrosaai/Edge-AI-APP

# Listar variáveis
gh variable list --repo alexandrepedrosaai/Edge-AI-APP
```

### Testar Workflows

```bash
# Disparar build workflow
gh workflow run build-and-test.yml --ref main

# Disparar docker workflow
gh workflow run docker-build.yml --ref main

# Disparar azure container app workflow
gh workflow run azure-container-app.yml --ref main

# Ver status
gh run list --repo alexandrepedrosaai/Edge-AI-APP
```

## 🆘 Troubleshooting

### Erro: "Subscription not found"

**Solução**:
```bash
# Verificar subscriptions disponíveis
az account list --output table

# Definir subscription correta
az account set --subscription "f7fc86dd-bd9f-43a6-80a4-0bb6cab950ec"
```

### Erro: "Resource group not found"

**Solução**:
```bash
# Criar resource group
az group create --name edge-ai-rg --location eastus

# Verificar
az group list --output table
```

### Erro: "OIDC token not valid"

**Solução**:
1. Verificar Federated Identity Credential
2. Verificar se subject matches o repositório
3. Verificar se issuer está correto

```bash
# Listar federated credentials
az identity federated-credential list \
  --identity-name github-edge-ai-app \
  --resource-group edge-ai-rg
```

### Erro: "GitHub secret not found"

**Solução**:
```bash
# Verificar se secret foi adicionado
gh secret list --repo alexandrepedrosaai/Edge-AI-APP

# Adicionar novamente
gh secret set NOME_DO_SECRET --body "valor" \
  --repo alexandrepedrosaai/Edge-AI-APP
```

### Erro: "Container App deployment failed"

**Solução**:
```bash
# Ver logs
az containerapp logs show \
  --name edge-ai-app \
  --resource-group edge-ai-rg \
  --follow

# Verificar status
az containerapp show \
  --name edge-ai-app \
  --resource-group edge-ai-rg \
  --query "properties.provisioningState"
```

## 📊 Checklist Final

- [ ] Azure CLI instalado e configurado
- [ ] GitHub CLI instalado e autenticado
- [ ] Resource Group criado
- [ ] Service Principal criado
- [ ] Federated Identity Credential configurado
- [ ] Container App Environment criado
- [ ] Container App criado
- [ ] Storage Account criado
- [ ] Function App criado
- [ ] Publish Profile obtido
- [ ] Secrets adicionados no GitHub
- [ ] Variáveis adicionadas no GitHub
- [ ] Workflows testados
- [ ] Container App acessível
- [ ] Function App acessível

## 📚 Recursos Adicionais

- [Azure CLI Documentation](https://learn.microsoft.com/en-us/cli/azure/)
- [GitHub CLI Documentation](https://cli.github.com/manual/)
- [Azure Container Apps](https://learn.microsoft.com/en-us/azure/container-apps/)
- [Azure Functions](https://learn.microsoft.com/en-us/azure/azure-functions/)
- [GitHub Actions OIDC](https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/about-security-hardening-with-openid-connect)

## 📞 Suporte

Para problemas:
1. Verificar logs em Azure Portal
2. Verificar logs em GitHub Actions
3. Consultar documentação oficial
4. Abrir issue no repositório

---

**Última atualização**: 2026-03-18
**Status**: ✅ Pronto para implementação
