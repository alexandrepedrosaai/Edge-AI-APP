# Deployment & Monitoring Guide - Edge AI App

Guia completo para monitorar e gerenciar deployments do Edge AI App, incluindo Azure Functions, AKS/Kubernetes e pipeline de imagens de container.

## Dashboard de Status

### GitHub Actions
- **URL**: https://github.com/alexandrepedrosaai/Edge-AI-APP/actions
- **Workflows ativos**: 46 (ver lista completa em `.github/workflows/`)
- **Status**: Monitorar em tempo real

### Azure Portal
- **URL**: https://portal.azure.com
- **Resource Group**: `edge-ai-rg`
- **Recursos**: AKS Cluster, Azure Container App, Function App (`edge-ai-functions`), Storage Account

## Workflows Principais

### Build & Test
```bash
gh workflow run build-and-test.yml --ref main
```
- Testa Node.js 20.x
- Build Vite
- Executa testes

### Multi-Node Test
```bash
gh workflow run test-multi-node.yml --ref main
```
- Testa Node.js 20.x e 22.x
- Verifica compatibilidade

### Docker Build & Push
```bash
gh workflow run docker-build.yml --ref main
```
- Build Docker image
- Push para GHCR (`ghcr.io/alexandrepedrosaai/edge-ai-app`)
- Scan de segurança com Trivy

### Azure Container App Deployment
```bash
gh workflow run azure-container-app.yml --ref main
```
- Build Docker image
- Deploy para Azure Container App
- Health checks e rollback automático

### Azure Function App Deployment
```bash
gh workflow run azure-function-app.yml --ref main
```
- Build Node.js / Python
- Deploy para Azure Function App (`edge-ai-functions`)
- Configuração de settings e rollback automático

### SBOM & Security Scan
```bash
gh workflow run sbom-security.yaml --ref main
```
- Gera SBOMs (Syft/CycloneDX)
- Security scanning (Trivy)
- Relatório de conformidade

## Monitoramento de Workflows (GitHub Actions)

```bash
# Listar todos os runs recentes
gh run list --repo alexandrepedrosaai/Edge-AI-APP

# Filtrar por workflow específico
gh run list --workflow build-and-test.yml --repo alexandrepedrosaai/Edge-AI-APP

# Ver logs de um run
gh run view <run-id> --repo alexandrepedrosaai/Edge-AI-APP --log

# Monitorar em tempo real (requer watch)
watch -n 5 'gh run list --repo alexandrepedrosaai/Edge-AI-APP | head -10'
```

## Monitoramento AKS / Kubernetes

O cluster AKS hospeda os componentes principais da aplicação. Os manifests estão em `k8s/`.

### Status de Rollout dos Deployments

```bash
# Verificar status do rollout de um deployment
kubectl rollout status deployment/edge-frontend -n default
kubectl rollout status deployment/edge-backend -n default
kubectl rollout status deployment/edge-python -n default

# Histórico de revisões de um deployment
kubectl rollout history deployment/edge-backend -n default

# Desfazer último rollout (rollback)
kubectl rollout undo deployment/edge-backend -n default
```

### Status de Pods (Readiness e Liveness Probes)

```bash
# Listar todos os pods e seu estado
kubectl get pods -n default -o wide

# Descrever pod e ver eventos (inclui resultado de probes)
kubectl describe pod <nome-do-pod> -n default

# Filtrar pods por label de um deployment
kubectl get pods -l app=edge-backend -n default

# Verificar se probes estão passando
kubectl get pods -n default --field-selector=status.phase=Running
```

### Logs de Deployments e Serviços

```bash
# Seguir logs de todos os pods de um deployment
kubectl logs -f deployment/edge-backend -n default

# Logs de um pod específico (múltiplos containers: incluir -c)
kubectl logs <nome-do-pod> -n default

# Logs anteriores (container reiniciado)
kubectl logs <nome-do-pod> -n default --previous

# Últimas 100 linhas de um deployment
kubectl logs deployment/edge-frontend -n default --tail=100
```

### Verificação de Ingress e Serviços

```bash
# Listar serviços e seus endpoints
kubectl get services -n default

# Ver detalhes do ingress (host, paths, TLS)
kubectl get ingress edge-ingress -n default
kubectl describe ingress edge-ingress -n default

# Verificar endpoints ativos por serviço
kubectl get endpoints -n default

# Testar conectividade interna via port-forward
kubectl port-forward service/edge-backend-service 4000:4000 -n default
```

## Monitoramento Azure Functions

### Verificação de Status e Logs

```bash
# Status da Function App
az functionapp show \
  --name edge-ai-functions \
  --resource-group edge-ai-rg \
  --query "state"

# Seguir logs em tempo real
az functionapp log tail \
  --name edge-ai-functions \
  --resource-group edge-ai-rg

# Verificar configurações de settings
az functionapp config appsettings list \
  --name edge-ai-functions \
  --resource-group edge-ai-rg
```

### Rastreio de Requisições com `request_id`

O cabeçalho `x-ms-client-request-id` permite rastrear uma requisição específica em todos os logs do Azure Functions.

**Enviar uma requisição com request_id customizado:**
```bash
# Substituir <URL> pelo endpoint da Function App
curl -X POST https://edge-ai-functions.azurewebsites.net/api/edge-ai-inference \
  -H "Content-Type: application/json" \
  -H "x-ms-client-request-id: meu-trace-id-123" \
  -d '{"name": "test"}'
```

**Localizar logs pelo request_id no Application Insights:**
```bash
# Consulta KQL no Application Insights (Azure Portal → Monitor → Logs)
# traces
# | where customDimensions["InvocationId"] == "<invocation-id>"
#   or customDimensions["OperationId"] == "<operation-id>"

# Via CLI: listar invocações recentes
az monitor app-insights query \
  --app edge-ai-insights \
  --resource-group edge-ai-rg \
  --analytics-query "requests | where timestamp > ago(1h) | order by timestamp desc | limit 20"
```

**Onde ver os logs:**
- **Azure Portal**: Function App → Monitor → Invocations (mostra o `InvocationId` de cada execução)
- **Application Insights**: Monitor → Logs → tabela `traces` ou `requests`
- **Log Stream**: Function App → Log stream (stream ao vivo, ideal para debug imediato)
- **CLI**: `az functionapp log tail --name edge-ai-functions --resource-group edge-ai-rg`

### Métricas da Function App

```bash
# Contagem de execuções
az monitor metrics list \
  --resource-group edge-ai-rg \
  --resource-type "Microsoft.Web/sites" \
  --resource-name edge-ai-functions \
  --metric "FunctionExecutionCount"

# Unidades de execução
az monitor metrics list \
  --resource-group edge-ai-rg \
  --resource-type "Microsoft.Web/sites" \
  --resource-name edge-ai-functions \
  --metric "FunctionExecutionUnits"
```

## Verificação de Build e Deploy de Imagens de Container

### Confirmar Imagem Publicada no GHCR

```bash
# Listar tags publicadas no GitHub Container Registry
gh api /user/packages/container/edge-ai-app/versions \
  --jq '.[].metadata.container.tags[]' 2>/dev/null \
  || curl -s https://ghcr.io/v2/alexandrepedrosaai/edge-ai-app/tags/list

# Inspecionar a imagem localmente (sem baixar o filesystem)
docker manifest inspect ghcr.io/alexandrepedrosaai/edge-ai-app:main
```

### Scan de Segurança com Trivy (local)

```bash
# Scan de vulnerabilidades na imagem mais recente
trivy image ghcr.io/alexandrepedrosaai/edge-ai-app:main

# Scan do Dockerfile do frontend (análise estática)
trivy config frontend/Dockerfile

# Scan do diretório local do projeto
trivy fs . --exit-code 1 --severity HIGH,CRITICAL
```

### Verificar Resultado do Workflow de Build

```bash
# Ver o run mais recente do workflow de Docker build
gh run list --workflow docker-build.yml --repo alexandrepedrosaai/Edge-AI-APP --limit 5

# Ver detalhes e logs do run
gh run view <run-id> --repo alexandrepedrosaai/Edge-AI-APP --log
```

### Verificar Digest da Imagem em Produção (AKS)

```bash
# Verificar qual imagem está rodando em cada pod
kubectl get pods -n default -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{range .spec.containers[*]}{.image}{"\n"}{end}{end}'

# Ver digest da imagem do deployment
kubectl get deployment edge-frontend -n default \
  -o jsonpath='{.spec.template.spec.containers[0].image}'
```

## Monitoramento Azure Container App

```bash
# Status do Container App
az containerapp show \
  --name edge-ai-app \
  --resource-group edge-ai-rg \
  --query "properties.provisioningState"

# Seguir logs do Container App
az containerapp logs show \
  --name edge-ai-app \
  --resource-group edge-ai-rg \
  --follow

# Métricas de CPU
az monitor metrics list \
  --resource-group edge-ai-rg \
  --resource-type "Microsoft.App/containerApps" \
  --resource-name edge-ai-app \
  --metric "CpuUsagePercentage"

# Métricas de memória
az monitor metrics list \
  --resource-group edge-ai-rg \
  --resource-type "Microsoft.App/containerApps" \
  --resource-name edge-ai-app \
  --metric "MemoryUsagePercentage"
```

## Verificação de Secrets

### Listar Secrets Configurados

```bash
# Via GitHub CLI (requer autenticação)
gh secret list --repo alexandrepedrosaai/Edge-AI-APP
```

### Secrets Necessários

| Secret | Descrição |
|--------|-----------|
| AZURE_CLIENT_ID | ID do Service Principal (OIDC) |
| AZURE_TENANT_ID | ID do Tenant Azure |
| AZURE_RESOURCE_GROUP | Nome do Resource Group |
| AZURE_CONTAINER_APP_NAME | Nome do Azure Container App |
| AZURE_FUNCTION_APP_NAME | Nome da Function App |
| AZURE_FUNCTION_PUBLISH_PROFILE | Publish Profile (base64) |

## Troubleshooting

### Workflow Falha com "Secrets not found"

**Problema**: Workflow não consegue acessar secrets

**Solução**:
1. Verificar se secrets estão em Settings → Secrets and variables → Actions
2. Confirmar que os nomes estão exatamente corretos (case-sensitive)
3. Fazer commit e push para disparar novo run

### Pod não inicia / CrashLoopBackOff no AKS

**Problema**: Pod fica em `CrashLoopBackOff` ou `Pending`

**Solução**:
```bash
# Verificar eventos do pod
kubectl describe pod <nome-do-pod> -n default

# Ver logs do container com falha
kubectl logs <nome-do-pod> -n default --previous

# Verificar se os probes estão configurados corretamente
kubectl get deployment edge-backend -n default -o yaml | grep -A 20 "livenessProbe\|readinessProbe"
```

### Container App não inicia

**Problema**: Container App fica em estado "Provisioning"

**Solução**:
```bash
# Ver logs do Container App
az containerapp logs show \
  --name edge-ai-app \
  --resource-group edge-ai-rg \
  --follow

# Verificar status detalhado
az containerapp show \
  --name edge-ai-app \
  --resource-group edge-ai-rg \
  --query "properties"
```

### Function App retorna erro 500

**Problema**: Function App não responde ou retorna 500

**Solução**:
```bash
# Ver logs em tempo real
az functionapp log tail \
  --name edge-ai-functions \
  --resource-group edge-ai-rg

# Verificar settings da função
az functionapp config appsettings list \
  --name edge-ai-functions \
  --resource-group edge-ai-rg
```

### OIDC Token Inválido

**Problema**: Erro "OIDC token not valid"

**Solução**:
1. Verificar Federated Identity Credential no Azure
2. Confirmar que `subject` corresponde ao repositório e branch
3. Verificar se o `issuer` está correto (`https://token.actions.githubusercontent.com`)

```bash
# Listar federated credentials configurados
az identity federated-credential list \
  --identity-name github-edge-ai-app \
  --resource-group edge-ai-rg
```

## Pipeline de Deployment

### Fluxo

```
1. Push para main
   ↓
2. GitHub Actions dispara workflows
   ↓
3. Build e testes executam (build-and-test.yml, test-multi-node.yml)
   ↓
4. Docker image construída e publicada no GHCR (docker-build.yml)
   ↓
5. SBOM gerado e scan de segurança executado (sbom-security.yaml)
   ↓
6. Deploy para Azure Container App (azure-container-app.yml)
   ↓
7. Deploy para Azure Function App (azure-function-app.yml)
   ↓
8. Health checks e rollout status verificados
   ↓
9. Rollback automático se qualquer etapa falhar
```

### Verificar Status de Cada Etapa

```bash
# Ver status geral do workflow run
gh run view <run-id> --repo alexandrepedrosaai/Edge-AI-APP

# Ver logs detalhados por etapa
gh run view <run-id> --log --repo alexandrepedrosaai/Edge-AI-APP
```

## Checklist de Deployment

- [ ] Secrets adicionados no GitHub
- [ ] Federated Identity Credential configurado no Azure
- [ ] AKS Cluster e namespaces configurados
- [ ] Manifests Kubernetes aplicados (`k8s/`)
- [ ] Container App criado no Azure (se aplicável)
- [ ] Function App criado (`edge-ai-functions`)
- [ ] Storage Account criado
- [ ] Workflows disparados com sucesso
- [ ] Imagens de container publicadas no GHCR
- [ ] Scan de segurança sem vulnerabilidades críticas
- [ ] Pods no AKS em estado `Running` com probes OK
- [ ] Ingress acessível (`edge-ai.example.com`)
- [ ] Function App respondendo corretamente
- [ ] Logs sem erros

## Recursos Adicionais

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Azure Container Apps Documentation](https://learn.microsoft.com/en-us/azure/container-apps/)
- [Azure Functions Documentation](https://learn.microsoft.com/en-us/azure/azure-functions/)
- [AKS Documentation](https://learn.microsoft.com/en-us/azure/aks/)
- [Trivy Security Scanner](https://trivy.dev/)
- [GitHub CLI Reference](https://cli.github.com/manual/)
- **GitHub Issues**: https://github.com/alexandrepedrosaai/Edge-AI-APP/issues

---

**Última atualização**: 2026-04-04
**Versão**: 2.0.0
