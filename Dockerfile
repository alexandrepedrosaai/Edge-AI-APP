# ============================================================================
# Edge-AI-APP Docker Build
# Multi-stage build for Assembly, Node.js, and Python development
# ============================================================================
FROM node:25-alpine AS builder
WORKDIR /app

# Copy ALL files first (including package files)
COPY . .

# Install dependencies using npm ci (uses package-lock.json)
RUN npm ci

# Build the application
RUN npm run build

# ============================================================================
# Production stage
# ============================================================================
FROM ubuntu:22.04
LABEL maintainer="Alexandre Pedrosa <alexandrepedrosa@example.com>"
LABEL description="Edge-AI-APP - Assembly, Node.js, and Python Development Environment"

ENV DEBIAN_FRONTEND=noninteractive \
    NODE_ENV=production \
    PORT=3000

WORKDIR /app

# Install runtime dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    ca-certificates \
    python3 \
    python3-pip \
    && curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Copy built application from builder
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/package.json ./
COPY --from=builder /app/package-lock.json ./

# Install production dependencies only
RUN npm ci --only=production

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
