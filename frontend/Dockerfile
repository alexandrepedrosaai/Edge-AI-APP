# Step 1: Build
FROM node:20-alpine AS build

WORKDIR /app

# Enable pnpm via Corepack (no global npm install needed)
RUN corepack enable

# Copy dependency manifests first for better layer caching
COPY package.json pnpm-lock.yaml ./

# Deterministic dependency install
RUN pnpm install --frozen-lockfile

# Copy source code
COPY . .

# Build the Vite/React application (outputs to dist/)
RUN pnpm run build

# Step 2: Runtime
FROM node:20-alpine AS runtime

WORKDIR /app

ENV NODE_ENV=production

# Copy build output from build stage with correct ownership for the node user
COPY --chown=node:node --from=build /app/dist ./dist

# Use the non-root 'node' user provided by the base image
USER node

# Expose port
EXPOSE 3000

# Serve dist using npx (no global install as root required)
CMD ["npx", "--yes", "serve", "-s", "dist", "-l", "3000"]
