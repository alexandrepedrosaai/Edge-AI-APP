# Build stage
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /app
COPY ./src ./src
RUN dotnet publish src/wave-space-dl.qsproj -c Release -r linux-x64 --self-contained true -o /app/out

# Runtime stage
FROM mcr.microsoft.com/dotnet/runtime:7.0
WORKDIR /app
COPY --from=build /app/out .
ENTRYPOINT ["./wave-space-dl", "--output", "dist/wave-space.json", "--embedding-dim", "12"]
