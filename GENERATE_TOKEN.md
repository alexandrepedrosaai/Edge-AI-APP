# 🔐 Generate GitHub Personal Access Token

Guia passo-a-passo para gerar um token de acesso pessoal do GitHub.

## 📋 Pré-requisitos

- ✅ Conta GitHub ativa
- ✅ Navegador web
- ✅ Acesso a https://github.com/settings/tokens

## 🚀 Passo 1: Acessar Página de Tokens

Clique no link abaixo ou copie a URL:

**Link direto**: https://github.com/settings/tokens

Ou manualmente:
1. Vá para https://github.com
2. Clique em seu avatar (canto superior direito)
3. Selecione **Settings**
4. No menu esquerdo, clique em **Developer settings**
5. Clique em **Personal access tokens**
6. Clique em **Tokens (classic)**

## 🔑 Passo 2: Gerar Novo Token

1. Clique em **"Generate new token"**
2. Selecione **"Generate new token (classic)"**

## 📝 Passo 3: Configurar Token

### Nome do Token
```
Edge-AI-App-Workflows
```

### Expiração
```
30 days (ou conforme preferir)
```

### Scopes (Permissões)

Selecione os seguintes scopes:

**✅ NECESSÁRIOS:**
- [ ] `repo` - Acesso completo ao repositório
- [ ] `workflow` - Acesso aos workflows

**OPCIONAIS:**
- [ ] `admin:repo_hook` - Acesso a webhooks
- [ ] `read:org` - Ler informações da organização

## 🎯 Passo 4: Gerar Token

1. Clique em **"Generate token"** (botão verde no final da página)
2. **IMPORTANTE**: Copie o token imediatamente (você só verá uma vez!)

## 💾 Passo 5: Usar o Token

### Opção 1: Variável de Ambiente (Recomendado)

```bash
export GITHUB_TOKEN='seu_token_aqui'
bash trigger-workflows-api.sh
```

### Opção 2: Arquivo .env

Crie um arquivo `.env` na raiz do projeto:

```bash
GITHUB_TOKEN=seu_token_aqui
```

Depois execute:

```bash
source .env
bash trigger-workflows-api.sh
```

### Opção 3: Comando Direto

```bash
GITHUB_TOKEN='seu_token_aqui' bash trigger-workflows-api.sh
```

## ⚠️ Segurança

### ✅ Boas Práticas

- ✅ **Nunca** compartilhe seu token
- ✅ **Nunca** commite o token em git
- ✅ Use variáveis de ambiente
- ✅ Defina expiração do token
- ✅ Revogue tokens não utilizados
- ✅ Use scopes mínimos necessários

### 🔒 Se o Token Vazar

1. Vá para https://github.com/settings/tokens
2. Clique em **"Delete"** para o token comprometido
3. Gere um novo token
4. Atualize suas variáveis de ambiente

## 📊 Exemplo Completo

```bash
# 1. Gerar token em https://github.com/settings/tokens
# Copiar o token

# 2. Definir variável de ambiente
export GITHUB_TOKEN='ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'

# 3. Clonar repositório
git clone https://github.com/alexandrepedrosaai/Edge-AI-APP.git
cd Edge-AI-APP

# 4. Disparar workflows
bash trigger-workflows-api.sh

# 5. Monitorar
# Acesse: https://github.com/alexandrepedrosaai/Edge-AI-APP/actions
```

## 🔍 Verificar Token

Para verificar se o token está funcionando:

```bash
curl -H "Authorization: token $GITHUB_TOKEN" https://api.github.com/user
```

Você deve ver informações da sua conta.

## 📋 Checklist

- [ ] Acessar https://github.com/settings/tokens
- [ ] Clicar em "Generate new token (classic)"
- [ ] Definir nome: "Edge-AI-App-Workflows"
- [ ] Selecionar scopes: `repo` e `workflow`
- [ ] Clicar em "Generate token"
- [ ] Copiar o token
- [ ] Definir variável de ambiente: `export GITHUB_TOKEN='...'`
- [ ] Executar script: `bash trigger-workflows-api.sh`

## 🆘 Troubleshooting

### Erro: "Invalid token"

```bash
# Verificar token
echo $GITHUB_TOKEN

# Se vazio, definir novamente
export GITHUB_TOKEN='seu_token_aqui'
```

### Erro: "Insufficient permissions"

Verifique se o token tem os scopes:
- ✅ `repo`
- ✅ `workflow`

### Erro: "Token expired"

Gere um novo token em https://github.com/settings/tokens

## 📚 Recursos

- [GitHub Token Documentation](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens)
- [GitHub API Documentation](https://docs.github.com/en/rest)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)

## 🎯 Próximos Passos

1. ✅ Gerar token
2. ✅ Definir variável de ambiente
3. ✅ Executar `trigger-workflows-api.sh`
4. ✅ Monitorar workflows
5. ✅ Verificar deployments

---

**Última atualização**: 2026-03-18  
**Status**: ✅ Pronto para gerar token
