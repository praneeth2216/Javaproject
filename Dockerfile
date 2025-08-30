# Stage 1: build
FROM maven:3.9.6-eclipse-temurin-17 AS builder
WORKDIR /workspace
COPY pom.xml .
COPY src ./src
RUN mvn -B -DskipTests package

# Stage 2: run
FROM eclipse-temurin:17-jre
WORKDIR /app
COPY --from=builder /workspace/target/demo-0.0.1-SNAPSHOT.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","app.jar"]
