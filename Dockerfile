# Stage 1: Build the application using an official Gradle image with Java 17
FROM gradle:8-jdk17 AS build
WORKDIR /app
COPY . .
# Build the project, skipping tests to speed up the container creation
RUN ./gradlew build -x test

# Stage 2: Run the application using a multi-platform Java 17 runtime
FROM eclipse-temurin:17-jre
WORKDIR /app
# Copy only the compiled .jar file from the 'build' stage into this final container
COPY --from=build /app/build/libs/*.jar app.jar
# Expose the standard Spring Boot port so Render knows where to route web traffic
EXPOSE 8080
# The command that starts your Spring Boot web server
ENTRYPOINT ["java", "-jar", "app.jar"]