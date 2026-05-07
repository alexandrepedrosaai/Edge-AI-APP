# Build stage
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /app
# Microsoft.Quantum.Sdk 0.28 ships net6 build utilities; allow running them on SDK 8 images.
ENV DOTNET_ROLL_FORWARD=Major
COPY . .
RUN dotnet restore src/wave-space-dl.qsproj -r linux-x64
RUN dotnet build src/wave-space-dl.qsproj -c Release -r linux-x64 --no-restore
RUN dotnet publish src/wave-space-dl.qsproj -c Release -r linux-x64 --self-contained true --no-restore -o /app/out

# Runtime stage
FROM mcr.microsoft.com/dotnet/runtime-deps:8.0
# Publish is self-contained, so runtime-deps keeps the final image smaller than full dotnet/runtime.
WORKDIR /app
COPY --from=build /app/out .
ENTRYPOINT ["./wave-space-dl", "--output", "dist/wave-space.json", "--embedding-dim", "12"]
