# Edge AI App - Documentação Completa do Projeto

## 📋 Índice

1. [Visão Geral](#visão-geral)
2. [Arquitetura](#arquitetura)
3. [Stack Tecnológico](#stack-tecnológico)
4. [Estrutura do Projeto](#estrutura-do-projeto)
5. [Setup Local](#setup-local)
6. [Build e Deploy](#build-e-deploy)
7. [CI/CD Pipeline](#cicd-pipeline)
8. [Troubleshooting](#troubleshooting)

## 🎯 Visão Geral

**Edge AI App** é uma aplicação de inteligência artificial para processamento de dados em edge computing, com suporte para:

- ✅ Frontend React 19 com TypeScript
- ✅ Backend Node.js com Express
- ✅ Azure Functions para serverless
- ✅ Código Assembly otimizado (x86_64)
- ✅ Docker containerização
- ✅ CI/CD com GitHub Actions
- ✅ Deploy em Azure Container Apps e Function Apps

## 🏗️ Arquitetura

```
┌─────────────────────────────────────────────────────────┐
│                   GitHub Repository                      │
│  ┌──────────────────────────────────────────────────┐   │
│  │ Edge-AI-APP                                      │   │
│  │ ├── client/          (React Frontend)            │   │
│  │ ├── server/          (Node.js Backend)           │   │
│  │ ├── azure-functions/ (Azure Functions)           │   │
│  │ ├── .ASM_HEX/        (Assembly Code)             │   │
│  │ ├── Dockerfile       (Container Image)           │   │
│  │ └── .github/         (CI/CD Workflows)           │   │
│  └──────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────┘
                          │
                          ▼
        ┌─────────────────────────────────┐
        │    GitHub Actions Workflows     │
        │  ├─ Build & Test               │
        │  ├─ Docker Build & Push        │
        │  ├─ Assembly Build             │
        │  ├─ SBOM Generation            │
        │  ├─ Azure Container Deploy     │
        │  └─ Azure Function Deploy      │
        └─────────────────────────────────┘
                          │
                ┌─────────┴─────────┐
                ▼                   ▼
        ┌─────────────────┐  ┌──────────────────┐
        │ Azure Container │  │ Azure Function   │
        │ App (Frontend)  │  │ App (Backend)    │
        └─────────────────┘  └──────────────────┘
```

## 🛠️ Stack Tecnológico

### Frontend
- **Framework**: React 19.2.4
- **Language**: TypeScript 5.6.3
- **Build Tool**: Vite 7.3.1
- **Styling**: Tailwind CSS 4.2.1
- **UI Components**: shadcn/ui
- **Router**: Wouter

### Backend
- **Runtime**: Node.js 20.x / 22.x
- **Framework**: Express.js
- **Package Manager**: pnpm 10.28.2
- **Deployment**: Azure Functions

### Assembly
- **Assembler**: NASM 2.15.05, YASM 1.3.0
- **Compiler**: GCC 11.4.0
- **Debugger**: GDB 12.1
- **Tools**: Checksec, Valgrind, Objdump

### DevOps
- **Containerization**: Docker
- **CI/CD**: GitHub Actions
- **Cloud**: Microsoft Azure
- **Registry**: GitHub Container Registry (GHCR)

## 📁 Estrutura do Projeto

```
Edge-AI-APP/
├── client/                          # Frontend React
│   ├── public/                      # Static assets
│   │   ├── index.html
│   │   └── favicon.ico
│   ├── src/
│   │   ├── pages/                  # Page components
│   │   ├── components/             # Reusable components
│   │   ├── contexts/               # React contexts
│   │   ├── hooks/                  # Custom hooks
│   │   ├── lib/                    # Utilities
│   │   ├── App.tsx                 # Main app component
│   │   ├── main.tsx                # Entry point
│   │   └── index.css               # Global styles
│   ├── package.json
│   └── tsconfig.json
│
├── server/                          # Backend Node.js
│   ├── src/
│   │   ├── routes/                 # API routes
│   │   ├── middleware/             # Express middleware
│   │   ├── controllers/            # Request handlers
│   │   ├── services/               # Business logic
│   │   ├── utils/                  # Utilities
│   │   └── index.ts                # Server entry point
│   ├── package.json
│   └── tsconfig.json
│
├── azure-functions/                 # Azure Functions
│   ├── HttpTrigger/
│   ├── TimerTrigger/
│   ├── function.json
│   └── host.json
│
├── .ASM_HEX/                        # Assembly code (hex format)
│   ├── *.hex                        # Converted ASM files
│   └── build/                       # Build artifacts
│
├── .github/
│   └── workflows/                   # GitHub Actions
│       ├── build-and-test.yml
│       ├── test-multi-node.yml
│       ├── docker-build.yml
│       ├── docker-image.yml
│       ├── assembly-build.yml
│       ├── install-dependencies.yml
│       ├── sbom-security.yaml
│       ├── azure-container-app.yml
│       └── azure-function-app.yml
│
├── Dockerfile                       # Docker image definition
├── docker-compose.yml               # Local development
├── package.json                     # Root dependencies
├── pnpm-lock.yaml                   # Dependency lock file
├── tsconfig.json                    # TypeScript config
├── vite.config.ts                   # Vite config
├── tailwind.config.ts               # Tailwind config
│
├── build-assembly.sh                # Assembly build script
├── Makefile.asm                     # Assembly makefile
├── ASSEMBLY_PIPELINE.md             # Assembly documentation
├── AZURE_DEPLOYMENT_GUIDE.md        # Azure setup guide
├── GITHUB_ACTIONS_SETUP.md          # GitHub Actions guide
└── README.md                        # Project readme
```

## 🚀 Setup Local

### Pré-requisitos

```bash
# Node.js 20.x ou 22.x
node --version

# pnpm 10.x
npm install -g pnpm
pnpm --version

# Python 3.11 (para scripts)
python3 --version

# Docker (opcional)
docker --version
```

### Instalação

```bash
# 1. Clone o repositório
git clone https://github.com/alexandrepedrosaai/Edge-AI-APP.git
cd Edge-AI-APP

# 2. Instale dependências
pnpm install

# 3. Configure variáveis de ambiente
cp .env.local .env.local

# 4. Inicie o servidor de desenvolvimento
pnpm run dev
```

### Variáveis de Ambiente

Crie um arquivo `.env.local`:

```env
# Analytics
VITE_ANALYTICS_ENDPOINT=https://analytics.example.com
VITE_ANALYTICS_WEBSITE_ID=default

# App
VITE_APP_TITLE=Edge AI App
VITE_APP_LOGO=/logo.svg

# Backend
BACKEND_URL=http://localhost:3001
API_KEY=your_api_key

# Azure
AZURE_SUBSCRIPTION_ID=f7fc86dd-bd9f-43a6-80a4-0bb6cab950ec
AZURE_RESOURCE_GROUP=edge-ai-rg
```

## 🏗️ Build e Deploy

### Build Local

```bash
# Frontend build
pnpm run build

# Verificar output
ls -lh dist/

# Server build
cd server && pnpm run build

# Assembly build
./build-assembly.sh x86_64 linux
```

### Docker Build

```bash
# Build image
docker build -t edge-ai-app:latest .

# Verificar
docker image inspect edge-ai-app:latest

# Testar
docker run -p 3000:3000 edge-ai-app:latest
```

### Deploy em Azure

```bash
# Container App
az containerapp create \
  --name edge-ai-app \
  --resource-group edge-ai-rg \
  --image ghcr.io/alexandrepedrosaai/Edge-AI-APP:latest

# Function App
az functionapp create \
  --name edge-ai-functions \
  --resource-group edge-ai-rg \
  --runtime node \
  --runtime-version 20
```

## 🔄 CI/CD Pipeline

### Workflow Triggers

| Evento | Workflows |
|--------|-----------|
| Push em main | Build & Test, Docker Build, SBOM, Azure Deploy |
| Push em develop | Build & Test, Test Multi-Node |
| Pull Request | Build & Test, Test Multi-Node |
| Manual | Qualquer workflow |

### Stages do Pipeline

```
1. Checkout
   ↓
2. Setup (Node.js, Python, Docker)
   ↓
3. Install Dependencies
   ↓
4. Build & Test
   ├─ Vite build
   ├─ TypeScript check
   ├─ Format check
   └─ Unit tests
   ↓
5. Security Scans
   ├─ SBOM generation
   ├─ Trivy image scan
   └─ Dependency check
   ↓
6. Docker Build & Push
   ├─ Build image
   ├─ Push to GHCR
   └─ Security scan
   ↓
7. Deploy (Conditional)
   ├─ Azure Container App
   └─ Azure Function App
   ↓
8. Verify & Monitor
   ├─ Health checks
   ├─ Smoke tests
   └─ Metrics
```

## 🧪 Testes

### Unit Tests

```bash
# Executar testes
pnpm run test

# Com coverage
pnpm run test:coverage

# Watch mode
pnpm run test:watch
```

### Integration Tests

```bash
# Testar API
pnpm run test:api

# Testar E2E
pnpm run test:e2e
```

### Build Tests

```bash
# Verificar build
pnpm run build

# Verificar tipos TypeScript
pnpm run check

# Verificar formatação
pnpm run format --check
```

## 📊 Monitoramento

### Logs

```bash
# Frontend logs
tail -f .manus-logs/browserConsole.log

# Backend logs
tail -f .manus-logs/devserver.log

# Network logs
tail -f .manus-logs/networkRequests.log
```

### Métricas Azure

```bash
# Container App
az monitor metrics list \
  --resource-group edge-ai-rg \
  --resource-type "Microsoft.App/containerApps" \
  --resource-names edge-ai-app

# Function App
az monitor metrics list \
  --resource-group edge-ai-rg \
  --resource-type "Microsoft.Web/sites" \
  --resource-names edge-ai-functions
```

## 🔍 Troubleshooting

### Build falha com "VITE_ANALYTICS_ENDPOINT is not defined"

**Solução**: Adicionar variáveis ao `.env.local`:
```bash
VITE_ANALYTICS_ENDPOINT=https://analytics.example.com
VITE_ANALYTICS_WEBSITE_ID=default
```

### Docker build falha

**Solução**: Verificar Dockerfile e dependências:
```bash
docker build --progress=plain -t edge-ai-app:test .
```

### GitHub Actions workflow não dispara

**Solução**: Verificar triggers e sintaxe YAML:
```bash
yamllint .github/workflows/
```

### Azure deploy falha com "OIDC token not valid"

**Solução**: Verificar Federated Identity Credential:
```bash
az identity federated-credential list \
  --identity-name github-edge-ai-app \
  --resource-group edge-ai-rg
```

## 📚 Recursos Adicionais

- [React Documentation](https://react.dev)
- [Vite Documentation](https://vitejs.dev)
- [Azure Documentation](https://learn.microsoft.com/en-us/azure/)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Docker Documentation](https://docs.docker.com)

## 📞 Suporte

Para problemas ou dúvidas:
1. Verificar logs em `.manus-logs/`
2. Consultar documentação oficial
3. Abrir issue no repositório
4. Contatar maintainers

---

**Última atualização**: 2026-03-18
**Versão**: 1.0.0
**Mantido por**: @alexandrepedrosaai
