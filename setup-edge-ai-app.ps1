# setup-edge-ai-app.ps1
# Executar no PowerShell como Administrador:
# Set-ExecutionPolicy -Scope Process Bypass
# .\setup-edge-ai-app.ps1

$ErrorActionPreference = "Stop"

function Write-Step($msg) {
    Write-Host ""
    Write-Host "==== $msg ====" -ForegroundColor Cyan
}

function Ensure-WingetPackage($id, $name) {
    Write-Step "Verificando $name"
    $installed = winget list --id $id 2>$null
    if ($LASTEXITCODE -ne 0 -or -not $installed) {
        Write-Host "$name não encontrado. Instalando..." -ForegroundColor Yellow
        winget install --id $id -e --source winget --accept-source-agreements --accept-package-agreements
    } else {
        Write-Host "$name já está instalado." -ForegroundColor Green
    }
}

Write-Step "Instalando dependências base"
Ensure-WingetPackage "Git.Git" "Git"
Ensure-WingetPackage "GoLang.Go" "Go"
Ensure-WingetPackage "OpenJS.NodeJS.LTS" "Node.js LTS"

Write-Step "Atualizando PATH da sessão atual"
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

Write-Step "Validando instalações"
git --version
go version
node -v
npm -v

Write-Step "Configurando Go"
go env -w GOPATH="$HOME\go"
go env -w GOBIN="$HOME\go\bin"

Write-Step "Ativando pnpm com Corepack"
corepack enable
corepack prepare pnpm@10.28.2 --activate
pnpm -v

$repoPath = Join-Path $HOME "Edge-AI-APP"

Write-Step "Clonando ou atualizando repositório"
if (Test-Path $repoPath) {
    Write-Host "Repositório já existe em $repoPath. Atualizando..." -ForegroundColor Yellow
    Set-Location $repoPath
    git pull
} else {
    Set-Location $HOME
    git clone https://github.com/alexandrepedrosaai/Edge-AI-APP.git
    Set-Location $repoPath
}

Write-Step "Criando .env.local"
@"
VITE_ANALYTICS_ENDPOINT=
VITE_ANALYTICS_WEBSITE_ID=
VITE_APP_TITLE=Edge AI App
VITE_APP_LOGO=/logo.svg
VITE_FRONTEND_FORGE_API_URL=http://localhost:3001
VITE_FRONTEND_FORGE_API_KEY=
"@ | Set-Content -Path .env.local -Encoding UTF8

Write-Step "Instalando dependências Node"
pnpm install

Write-Step "Organizando dependências Go"
go mod tidy

Write-Step "Testando módulo Go"
go test ./cmd/... ./internal/... -v

Write-Step "Compilando app Go"
go build -o edge-ai-app-go.exe .\cmd\app

Write-Step "Gerando build web"
pnpm build

Write-Step "Resumo final"
Write-Host ""
Write-Host "Instalação concluída." -ForegroundColor Green
Write-Host ""
Write-Host "Comandos úteis:"
Write-Host "  cd $repoPath"
Write-Host "  pnpm dev"
Write-Host "  .\edge-ai-app-go.exe"
Write-Host '  $env:NODE_ENV="production"; node .\dist\index.js'

