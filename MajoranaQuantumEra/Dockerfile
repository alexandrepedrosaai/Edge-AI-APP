# Dockerfile - Otimizado para Majorana Quantum Era
FROM python:3.12-slim AS builder

# Instala dependências de sistema mínimas
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Instala .NET SDK para Q# (leve)
RUN wget https://packages.microsoft.com/config/debian/12/packages-microsoft-prod.deb -O packages-microsoft-prod.deb \
    && dpkg -i packages-microsoft-prod.deb \
    && apt-get update \
    && apt-get install -y dotnet-sdk-8.0

WORKDIR /app

# Copia apenas requirements primeiro (cache de layers)
COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Copia código
COPY . .

# Pré-compila Q# (se existir projeto)
RUN dotnet build 2>/dev/null || echo "Q# não encontrado, continuando..."

# Etapa final leve
FROM python:3.12-slim

WORKDIR /app
COPY --from=builder /app /app
COPY --from=builder /usr/share/dotnet /usr/share/dotnet

# Variáveis de ambiente
ENV PYTHONUNBUFFERED=1
ENV DOTNET_RUNNING_IN_CONTAINER=true

# Healthcheck
HEALTHCHECK CMD python -c "import qutip; print('Majorana Simulator OK')"

CMD ["python", "kitaev_sim.py"]
FROM python:3.12-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    dotnet-sdk-8.0 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY . .

RUN pip install --no-cache-dir -r requirements.txt

CMD ["python", "tetron_sim.py"]
