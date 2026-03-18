# ============================================================================
# Edge-AI-APP Docker Build
# Multi-purpose image for Assembly, Node.js, and Python development
# ============================================================================

FROM ubuntu:22.04

LABEL maintainer="Alexandre Pedrosa <alexandrepedrosa@example.com>"
LABEL description="Edge-AI-APP - Assembly, Node.js, and Python Development Environment"

ENV DEBIAN_FRONTEND=noninteractive \
    NODE_ENV=production \
    PORT=3000

WORKDIR /app

# ============================================================================
# Install system dependencies
# ============================================================================
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    wget \
    git \
    ca-certificates \
    nasm \
    yasm \
    binutils \
    gcc \
    g++ \
    gdb \
    checksec \
    nodejs \
    npm \
    python3 \
    python3-pip \
    jq \
    && rm -rf /var/lib/apt/lists/*

# ============================================================================
# Install pnpm
# ============================================================================
RUN npm install -g pnpm

# ============================================================================
# Copy project files
# ============================================================================
COPY . .

# ============================================================================
# Install dependencies and build
# ============================================================================
RUN pnpm install && \
    pnpm run build

# ============================================================================
# Create non-root user
# ============================================================================
RUN useradd -m -u 1000 appuser && \
    chown -R appuser:appuser /app

USER appuser

# ============================================================================
# Health check
# ============================================================================
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:3000/ || exit 1

# ============================================================================
# Expose ports
# ============================================================================
EXPOSE 3000 8080 7071

# ============================================================================
# Default command
# ============================================================================
CMD ["node", "dist/index.js"]
