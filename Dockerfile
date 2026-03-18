# ============================================================================
# Edge-AI-APP Multi-Stage Docker Build
# Supports Assembly, Node.js, Python, and Azure Functions
# ============================================================================

# Stage 1: Assembly Build Environment
FROM ubuntu:22.04 AS assembly-builder

WORKDIR /app

# Install Assembly development tools
RUN apt-get update && apt-get install -y \
    nasm \
    yasm \
    binutils \
    gcc \
    g++ \
    gdb \
    lldb \
    build-essential \
    clang \
    lld \
    strace \
    ltrace \
    valgrind \
    checksec \
    python3 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Copy project files
COPY . .

# Build Assembly files
RUN chmod +x build-assembly.sh && \
    ./build-assembly.sh x86_64 linux || true

# Stage 2: Node.js Build Environment
FROM node:22-alpine AS node-builder

WORKDIR /app

# Install dependencies
RUN npm install -g pnpm

# Copy package files
COPY package.json pnpm-lock.yaml* ./

# Install dependencies
RUN pnpm install --frozen-lockfile || pnpm install

# Copy source code
COPY client ./client
COPY server ./server
COPY shared ./shared

# Build the project
RUN pnpm run build || true

# Stage 3: Python Azure Functions Runtime
FROM mcr.microsoft.com/azure-functions/python:4-python3.11 AS python-runtime

ENV AzureWebJobsScriptRoot=/home/site/wwwroot \
    AzureFunctionsVersion=4

WORKDIR /home/site/wwwroot

# Copy Azure Functions
COPY azure-functions/ .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Stage 4: Final Runtime Image
FROM ubuntu:22.04

WORKDIR /app

# Install runtime dependencies
RUN apt-get update && apt-get install -y \
    nodejs \
    npm \
    python3 \
    python3-pip \
    curl \
    wget \
    git \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Install pnpm
RUN npm install -g pnpm

# Copy built Assembly artifacts
COPY --from=assembly-builder /app/build /app/build

# Copy Node.js build artifacts
COPY --from=node-builder /app/dist /app/dist
COPY --from=node-builder /app/node_modules /app/node_modules
COPY --from=node-builder /app/package.json /app/package.json

# Copy source files
COPY client ./client
COPY server ./server
COPY shared ./shared
COPY . .

# Create non-root user
RUN useradd -m -u 1000 appuser && \
    chown -R appuser:appuser /app

USER appuser

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:3000/ || exit 1

# Expose ports
EXPOSE 3000 8080 7071

# Default command
CMD ["node", "dist/index.js"]
