# Step 1: Build tools
FROM node:20-alpine AS build

WORKDIR /app

# Copy dependency files
COPY package.json pnpm-lock.yaml ./

# Install dependencies
RUN npm install -g pnpm && pnpm install

# Copy source code
COPY . .

# Run build (if needed)
RUN pnpm run build

# Step 2: Runtime for infra tasks
FROM node:20-alpine AS runtime

WORKDIR /app

# Copy compiled code and node_modules
COPY --from=build /app/dist ./dist
COPY --from=build /app/node_modules ./node_modules

# Expose no specific port (infra tasks run internally)
CMD ["pnpm", "test"]
