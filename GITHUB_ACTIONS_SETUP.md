# GitHub Actions Setup Guide

Este guia fornece instruções completas para configurar todos os workflows do GitHub Actions para o projeto Edge AI App.

## 📋 Visão Geral dos Workflows

| Workflow | Trigger | Propósito |
|----------|---------|----------|
| **Build & Test** | Push em main/develop | Testa build Vite com Node.js 20.x |
| **Test Multi-Node** | Push em main/develop | Testa compatibilidade Node.js 20.x e 22.x |
| **Docker Build** | Push com mudanças Dockerfile | Constrói e faz push de imagem Docker |
| **Docker Image CI** | Push em main | Constrói e verifica imagem Docker |
| **Assembly Build** | Push em .ASM_HEX/ | Compila código Assembly |
| **Install Dependencies** | Push em package.json | Verifica instalação de dependências |
| **Generate SBOMs** | Push em main/develop | Gera SBOMs de segurança |
| **Azure Container App** | Push em main (manual) | Deploy para Azure Container App |
| **Azure Function App** | Push em main (manual) | Deploy para Azure Function App |

## 🔐 Configuração de Secrets

### Passo 1: Adicionar Secrets no GitHub

Vá para **Settings → Secrets and variables → Actions** e adicione:

#### Secrets Obrigatórios

```
# Azure OIDC
AZURE_CLIENT_ID=<seu_client_id>
AZURE_TENANT_ID=<seu_tenant_id>

# Azure Resources
AZURE_RESOURCE_GROUP=edge-ai-rg
AZURE_CONTAINER_APP_NAME=edge-ai-app
AZURE_FUNCTION_APP_NAME=edge-ai-functions
AZURE_FUNCTION_PUBLISH_PROFILE=<seu_publish_profile>

# Docker Hub (opcional)
DOCKERHUB_USERNAME=<seu_username>
DOCKERHUB_PASSWORD=<seu_token>
```

#### Secrets Opcionais

```
# Notificações
SLACK_WEBHOOK_URL=<seu_webhook>
TEAMS_WEBHOOK_URL=<seu_webhook>

# Analytics
ANALYTICS_API_KEY=<seu_api_key>
```

### Passo 2: Adicionar Variáveis de Ambiente

Vá para **Settings → Secrets and variables → Variables** e adicione:

```
# Build
VITE_ANALYTICS_ENDPOINT=https://analytics.example.com
VITE_ANALYTICS_WEBSITE_ID=default
VITE_APP_TITLE=Edge AI App
VITE_APP_LOGO=/logo.svg

# Azure
AZURE_SUBSCRIPTION_ID=f7fc86dd-bd9f-43a6-80a4-0bb6cab950ec
AZURE_LOCATION=eastus
```

## 🚀 Executar Workflows Manualmente

### Via GitHub UI

1. Vá para **Actions**
2. Selecione o workflow desejado
3. Clique em **Run workflow**
4. Selecione a branch (main/develop)
5. Clique em **Run workflow**

### Via GitHub CLI

```bash
# Build & Test
gh workflow run build-and-test.yml --ref main

# Test Multi-Node
gh workflow run test-multi-node.yml --ref main

# Docker Build
gh workflow run docker-build.yml --ref main

# Azure Container App
gh workflow run azure-container-app.yml --ref main

# Azure Function App
gh workflow run azure-function-app.yml --ref main
```

### Via cURL

```bash
# Obter workflow ID
WORKFLOW_ID=$(gh api repos/alexandrepedrosaai/Edge-AI-APP/actions/workflows \
  --jq '.workflows[] | select(.name=="Build & Test") | .id')

# Disparar workflow
gh api repos/alexandrepedrosaai/Edge-AI-APP/actions/workflows/$WORKFLOW_ID/dispatches \
  -f ref=main
```

## 📊 Monitorar Workflows

### Via GitHub UI

1. Vá para **Actions**
2. Clique no workflow desejado
3. Veja o status em tempo real

### Via GitHub CLI

```bash
# Listar últimas execuções
gh run list --repo alexandrepedrosaai/Edge-AI-APP

# Ver detalhes de uma execução
gh run view <run_id> --repo alexandrepedrosaai/Edge-AI-APP

# Ver logs
gh run view <run_id> --log --repo alexandrepedrosaai/Edge-AI-APP

# Cancelar execução
gh run cancel <run_id> --repo alexandrepedrosaai/Edge-AI-APP
```

### Via API REST

```bash
# Listar execuções
curl -H "Authorization: token $GITHUB_TOKEN" \
  https://api.github.com/repos/alexandrepedrosaai/Edge-AI-APP/actions/runs

# Ver detalhes
curl -H "Authorization: token $GITHUB_TOKEN" \
  https://api.github.com/repos/alexandrepedrosaai/Edge-AI-APP/actions/runs/<run_id>
```

## 🔄 Workflow Triggers

### Push Triggers

```yaml
on:
  push:
    branches: [ "main", "develop" ]
    paths:
      - 'client/**'
      - 'server/**'
      - 'package.json'
```

### Pull Request Triggers

```yaml
on:
  pull_request:
    branches: [ "main" ]
```

### Manual Triggers

```yaml
on:
  workflow_dispatch:
    inputs:
      environment:
        description: 'Deployment environment'
        required: true
        type: choice
        options:
          - staging
          - production
```

### Scheduled Triggers

```yaml
on:
  schedule:
    - cron: '0 2 * * *'  # Diariamente às 2 AM UTC
```

## 📈 Status Badges

Adicione badges ao README.md:

```markdown
![Build & Test](https://github.com/alexandrepedrosaai/Edge-AI-APP/actions/workflows/build-and-test.yml/badge.svg)
![Docker Build](https://github.com/alexandrepedrosaai/Edge-AI-APP/actions/workflows/docker-build.yml/badge.svg)
![Azure Deploy](https://github.com/alexandrepedrosaai/Edge-AI-APP/actions/workflows/azure-container-app.yml/badge.svg)
```

## 🧪 Testar Workflows Localmente

### Usando act

```bash
# Instalar act
brew install act

# Executar workflow localmente
act -j build-and-test

# Com secrets
act -j build-and-test -s GITHUB_TOKEN=$GITHUB_TOKEN
```

### Usando docker-compose

```bash
docker-compose -f docker-compose.yml up --build
```

## 🔍 Troubleshooting

### Workflow não dispara

**Problema**: Workflow não inicia após push

**Solução**:
1. Verificar se o arquivo está em `.github/workflows/`
2. Verificar sintaxe YAML: `yamllint .github/workflows/`
3. Verificar triggers (branches, paths)
4. Fazer push novamente

### Erro: "GITHUB_TOKEN permission denied"

**Problema**: Workflow não tem permissão para fazer push

**Solução**:
1. Ir para **Settings → Actions → General**
2. Selecionar "Read and write permissions"
3. Habilitar "Allow GitHub Actions to create and approve pull requests"

### Erro: "Secret not found"

**Problema**: Workflow não consegue acessar secret

**Solução**:
1. Verificar se secret foi adicionado em **Settings → Secrets**
2. Verificar nome exato do secret (case-sensitive)
3. Verificar se workflow tem acesso ao secret

### Erro: "Docker login failed"

**Problema**: Não consegue fazer push para Docker registry

**Solução**:
1. Verificar credenciais em **Settings → Secrets**
2. Verificar se token é válido
3. Verificar permissões no registry

## 📚 Recursos Adicionais

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Workflow Syntax](https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions)
- [Actions Marketplace](https://github.com/marketplace?type=actions)
- [act - Run GitHub Actions locally](https://github.com/nektos/act)

## 🎯 Checklist de Setup

- [ ] Adicionar secrets em **Settings → Secrets**
- [ ] Adicionar variáveis em **Settings → Variables**
- [ ] Configurar OIDC para Azure
- [ ] Testar workflow manualmente
- [ ] Verificar logs
- [ ] Configurar notificações (Slack/Teams)
- [ ] Adicionar badges ao README
- [ ] Documentar triggers e dependências

## 📞 Suporte

Para problemas:
1. Verificar logs do workflow em **Actions**
2. Consultar documentação oficial
3. Abrir issue no repositório

---

**Última atualização**: 2026-03-18
**Versão**: 1.0.0
