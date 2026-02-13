# Build stage
FROM gradle:7.6.0-jdk17 AS build
WORKDIR /app

# Copy project files
COPY . .

# Compile the project
RUN gradle shadowJar

# Runtime stage
FROM openjdk:17-jdk-slim
WORKDIR /app

# Copy the generated JAR
COPY --from=build /app/build/libs/*.jar app.jar

# Expose port
EXPOSE 8080

# Startup command
ENTRYPOINT ["java", "-jar", "app.jar"]
