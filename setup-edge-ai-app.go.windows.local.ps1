#requires -Version 5.1
<#
.SYNOPSIS
  Setup local do Edge-AI-APP no Windows, sem login e sem instalação global.

.DESCRIPTION
  Este script:
  - roda DENTRO do próprio repositório
  - não usa winget
  - não exige login no Windows
  - não exige login no GitHub CLI / Azure CLI
  - baixa Go e Node localmente para .tools\
  - configura PATH só para a sessão / scripts locais
  - cria .env.local com nome do site e URL do repositório
  - instala dependências com pnpm
  - roda go mod tidy / go test / go build
  - gera build web
  - cria scripts auxiliares para iniciar o projeto

.COMO USAR
  1) Coloque este arquivo na raiz do repositório Edge-AI-APP
  2) Abra PowerShell
  3) Rode:
     Set-ExecutionPolicy -Scope Process Bypass
     .\setup-edge-ai-app.go.windows.local.ps1

.NOTES
  - Não altera PATH global do Windows
  - Não instala nada no Program Files
  - Tudo fica dentro do próprio repositório
#>

param(
    [string]$SiteName = "edge-ai-app.go.windows",
    [string]$RepoUrl = "https://github.com/alexandrepedrosaai/Edge-AI-APP",
    [string]$GoModule = "github.com/alexandrepedrosaai/edge-ai-app",
    [string]$GoVersion = "1.26.2",
    [string]$NodeVersion = "20.20.2",
    [switch]$SkipNodeInstall,
    [switch]$SkipGoInstall,
    [switch]$SkipWebBuild,
    [switch]$SkipGoBuild,
    [switch]$ForceRedownload
)

$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"

# =========================
# Helpers
# =========================

function Write-Step([string]$Message) {
    Write-Host ""
    Write-Host "==================================================" -ForegroundColor Cyan
    Write-Host " $Message" -ForegroundColor Cyan
    Write-Host "==================================================" -ForegroundColor Cyan
}

function Write-Ok([string]$Message) {
    Write-Host "[OK] $Message" -ForegroundColor Green
}

function Write-WarnMsg([string]$Message) {
    Write-Host "[AVISO] $Message" -ForegroundColor Yellow
}

function Write-Info([string]$Message) {
    Write-Host "[INFO] $Message" -ForegroundColor White
}

function Ensure-Dir([string]$Path) {
    if (-not (Test-Path $Path)) {
        New-Item -ItemType Directory -Path $Path | Out-Null
    }
}

function Download-File([string]$Url, [string]$OutFile) {
    Write-Info "Baixando: $Url"
    Invoke-WebRequest -Uri $Url -OutFile $OutFile -UseBasicParsing
}

function Remove-DirSafe([string]$Path) {
    if (Test-Path $Path) {
        Remove-Item -Path $Path -Recurse -Force
    }
}

function Add-PathSession([string]$PathItem) {
    if (-not [string]::IsNullOrWhiteSpace($PathItem)) {
        $parts = $env:Path -split ";"
        if ($parts -notcontains $PathItem) {
            $env:Path = "$PathItem;$env:Path"
        }
    }
}

function Run-Command([string]$Label, [scriptblock]$Script) {
    Write-Step $Label
    & $Script
    Write-Ok $Label
}

function Run-CommandSoft([string]$Label, [scriptblock]$Script) {
    Write-Step $Label
    try {
        & $Script
        Write-Ok $Label
    } catch {
        Write-WarnMsg "$Label falhou: $($_.Exception.Message)"
    }
}

function Find-RepoRoot([string]$StartPath) {
    $current = Resolve-Path $StartPath
    while ($true) {
        $goMod = Join-Path $current "go.mod"
        $pkgJson = Join-Path $current "package.json"

        if ((Test-Path $goMod) -and (Test-Path $pkgJson)) {
            return $current
        }

        $parent = Split-Path $current -Parent
        if ($parent -eq $current -or [string]::IsNullOrWhiteSpace($parent)) {
            throw "Não foi possível localizar a raiz do repositório. Coloque o script na raiz do Edge-AI-APP ou execute dentro dela."
        }

        $current = $parent
    }
}

# =========================
# Localizar repositório
# =========================

$RepoRoot = Find-RepoRoot $PSScriptRoot
Set-Location $RepoRoot

Write-Step "Setup local sem login para $SiteName"
Write-Info "Repo root : $RepoRoot"
Write-Info "Repo URL  : $RepoUrl"
Write-Info "Módulo Go : $GoModule"

# =========================
# Estrutura local
# =========================

$ToolsDir       = Join-Path $RepoRoot ".tools"
$CacheDir       = Join-Path $RepoRoot ".cache"
$ScriptsDir     = Join-Path $RepoRoot ".local-scripts"
$LocalBinDir    = Join-Path $RepoRoot ".local-bin"

Ensure-Dir $ToolsDir
Ensure-Dir $CacheDir
Ensure-Dir $ScriptsDir
Ensure-Dir $LocalBinDir

# =========================
# URLs dos downloads
# =========================

$GoZipUrl       = "https://go.dev/dl/go$GoVersion.windows-amd64.zip"
$GoZipFile      = Join-Path $CacheDir "go$GoVersion.windows-amd64.zip"
$GoExtractRoot  = Join-Path $ToolsDir "go"
$GoHome         = Join-Path $GoExtractRoot "go"
$GoBin          = Join-Path $GoHome "bin"

$NodeZipUrl     = "https://nodejs.org/dist/v$NodeVersion/node-v$NodeVersion-win-x64.zip"
$NodeZipFile    = Join-Path $CacheDir "node-v$NodeVersion-win-x64.zip"
$NodeExtractRoot= Join-Path $ToolsDir "node"
$NodeHome       = Join-Path $NodeExtractRoot "node-v$NodeVersion-win-x64"

$EnvFile        = Join-Path $RepoRoot ".env.local"
$EnvBackupFile  = Join-Path $RepoRoot ".env.local.bak"

# =========================
# Gitignore local
# =========================

$GitIgnorePath = Join-Path $RepoRoot ".gitignore"
if (Test-Path $GitIgnorePath) {
    $gitignore = Get-Content $GitIgnorePath -Raw
    $entries = @(
        ".tools/",
        ".cache/",
        ".local-bin/",
        ".local-scripts/",
        ".env.local.bak"
    )

    $toAppend = @()
    foreach ($entry in $entries) {
        if ($gitignore -notmatch [regex]::Escape($entry)) {
            $toAppend += $entry
        }
    }

    if ($toAppend.Count -gt 0) {
        Add-Content -Path $GitIgnorePath -Value "`r`n# Local Windows portable setup`r`n$($toAppend -join "`r`n")`r`n"
        Write-Ok ".gitignore atualizado com diretórios locais."
    }
}

# =========================
# Instalar Go local
# =========================

if (-not $SkipGoInstall) {
    Run-Command "Instalação local do Go" {
        if ($ForceRedownload -and (Test-Path $GoZipFile)) {
            Remove-Item $GoZipFile -Force
        }

        if (-not (Test-Path $GoZipFile)) {
            Download-File $GoZipUrl $GoZipFile
        } else {
            Write-Info "Arquivo Go já existe em cache: $GoZipFile"
        }

        if ($ForceRedownload -and (Test-Path $GoExtractRoot)) {
            Remove-DirSafe $GoExtractRoot
        }

        if (-not (Test-Path $GoHome)) {
            Ensure-Dir $GoExtractRoot
            Expand-Archive -Path $GoZipFile -DestinationPath $GoExtractRoot -Force
        }

        if (-not (Test-Path (Join-Path $GoBin "go.exe"))) {
            throw "go.exe não foi encontrado após a extração."
        }

        Add-PathSession $GoBin

        & (Join-Path $GoBin "go.exe") version
    }
} else {
    Write-WarnMsg "Instalação local do Go foi pulada."
}

# =========================
# Instalar Node local
# =========================

if (-not $SkipNodeInstall) {
    Run-Command "Instalação local do Node.js" {
        if ($ForceRedownload -and (Test-Path $NodeZipFile)) {
            Remove-Item $NodeZipFile -Force
        }

        if (-not (Test-Path $NodeZipFile)) {
            Download-File $NodeZipUrl $NodeZipFile
        } else {
            Write-Info "Arquivo Node já existe em cache: $NodeZipFile"
        }

        if ($ForceRedownload -and (Test-Path $NodeExtractRoot)) {
            Remove-DirSafe $NodeExtractRoot
        }

        if (-not (Test-Path $NodeHome)) {
            Ensure-Dir $NodeExtractRoot
            Expand-Archive -Path $NodeZipFile -DestinationPath $NodeExtractRoot -Force
        }

        if (-not (Test-Path (Join-Path $NodeHome "node.exe"))) {
            throw "node.exe não foi encontrado após a extração."
        }

        Add-PathSession $NodeHome

        & (Join-Path $NodeHome "node.exe") -v
        & (Join-Path $NodeHome "npm.cmd") -v
    }
} else {
    Write-WarnMsg "Instalação local do Node.js foi pulada."
}

# =========================
# Validar ferramentas
# =========================

Write-Step "Validação do ambiente local"

$GoExe   = Join-Path $GoBin "go.exe"
$NodeExe = Join-Path $NodeHome "node.exe"
$NpmCmd  = Join-Path $NodeHome "npm.cmd"

if (-not $SkipGoInstall -and -not (Test-Path $GoExe)) {
    throw "Go local não encontrado em $GoExe"
}

if (-not $SkipNodeInstall -and -not (Test-Path $NodeExe)) {
    throw "Node local não encontrado em $NodeExe"
}

if (-not $SkipGoInstall) {
    & $GoExe version
}

if (-not $SkipNodeInstall) {
    & $NodeExe -v
    & $NpmCmd -v
}

# =========================
# Configuração Go local
# =========================

if (-not $SkipGoInstall) {
    Run-Command "Configuração local do Go" {
        $LocalGoPath = Join-Path $RepoRoot ".gopath"
        $LocalGoBin  = Join-Path $LocalGoPath "bin"

        Ensure-Dir $LocalGoPath
        Ensure-Dir $LocalGoBin

        $env:GOPATH  = $LocalGoPath
        $env:GOBIN   = $LocalGoBin
        $env:GOPROXY = "https://proxy.golang.org,direct"

        Add-PathSession $LocalGoBin

        & $GoExe env GOPATH
        & $GoExe env GOBIN
    }
}

# =========================
# Corepack + pnpm
# =========================

if (-not $SkipNodeInstall) {
    Run-Command "Ativação local do pnpm" {
        $CorepackCmd = Join-Path $NodeHome "corepack.cmd"

        if (-not (Test-Path $CorepackCmd)) {
            throw "corepack.cmd não encontrado em $CorepackCmd"
        }

        & $CorepackCmd enable
        & $CorepackCmd prepare "pnpm@10.28.2" --activate

        $PnpmHome = Join-Path $env:LOCALAPPDATA "pnpm"
        if (Test-Path $PnpmHome) {
            Add-PathSession $PnpmHome
        }

        $pnpmCmd = (Get-Command pnpm.cmd -ErrorAction SilentlyContinue).Source
        if (-not $pnpmCmd) {
            $pnpmCmd = (Get-Command pnpm -ErrorAction SilentlyContinue).Source
        }

        if (-not $pnpmCmd) {
            throw "pnpm não foi encontrado após ativação do corepack."
        }

        & $pnpmCmd -v
    }
}

# =========================
# Criar .env.local
# =========================

Run-Command "Criação do .env.local" {
    if (Test-Path $EnvFile) {
        Copy-Item $EnvFile $EnvBackupFile -Force
        Write-Info "Backup criado: $EnvBackupFile"
    }

@"
# Local repo-only setup for Windows (no login)
VITE_ANALYTICS_ENDPOINT=
VITE_ANALYTICS_WEBSITE_ID=

# Site identity
VITE_APP_TITLE=$SiteName
VITE_APP_LOGO=/logo.svg
VITE_APP_REPO_URL=$RepoUrl
VITE_APP_GO_MODULE=$GoModule

# Local API
VITE_FRONTEND_FORGE_API_URL=http://localhost:3001
VITE_FRONTEND_FORGE_API_KEY=

# Additional local metadata
EDGE_AI_APP_SITE_NAME=$SiteName
EDGE_AI_APP_REPO_URL=$RepoUrl
EDGE_AI_APP_GO_MODULE=$GoModule
"@ | Set-Content -Path $EnvFile -Encoding UTF8

    Write-Ok ".env.local criado."
}

# =========================
# Instalar dependências Node
# =========================

if (-not $SkipNodeInstall) {
    Run-Command "Instalação de dependências Node" {
        $pnpmCmd = (Get-Command pnpm.cmd -ErrorAction SilentlyContinue).Source
        if (-not $pnpmCmd) {
            $pnpmCmd = (Get-Command pnpm -ErrorAction SilentlyContinue).Source
        }

        if (-not $pnpmCmd) {
            throw "pnpm não encontrado."
        }

        try {
            & $pnpmCmd install --frozen-lockfile
        } catch {
            Write-WarnMsg "pnpm install --frozen-lockfile falhou, tentando pnpm install normal..."
            & $pnpmCmd install
        }
    }
}

# =========================
# Dependências Go
# =========================

if (-not $SkipGoInstall) {
    Run-Command "go mod tidy" {
        & $GoExe mod tidy
    }
}

# =========================
# Testes Go
# =========================

if (-not $SkipGoInstall) {
    Run-CommandSoft "Testes Go" {
        & $GoExe test ./cmd/... ./internal/... -v
    }
}

# =========================
# Build Go
# =========================

if (-not $SkipGoInstall -and -not $SkipGoBuild) {
    Run-CommandSoft "Build Go" {
        & $GoExe build -o edge-ai-app-go.exe ./cmd/app
    }
}

# =========================
# Build Web
# =========================

if (-not $SkipNodeInstall -and -not $SkipWebBuild) {
    Run-CommandSoft "Build web" {
        $env:VITE_ANALYTICS_ENDPOINT   = "https://analytics.example.com"
        $env:VITE_ANALYTICS_WEBSITE_ID = "default"
        $env:VITE_APP_TITLE            = $SiteName
        $env:VITE_APP_LOGO             = "/logo.svg"
        $env:VITE_APP_REPO_URL         = $RepoUrl
        $env:VITE_APP_GO_MODULE        = $GoModule

        $pnpmCmd = (Get-Command pnpm.cmd -ErrorAction SilentlyContinue).Source
        if (-not $pnpmCmd) {
            $pnpmCmd = (Get-Command pnpm -ErrorAction SilentlyContinue).Source
        }

        & $pnpmCmd run build
    }
}

# =========================
# Scripts auxiliares locais
# =========================

Run-Command "Criação de scripts auxiliares" {
    $UseLocalEnvScript = @"
`$repo = Split-Path -Parent `$MyInvocation.MyCommand.Path
`$repo = Split-Path -Parent `$repo

`$goBin = Join-Path `$repo ".tools\go\go\bin"
`$nodeHome = Get-ChildItem (Join-Path `$repo ".tools\node") -Directory | Select-Object -First 1

if (Test-Path `$goBin) {
    if ((`$env:Path -split ';') -notcontains `$goBin) {
        `$env:Path = "`$goBin;`$env:Path"
    }
}

if (`$nodeHome -and (Test-Path `$nodeHome.FullName)) {
    if ((`$env:Path -split ';') -notcontains `$nodeHome.FullName) {
        `$env:Path = "`$(`$nodeHome.FullName);`$env:Path"
    }
}

`$env:GOPATH  = Join-Path `$repo ".gopath"
`$env:GOBIN   = Join-Path `$env:GOPATH "bin"
`$env:GOPROXY = "https://proxy.golang.org,direct"
"@

    $UseLocalEnvPath = Join-Path $ScriptsDir "use-local-env.ps1"
    $UseLocalEnvScript | Set-Content -Path $UseLocalEnvPath -Encoding UTF8

    @"
. "`$PSScriptRoot\use-local-env.ps1"
Set-Location (Split-Path -Parent `$PSScriptRoot)
pnpm dev
"@ | Set-Content -Path (Join-Path $ScriptsDir "start-dev.ps1") -Encoding UTF8

    @"
. "`$PSScriptRoot\use-local-env.ps1"
Set-Location (Split-Path -Parent `$PSScriptRoot)
`$env:NODE_ENV = "production"
node .\dist\index.js
"@ | Set-Content -Path (Join-Path $ScriptsDir "start-prod.ps1") -Encoding UTF8

    @"
. "`$PSScriptRoot\use-local-env.ps1"
Set-Location (Split-Path -Parent `$PSScriptRoot)
if (Test-Path ".\edge-ai-app-go.exe") {
    .\edge-ai-app-go.exe
} else {
    go build -o edge-ai-app-go.exe ./cmd/app
    .\edge-ai-app-go.exe
}
"@ | Set-Content -Path (Join-Path $ScriptsDir "run-go.ps1") -Encoding UTF8

    @"
. "`$PSScriptRoot\use-local-env.ps1"
Set-Location (Split-Path -Parent `$PSScriptRoot)
go version
node -v
npm -v
pnpm -v
"@ | Set-Content -Path (Join-Path $ScriptsDir "doctor.ps1") -Encoding UTF8
}

# =========================
# Resumo
# =========================

Write-Step "Resumo final"

Write-Host "Site local        : $SiteName" -ForegroundColor Green
Write-Host "Repo URL          : $RepoUrl" -ForegroundColor Green
Write-Host "Módulo Go         : $GoModule" -ForegroundColor Green
Write-Host "Raiz do projeto   : $RepoRoot" -ForegroundColor Green
Write-Host "Go local          : $GoHome" -ForegroundColor Green
Write-Host "Node local        : $NodeHome" -ForegroundColor Green
Write-Host ""

Write-Host "Arquivos criados:" -ForegroundColor Cyan
Write-Host "  .env.local" -ForegroundColor White
Write-Host "  .local-scripts\use-local-env.ps1" -ForegroundColor White
Write-Host "  .local-scripts\start-dev.ps1" -ForegroundColor White
Write-Host "  .local-scripts\start-prod.ps1" -ForegroundColor White
Write-Host "  .local-scripts\run-go.ps1" -ForegroundColor White
Write-Host "  .local-scripts\doctor.ps1" -ForegroundColor White
Write-Host ""

Write-Host "Comandos úteis:" -ForegroundColor Cyan
Write-Host "  .\.local-scripts\doctor.ps1" -ForegroundColor White
Write-Host "  .\.local-scripts\start-dev.ps1" -ForegroundColor White
Write-Host "  .\.local-scripts\start-prod.ps1" -ForegroundColor White
Write-Host "  .\.local-scripts\run-go.ps1" -ForegroundColor White
Write-Host ""

Write-Host "Observação:" -ForegroundColor Cyan
Write-Host "  Este setup é local ao repositório e não depende de login no Windows." -ForegroundColor White
Write-Host "  Ele também não usa winget, nem instala Go/Node globalmente." -ForegroundColor White
Write-Host ""
Write-Ok "Setup finalizado."
