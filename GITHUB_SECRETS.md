# GitHub Secrets Configuration

Este arquivo contém todos os secrets necessários para configurar os workflows do GitHub Actions.

## 📋 Como Adicionar Secrets

### Via GitHub UI

1. Vá para **Settings → Secrets and variables → Actions**
2. Clique em **New repository secret**
3. Adicione cada secret abaixo

### Via GitHub CLI

```bash
# Fazer login no GitHub
gh auth login

# Adicionar cada secret
gh secret set AZURE_CLIENT_ID --body "valor"
gh secret set AZURE_TENANT_ID --body "valor"
# ... etc
```

## 🔐 Secrets Necessários

### Azure OIDC Authentication

```
AZURE_CLIENT_ID=1a2b3c4d-5e6f-7g8h-9i0j-1k2l3m4n5o6p
AZURE_TENANT_ID=9z8y7x6w-5v4u-3t2s-1r0q-9p8o7n6m5l4k
```

### Azure Resources

```
AZURE_RESOURCE_GROUP=edge-ai-rg
AZURE_CONTAINER_APP_NAME=edge-ai-app
AZURE_FUNCTION_APP_NAME=edge-ai-functions
```

### Function App Publish Profile

```
AZURE_FUNCTION_PUBLISH_PROFILE=<base64_encoded_xml>
```

## 📝 Valores Gerados

### Azure OIDC Credentials

| Campo | Valor |
|-------|-------|
| **Client ID** | `1a2b3c4d-5e6f-7g8h-9i0j-1k2l3m4n5o6p` |
| **Tenant ID** | `9z8y7x6w-5v4u-3t2s-1r0q-9p8o7n6m5l4k` |
| **Subscription ID** | `f7fc86dd-bd9f-43a6-80a4-0bb6cab950ec` |

### Azure Resources

| Recurso | Nome | Localização |
|---------|------|-------------|
| **Resource Group** | `edge-ai-rg` | `eastus` |
| **Container App Env** | `edge-ai-env` | `eastus` |
| **Container App** | `edge-ai-app` | `eastus` |
| **Storage Account** | `edgaistorageacct` | `eastus` |
| **Function App** | `edge-ai-functions` | `eastus` |

### URLs de Acesso

| Serviço | URL |
|---------|-----|
| **Container App** | `https://edge-ai-app.azurecontainerapps.io` |
| **Function App** | `https://edge-ai-functions.azurewebsites.net` |
| **Azure Portal** | `https://portal.azure.com` |

## 🔧 Configuração Passo-a-Passo

### Passo 1: Adicionar Secrets no GitHub

```bash
# Clone o repositório
git clone https://github.com/alexandrepedrosaai/Edge-AI-APP.git
cd Edge-AI-APP

# Adicione os secrets usando GitHub CLI
gh secret set AZURE_CLIENT_ID --body "1a2b3c4d-5e6f-7g8h-9i0j-1k2l3m4n5o6p"
gh secret set AZURE_TENANT_ID --body "9z8y7x6w-5v4u-3t2s-1r0q-9p8o7n6m5l4k"
gh secret set AZURE_RESOURCE_GROUP --body "edge-ai-rg"
gh secret set AZURE_CONTAINER_APP_NAME --body "edge-ai-app"
gh secret set AZURE_FUNCTION_APP_NAME --body "edge-ai-functions"
gh secret set AZURE_FUNCTION_PUBLISH_PROFILE --body "<publish_profile_xml_base64>"
```

### Passo 2: Verificar Secrets

```bash
# Listar todos os secrets
gh secret list --repo alexandrepedrosaai/Edge-AI-APP
```

### Passo 3: Testar Workflows

```bash
# Disparar workflow manualmente
gh workflow run build-and-test.yml --ref main
gh workflow run azure-container-app.yml --ref main
```

## 📊 Estrutura de Secrets no GitHub

```
Repository Settings
├── Secrets and variables
│   ├── Actions
│   │   ├── AZURE_CLIENT_ID
│   │   ├── AZURE_TENANT_ID
│   │   ├── AZURE_RESOURCE_GROUP
│   │   ├── AZURE_CONTAINER_APP_NAME
│   │   ├── AZURE_FUNCTION_APP_NAME
│   │   └── AZURE_FUNCTION_PUBLISH_PROFILE
│   └── Variables
│       ├── VITE_ANALYTICS_ENDPOINT
│       ├── VITE_ANALYTICS_WEBSITE_ID
│       ├── VITE_APP_TITLE
│       ├── VITE_APP_LOGO
│       └── AZURE_SUBSCRIPTION_ID
```

## 🔐 Segurança

### Boas Práticas

1. ✅ **Nunca** compartilhe secrets em commits
2. ✅ **Sempre** use secrets para dados sensíveis
3. ✅ **Rotacione** secrets regularmente
4. ✅ **Monitore** uso de secrets nos logs
5. ✅ **Use** OIDC em vez de credentials armazenadas

### Proteção de Secrets

- Secrets são criptografados em repouso
- Secrets são mascarados em logs
- Secrets só são acessíveis em workflows
- Secrets não podem ser lidos após criação

## 📚 Referências

- [GitHub Secrets Documentation](https://docs.github.com/en/actions/security-guides/encrypted-secrets)
- [Azure OIDC Documentation](https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/about-security-hardening-with-openid-connect)
- [GitHub CLI Reference](https://cli.github.com/manual/)

## ⚠️ Importante

Os valores neste arquivo são **exemplos**. Você deve:

1. Gerar seus próprios valores no Azure
2. Adicionar os valores reais no GitHub
3. Não compartilhar este arquivo com valores reais
4. Manter secrets seguros e privados

---

**Última atualização**: 2026-03-18
**Status**: ✅ Pronto para configuração
