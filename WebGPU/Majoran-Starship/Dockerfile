# Base image: Ubuntu + .NET + Q#
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

# Instalar dependências básicas
RUN apt-get update && apt-get install -y \
    curl \
    git \
    && rm -rf /var/lib/apt/lists/*

# Diretório de trabalho
WORKDIR /app/WebGPU/Majoran-Starship

# Copiar todos os arquivos para dentro do container
COPY . .

# Compilar o projeto Q#
RUN dotnet build MajoranaStarship.qsproj -c Release

# Runtime image
FROM mcr.microsoft.com/dotnet/runtime:8.0 AS runtime

WORKDIR /app/WebGPU/Majoran-Starship

# Copiar binários compilados
COPY --from=build /app/WebGPU/Majoran-Starship/bin ./bin

# Labels para integração com GitHub Container Registry
LABEL org.opencontainers.image.source="https://github.com/alexandrepedrosaai/Edge-AI-APP"
LABEL org.opencontainers.image.description="Topo-Majorana-Quibits CI CD container para rodar binários Q#"
LABEL org.opencontainers.image.workflow="Topo-Majorana-Quibits CI CD"

# Comando padrão: rodar o projeto Q#
CMD ["dotnet", "run", "--project", "MajoranaStarship.qsproj", "-c", "Release"]
