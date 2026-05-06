# Etapa 1: Build
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

WORKDIR /src

# Copia os arquivos de projeto
COPY ./majorana-starship/*.qs ./majorana-starship/
RUN dotnet restore ./majorana-starship/*.qs

# Copia o restante do código
COPY ./majorana-starship ./majorana-starship

# Compila em modo Release
RUN dotnet publish ./majorana-starship -c Release -o /app/publish

# Etapa 2: Runtime
FROM mcr.microsoft.com/dotnet/runtime:8.0 AS runtime

WORKDIR /app

COPY --from=build /app/publish .

# Comando de entrada
ENTRYPOINT ["dotnet", "majorana-starship.dll"]
