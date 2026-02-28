# Step 1: Build
FROM node:20-alpine AS build

WORKDIR /app

# Copy dependency files
COPY package.json tsconfig.json pnpm-lock.yaml ./

# Install dependencies
RUN npm install -g pnpm && pnpm install

# Copy source code
COPY . .

# Compile TypeScript
RUN pnpm run build

# Step 2: Run
FROM node:20-alpine AS runtime

WORKDIR /app

# Copy compiled code from build stage
COPY --from=build /app/dist ./dist
COPY --from=build /app/node_modules ./node_modules

# Expose port
EXPOSE 4000

# Startup command
CMD ["node", "dist/index.js"]
