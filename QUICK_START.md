# ⚡ Quick Start - Run All Workflows

Guia rápido para disparar todos os workflows e monitorar o progresso.

## 🚀 Começar Agora

### Passo 1: Fazer Login no GitHub

```bash
gh auth login
```

### Passo 2: Clonar o Repositório

```bash
git clone https://github.com/alexandrepedrosaai/Edge-AI-APP.git
cd Edge-AI-APP
```

### Passo 3: Executar Script

```bash
bash run-all-workflows.sh
```

O script irá:
- ✅ Verificar autenticação GitHub
- ✅ Disparar 9 workflows
- ✅ Monitorar progresso em tempo real
- ✅ Salvar resumo em arquivo

## 📊 Workflows Disparados

1. **build-and-test.yml** - Build + testes Node.js 20.x
2. **test-multi-node.yml** - Testa 20.x e 22.x
3. **docker-build.yml** - Build Docker + push
4. **docker-image.yml** - Verifica imagem Docker
5. **assembly-build.yml** - Compila código Assembly
6. **install-dependencies.yml** - Verifica dependências
7. **sbom-security.yaml** - Gera SBOMs + security scan
8. **azure-container-app.yml** - Deploy Container App
9. **azure-function-app.yml** - Deploy Function App

## ⏱️ Tempo Estimado

| Workflow | Tempo |
|----------|-------|
| build-and-test | ~2 min |
| test-multi-node | ~3 min |
| docker-build | ~5 min |
| docker-image | ~2 min |
| assembly-build | ~2 min |
| install-dependencies | ~2 min |
| sbom-security | ~2 min |
| azure-container-app | ~10 min |
| azure-function-app | ~10 min |
| **TOTAL** | **~40 min** |

## 📈 Monitorar Progresso

### Opção 1: Terminal (Auto-refresh)
```bash
# O script já faz isso automaticamente
bash run-all-workflows.sh
```

### Opção 2: GitHub UI
```
https://github.com/alexandrepedrosaai/Edge-AI-APP/actions
```

### Opção 3: GitHub CLI
```bash
# Ver todos os runs
gh run list --repo alexandrepedrosaai/Edge-AI-APP

# Ver status de um workflow
gh run list --workflow build-and-test.yml --repo alexandrepedrosaai/Edge-AI-APP

# Ver logs de um run
gh run view <run-id> --log --repo alexandrepedrosaai/Edge-AI-APP
```

### Opção 4: Azure Portal
```
https://portal.azure.com
```

## 🔍 Verificar Resultados

### Container App

```bash
# Ver status
az containerapp show \
  --name edge-ai-app \
  --resource-group edge-ai-rg \
  --query "properties.provisioningState"

# Ver logs
az containerapp logs show \
  --name edge-ai-app \
  --resource-group edge-ai-rg \
  --follow

# Acessar
curl https://edge-ai-app.azurecontainerapps.io
```

### Function App

```bash
# Ver status
az functionapp show \
  --name edge-ai-functions \
  --resource-group edge-ai-rg \
  --query "state"

# Ver logs
az functionapp log tail \
  --name edge-ai-functions \
  --resource-group edge-ai-rg

# Acessar
curl https://edge-ai-functions.azurewebsites.net/api/health
```

## 🆘 Troubleshooting

### Erro: "Not authenticated"

```bash
gh auth login
```

### Erro: "Workflow not found"

```bash
# Verificar workflows disponíveis
gh workflow list --repo alexandrepedrosaai/Edge-AI-APP
```

### Erro: "Rate limit exceeded"

Aguarde alguns minutos e tente novamente.

### Workflow falha

```bash
# Ver logs detalhados
gh run view <run-id> --log --repo alexandrepedrosaai/Edge-AI-APP

# Reexecutar
gh run rerun <run-id> --repo alexandrepedrosaai/Edge-AI-APP
```

## 📋 Checklist

- [ ] GitHub CLI instalado
- [ ] Fazer login no GitHub
- [ ] Clonar repositório
- [ ] Executar script
- [ ] Monitorar progresso
- [ ] Verificar Container App
- [ ] Verificar Function App
- [ ] Revisar logs

## 📊 Status Esperado

Após completar, você deve ver:

✅ **Build & Test**: Sucesso
✅ **Docker Build**: Sucesso
✅ **Azure Container App**: Sucesso
✅ **Azure Function App**: Sucesso
✅ **Security Scan**: Sucesso
✅ **SBOM Generation**: Sucesso

## 🎯 Próximos Passos

1. ✅ Disparar workflows
2. ✅ Monitorar progresso
3. ✅ Verificar deployments
4. ✅ Testar endpoints
5. ✅ Revisar logs
6. ✅ Configurar alertas
7. ✅ Configurar auto-scaling

## 📞 Suporte

- **GitHub Issues**: https://github.com/alexandrepedrosaai/Edge-AI-APP/issues
- **Azure Portal**: https://portal.azure.com
- **Documentation**: Veja FINAL_REPORT.md

## 📝 Arquivo de Resumo

Após executar o script, um arquivo `workflow-execution-summary.txt` será criado com:
- Lista de workflows disparados
- Comandos úteis
- Links para monitoramento

---

**Última atualização**: 2026-03-18  
**Status**: ✅ Pronto para execução  
**Tempo total**: ~40 minutos
