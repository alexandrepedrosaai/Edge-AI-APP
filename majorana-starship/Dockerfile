# Etapa 1: Build
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build

WORKDIR /src

# Copia os arquivos de projeto
COPY majorana-starship.qsproj ./
COPY majorana_starship_ci.qs ./
RUN dotnet restore ./majorana-starship.qsproj

# Compila em modo Release
RUN dotnet publish ./majorana-starship.qsproj -c Release -o /app/publish --no-restore

# Etapa 2: Runtime
FROM mcr.microsoft.com/dotnet/runtime:6.0 AS runtime

WORKDIR /app

COPY --from=build /app/publish .

# Comando de entrada
ENTRYPOINT ["dotnet", "majorana-starship.dll"]
