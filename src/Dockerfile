# Build stage
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /app
ENV DOTNET_ROLL_FORWARD=Major
COPY . .
RUN dotnet restore src/wave-space-dl.qsproj
RUN dotnet build src/wave-space-dl.qsproj -c Release --no-restore
RUN dotnet publish src/wave-space-dl.qsproj -c Release -r linux-x64 --self-contained true -o /app/out

# Runtime stage
FROM mcr.microsoft.com/dotnet/runtime-deps:8.0
WORKDIR /app
COPY --from=build /app/out .
ENTRYPOINT ["./wave-space-dl", "--output", "dist/wave-space.json", "--embedding-dim", "12"]
