# Step 1: Build
FROM node:20-alpine AS build

WORKDIR /app

# Copy dependency files
COPY package.json pnpm-lock.yaml ./

# Install dependencies
RUN npm install -g pnpm && pnpm install

# Copy source code
COPY . .

# Build the React application
RUN pnpm run build

# Step 2: Serve
FROM node:20-alpine AS runtime

WORKDIR /app

# Install static server
RUN npm install -g serve

# Copy build from previous step
COPY --from=build /app/dist ./dist

# Expose port
EXPOSE 3000

# Startup command
CMD ["serve", "-s", "dist", "-l", "3000"]
