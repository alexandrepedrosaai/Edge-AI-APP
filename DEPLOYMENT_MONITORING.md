# 🚀 Deployment & Monitoring Guide - Edge AI App

Guia completo para monitorar e gerenciar deployments do Edge AI App.

## 📊 Dashboard de Status

### GitHub Actions
- **URL**: https://github.com/alexandrepedrosaai/Edge-AI-APP/actions
- **Workflows**: 11 ativos
- **Status**: Monitorar em tempo real

### Azure Portal
- **URL**: https://portal.azure.com
- **Resource Group**: `edge-ai-rg`
- **Recursos**: Container App, Function App, Storage Account

## 🔄 Workflows Disponíveis

### 1. Build & Test
```bash
gh workflow run build-and-test.yml --ref main
```
- Testa Node.js 20.x
- Build Vite
- Executa testes

### 2. Multi-Node Test
```bash
gh workflow run test-multi-node.yml --ref main
```
- Testa Node.js 20.x e 22.x
- Verifica compatibilidade

### 3. Docker Build
```bash
gh workflow run docker-build.yml --ref main
```
- Build Docker image
- Push para GHCR
- Trivy security scan

### 4. Azure Container App Deployment
```bash
gh workflow run azure-container-app.yml --ref main
```
- Build Docker image
- Deploy para Azure Container App
- Health checks
- Rollback automático

### 5. Azure Function App Deployment
```bash
gh workflow run azure-function-app.yml --ref main
```
- Build Node.js/Python
- Deploy para Azure Function App
- Configuração de settings
- Rollback automático

### 6. SBOM Security
```bash
gh workflow run sbom-security.yaml --ref main
```
- Gera SBOMs
- Security scanning
- Compliance report

## 📈 Monitoramento

### Monitorar Workflows em Tempo Real

```bash
# Ver todos os runs
gh run list --repo alexandrepedrosaai/Edge-AI-APP

# Ver status de um workflow específico
gh run list --workflow build-and-test.yml --repo alexandrepedrosaai/Edge-AI-APP

# Ver logs de um run
gh run view <run-id> --repo alexandrepedrosaai/Edge-AI-APP --log

# Monitorar em tempo real
watch -n 5 'gh run list --repo alexandrepedrosaai/Edge-AI-APP | head -10'
```

### Monitorar Azure Resources

```bash
# Container App status
az containerapp show \
  --name edge-ai-app \
  --resource-group edge-ai-rg \
  --query "properties.provisioningState"

# Container App logs
az containerapp logs show \
  --name edge-ai-app \
  --resource-group edge-ai-rg \
  --follow

# Function App status
az functionapp show \
  --name edge-ai-functions \
  --resource-group edge-ai-rg \
  --query "state"

# Function App logs
az functionapp log tail \
  --name edge-ai-functions \
  --resource-group edge-ai-rg
```

## 🔐 Verificação de Secrets

### Listar Secrets Configurados

```bash
# Via GitHub UI
# Settings → Secrets and variables → Actions

# Via CLI (requer autenticação)
gh secret list --repo alexandrepedrosaai/Edge-AI-APP
```

### Secrets Necessários

| Secret | Status | Descrição |
|--------|--------|-----------|
| AZURE_CLIENT_ID | ✅ | ID do Service Principal |
| AZURE_TENANT_ID | ✅ | ID do Tenant Azure |
| AZURE_RESOURCE_GROUP | ✅ | Nome do Resource Group |
| AZURE_CONTAINER_APP_NAME | ✅ | Nome do Container App |
| AZURE_FUNCTION_APP_NAME | ✅ | Nome do Function App |
| AZURE_FUNCTION_PUBLISH_PROFILE | ✅ | Publish Profile (base64) |

## 🚨 Troubleshooting

### Workflow Falha com "Secrets not found"

**Problema**: Workflow não consegue acessar secrets

**Solução**:
1. Verificar se secrets estão em Settings → Secrets
2. Verificar se nomes estão corretos
3. Fazer commit e push novamente

### Container App não inicia

**Problema**: Container App fica em estado "Provisioning"

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
  --query "properties"
```

### Function App não responde

**Problema**: Function App retorna erro 500

**Solução**:
```bash
# Ver logs
az functionapp log tail \
  --name edge-ai-functions \
  --resource-group edge-ai-rg

# Verificar settings
az functionapp config appsettings list \
  --name edge-ai-functions \
  --resource-group edge-ai-rg
```

### OIDC Token Inválido

**Problema**: Erro "OIDC token not valid"

**Solução**:
1. Verificar Federated Identity Credential
2. Verificar se subject matches repositório
3. Verificar se issuer está correto

```bash
# Listar federated credentials
az identity federated-credential list \
  --identity-name github-edge-ai-app \
  --resource-group edge-ai-rg
```

## 📊 Métricas e Performance

### Container App Metrics

```bash
# CPU Usage
az monitor metrics list \
  --resource-group edge-ai-rg \
  --resource-type "Microsoft.App/containerApps" \
  --resource-name edge-ai-app \
  --metric "CpuUsagePercentage"

# Memory Usage
az monitor metrics list \
  --resource-group edge-ai-rg \
  --resource-type "Microsoft.App/containerApps" \
  --resource-name edge-ai-app \
  --metric "MemoryUsagePercentage"

# Request Count
az monitor metrics list \
  --resource-group edge-ai-rg \
  --resource-type "Microsoft.App/containerApps" \
  --resource-name edge-ai-app \
  --metric "RequestCount"
```

### Function App Metrics

```bash
# Execution Count
az monitor metrics list \
  --resource-group edge-ai-rg \
  --resource-type "Microsoft.Web/sites" \
  --resource-name edge-ai-functions \
  --metric "FunctionExecutionCount"

# Execution Units
az monitor metrics list \
  --resource-group edge-ai-rg \
  --resource-type "Microsoft.Web/sites" \
  --resource-name edge-ai-functions \
  --metric "FunctionExecutionUnits"
```

## 🔄 Deployment Pipeline

### Fluxo de Deployment

```
1. Push para main
   ↓
2. GitHub Actions dispara workflows
   ↓
3. Build e testes executam
   ↓
4. Docker image construída
   ↓
5. SBOM gerado
   ↓
6. Deploy para Azure Container App
   ↓
7. Deploy para Azure Function App
   ↓
8. Health checks
   ↓
9. Rollback automático se falhar
```

### Status de Cada Etapa

```bash
# Ver status do workflow
gh run view <run-id> --repo alexandrepedrosaai/Edge-AI-APP

# Ver logs de uma etapa específica
gh run view <run-id> --log --repo alexandrepedrosaai/Edge-AI-APP
```

## 📝 Checklist de Deployment

- [ ] Secrets adicionados no GitHub
- [ ] Federated Identity Credential configurado
- [ ] Container App criado no Azure
- [ ] Function App criado no Azure
- [ ] Storage Account criado
- [ ] Workflows disparados com sucesso
- [ ] Container App acessível
- [ ] Function App acessível
- [ ] Health checks passando
- [ ] Logs sem erros

## 🎯 Próximos Passos

### Curto Prazo (Esta semana)
1. ✅ Disparar workflows de teste
2. ✅ Verificar deployments no Azure
3. ✅ Testar endpoints
4. ✅ Revisar logs

### Médio Prazo (Este mês)
1. ✅ Configurar alertas
2. ✅ Configurar auto-scaling
3. ✅ Adicionar monitoramento
4. ✅ Otimizar performance

### Longo Prazo (Este trimestre)
1. ✅ Implementar CI/CD avançado
2. ✅ Adicionar testes de carga
3. ✅ Configurar disaster recovery
4. ✅ Implementar blue-green deployment

## 📞 Contato e Suporte

- **GitHub Issues**: https://github.com/alexandrepedrosaai/Edge-AI-APP/issues
- **Azure Support**: https://portal.azure.com
- **Documentation**: Veja README.md

## 📚 Recursos Adicionais

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Azure Container Apps Documentation](https://learn.microsoft.com/en-us/azure/container-apps/)
- [Azure Functions Documentation](https://learn.microsoft.com/en-us/azure/azure-functions/)
- [GitHub CLI Reference](https://cli.github.com/manual/)

---

**Última atualização**: 2026-03-18
**Status**: ✅ Pronto para monitoramento
**Versão**: 1.0.0
