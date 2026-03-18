# Azure Deployment Guide - Edge AI App

Este guia fornece instruções completas para configurar e fazer deploy da aplicação Edge AI no Azure usando GitHub Actions com autenticação OIDC (Managed Identity).

## 📋 Pré-requisitos

- Conta Azure ativa com acesso administrativo
- Subscription ID: `f7fc86dd-bd9f-43a6-80a4-0bb6cab950ec`
- Repositório GitHub com acesso de administrador
- Azure CLI instalado localmente (opcional, para testes)

## 🏗️ Arquitetura de Deployment

```
┌─────────────────────────────────────────────────────────┐
│                   GitHub Actions                         │
│  ┌──────────────────────────────────────────────────┐   │
│  │ 1. Build Docker Image                            │   │
│  │ 2. Push to GitHub Container Registry (GHCR)     │   │
│  │ 3. Security Scan (Trivy)                         │   │
│  └──────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────┘
                          │
                          ▼
┌─────────────────────────────────────────────────────────┐
│                    Azure Login (OIDC)                    │
│  ┌──────────────────────────────────────────────────┐   │
│  │ Federated Identity Credential                    │   │
│  │ No secrets stored in GitHub                      │   │
│  └──────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────┘
                          │
                ┌─────────┴─────────┐
                ▼                   ▼
        ┌─────────────────┐  ┌──────────────────┐
        │ Container App   │  │ Function App     │
        │ (Web Frontend)  │  │ (Backend APIs)   │
        └─────────────────┘  └──────────────────┘
```

## 🔐 Configuração de Segurança (OIDC)

### Passo 1: Criar Service Principal no Azure

```bash
# Login no Azure
az login

# Criar Service Principal
az ad sp create-for-rbac \
  --name "github-edge-ai-app" \
  --role contributor \
  --scopes "/subscriptions/f7fc86dd-bd9f-43a6-80a4-0bb6cab950ec" \
  --json-auth
```

Salve a saída JSON com:
- `clientId` (AZURE_CLIENT_ID)
- `tenantId` (AZURE_TENANT_ID)
- `subscriptionId` (AZURE_SUBSCRIPTION_ID)

### Passo 2: Configurar Federated Identity Credential

```bash
# Variáveis
GITHUB_OWNER="alexandrepedrosaai"
GITHUB_REPO="Edge-AI-APP"
SERVICE_PRINCIPAL_ID=$(az ad sp list --display-name "github-edge-ai-app" --query "[0].id" -o tsv)

# Criar credencial federada para branch main
az identity federated-credential create \
  --name "github-edge-ai-app-main" \
  --identity-name "github-edge-ai-app" \
  --resource-group "edge-ai-rg" \
  --issuer "https://token.actions.githubusercontent.com" \
  --subject "repo:${GITHUB_OWNER}/${GITHUB_REPO}:ref:refs/heads/main" \
  --audiences "api://AzureADTokenExchange"
```

### Passo 3: Adicionar Secrets no GitHub

Vá para **Settings → Secrets and variables → Actions** e adicione:

```
AZURE_CLIENT_ID=<valor_do_clientId>
AZURE_TENANT_ID=<valor_do_tenantId>
AZURE_RESOURCE_GROUP=edge-ai-rg
AZURE_CONTAINER_APP_NAME=edge-ai-app
AZURE_FUNCTION_APP_NAME=edge-ai-functions
AZURE_FUNCTION_PUBLISH_PROFILE=<valor_do_publish_profile>
```

## 🚀 Deployment - Container App

### Passo 1: Criar Resource Group

```bash
az group create \
  --name edge-ai-rg \
  --location eastus
```

### Passo 2: Criar Container App Environment

```bash
az containerapp env create \
  --name edge-ai-env \
  --resource-group edge-ai-rg \
  --location eastus
```

### Passo 3: Criar Container App

```bash
az containerapp create \
  --name edge-ai-app \
  --resource-group edge-ai-rg \
  --environment edge-ai-env \
  --image ghcr.io/alexandrepedrosaai/Edge-AI-APP:latest \
  --target-port 3000 \
  --ingress external \
  --query properties.configuration.ingress.fqdn
```

### Passo 4: Configurar Variáveis de Ambiente

```bash
az containerapp update \
  --name edge-ai-app \
  --resource-group edge-ai-rg \
  --set-env-vars \
    VITE_ANALYTICS_ENDPOINT="https://analytics.example.com" \
    VITE_ANALYTICS_WEBSITE_ID="default" \
    VITE_APP_TITLE="Edge AI App" \
    VITE_APP_LOGO="/logo.svg"
```

### Passo 5: Configurar Auto-scaling

```bash
az containerapp update \
  --name edge-ai-app \
  --resource-group edge-ai-rg \
  --min-replicas 1 \
  --max-replicas 5 \
  --scale-rule-name cpu-scale \
  --scale-rule-type cpu \
  --scale-rule-metadata "type=Utilization" "value=70"
```

## 🔧 Deployment - Function App

### Passo 1: Criar Storage Account

```bash
az storage account create \
  --name edgaistorageacct \
  --resource-group edge-ai-rg \
  --location eastus \
  --sku Standard_LRS
```

### Passo 2: Criar Function App

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

### Passo 3: Obter Publish Profile

```bash
az functionapp deployment list-publishing-profiles \
  --name edge-ai-functions \
  --resource-group edge-ai-rg \
  --xml
```

Copie o XML completo e adicione como secret `AZURE_FUNCTION_PUBLISH_PROFILE` no GitHub.

### Passo 4: Configurar Variáveis de Ambiente

```bash
az functionapp config appsettings set \
  --name edge-ai-functions \
  --resource-group edge-ai-rg \
  --settings \
    VITE_ANALYTICS_ENDPOINT="https://analytics.example.com" \
    VITE_ANALYTICS_WEBSITE_ID="default" \
    VITE_APP_TITLE="Edge AI App" \
    VITE_APP_LOGO="/logo.svg"
```

## 📊 Workflows GitHub Actions

### 1. **Build & Test** (`build-and-test.yml`)
- Testa com Node.js 20.x
- Instala dependências (Node.js, Python, Assembly)
- Executa build Vite
- Faz upload de artefatos

**Trigger**: Push em `main` ou `develop`

### 2. **Test Multi-Node** (`test-multi-node.yml`)
- Testa com Node.js 20.x e 22.x
- Garante compatibilidade entre versões

**Trigger**: Push em `main` ou `develop`

### 3. **Docker Build** (`docker-build.yml`)
- Constrói imagem Docker
- Push para GitHub Container Registry
- Scan de segurança com Trivy
- Cria múltiplas tags (branch, semver, sha)

**Trigger**: Mudanças em Dockerfile ou código

### 4. **Azure Container App** (`azure-container-app.yml`)
- Build e push da imagem Docker
- Deploy para Azure Container App
- Verificação de saúde
- Rollback automático em caso de falha

**Trigger**: Push em `main` (manual ou automático)

**Secrets necessários**:
- `AZURE_CLIENT_ID`
- `AZURE_TENANT_ID`
- `AZURE_RESOURCE_GROUP`
- `AZURE_CONTAINER_APP_NAME`

### 5. **Azure Function App** (`azure-function-app.yml`)
- Build do código Node.js/Python
- Deploy para Azure Function App
- Configuração de settings
- Rollback em caso de falha

**Trigger**: Push em `main` (manual ou automático)

**Secrets necessários**:
- `AZURE_CLIENT_ID`
- `AZURE_TENANT_ID`
- `AZURE_RESOURCE_GROUP`
- `AZURE_FUNCTION_APP_NAME`
- `AZURE_FUNCTION_PUBLISH_PROFILE`

## 🧪 Testes Locais

### Testar Build Vite

```bash
# Instalar dependências
pnpm install

# Build
pnpm run build

# Verificar output
ls -lh dist/
```

### Testar Docker Build

```bash
# Build local
docker build -t edge-ai-app:local .

# Verificar
docker image inspect edge-ai-app:local

# Testar
docker run -p 3000:3000 edge-ai-app:local
```

### Testar Azure Login (OIDC)

```bash
# Usar Azure CLI para simular OIDC
az login --service-principal \
  -u $AZURE_CLIENT_ID \
  -p $AZURE_CLIENT_SECRET \
  --tenant $AZURE_TENANT_ID
```

## 📈 Monitoramento

### Container App

```bash
# Ver logs
az containerapp logs show \
  --name edge-ai-app \
  --resource-group edge-ai-rg \
  --follow

# Ver métricas
az monitor metrics list \
  --resource-group edge-ai-rg \
  --resource-type "Microsoft.App/containerApps" \
  --resource-names edge-ai-app
```

### Function App

```bash
# Ver logs
az functionapp log tail \
  --name edge-ai-functions \
  --resource-group edge-ai-rg

# Ver métricas
az monitor metrics list \
  --resource-group edge-ai-rg \
  --resource-type "Microsoft.Web/sites" \
  --resource-names edge-ai-functions
```

## 🔄 CI/CD Pipeline Completo

```
1. Developer faz push para main
   ↓
2. GitHub Actions dispara workflows
   ├─ Build & Test (Node.js 20.x)
   ├─ Test Multi-Node (20.x, 22.x)
   ├─ Docker Build & Push
   └─ SBOM Generation
   ↓
3. Se tudo passar, dispara:
   ├─ Azure Container App Deploy
   └─ Azure Function App Deploy
   ↓
4. Verificações de saúde
   ├─ Health checks
   ├─ Smoke tests
   └─ Monitoring
   ↓
5. Notificações
   ├─ Slack/Teams (opcional)
   └─ GitHub Status
```

## 🆘 Troubleshooting

### Erro: "OIDC token not valid"
- Verificar se Federated Identity Credential está configurado
- Verificar se o subject no credential matches o repositório
- Verificar se o Service Principal tem permissões

### Erro: "Image not found in registry"
- Verificar se Docker build passou
- Verificar se push para GHCR foi bem-sucedido
- Verificar credenciais do GHCR

### Erro: "Container App deployment failed"
- Verificar logs: `az containerapp logs show`
- Verificar se variáveis de ambiente estão corretas
- Verificar se porta 3000 está exposta

### Erro: "Function App deployment failed"
- Verificar se publish profile é válido
- Verificar se arquivo `function.json` existe
- Verificar logs: `az functionapp log tail`

## 📚 Recursos Adicionais

- [Azure Container Apps Documentation](https://learn.microsoft.com/en-us/azure/container-apps/)
- [Azure Functions Documentation](https://learn.microsoft.com/en-us/azure/azure-functions/)
- [GitHub Actions OIDC](https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/about-security-hardening-with-openid-connect)
- [Azure CLI Reference](https://learn.microsoft.com/en-us/cli/azure/reference-index)

## 📞 Suporte

Para problemas ou dúvidas:
1. Verificar logs do GitHub Actions
2. Verificar logs do Azure
3. Consultar documentação oficial
4. Abrir issue no repositório

---

**Última atualização**: 2026-03-18
**Versão**: 1.0.0
