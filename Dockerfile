# Build stage
FROM maven:3.8.4-openjdk-17-slim AS build

# Set the working directory
WORKDIR /build

# Copy the pom.xml file to the working directory
COPY pom.xml .
#
## Download project dependencies (for better caching)
#RUN mvn dependency:go-offline

# Copy the rest of the application files
COPY src ./src

# Build the application
RUN mvn clean package

# Runtime stage
FROM openjdk:17-jdk

# Set the working directory
WORKDIR /app

# Define an argument to accept the JAR file name
ARG JAR_FILE=/build/target/webapp-0.0.1-SNAPSHOT.jar

# Copy the packaged Spring Boot JAR file from the build stage to the working directory
COPY --from=build ${JAR_FILE} /app/app.jar

# Expose the application's port
EXPOSE 8080

# Start the Spring Boot application
ENTRYPOINT ["java", "-jar", "/app/app.jar"]

### Build stage
##FROM maven:3.8.3-openjdk-17-slim AS build
##
### Set the working directory
##WORKDIR /app
##
### Copy the pom.xml file to the working directory
##COPY pom.xml .
##
### Copy the rest of the application files
##COPY src ./src
##
### Build the application
##RUN mvn clean package
#
## Use the official OpenJDK image as a base image
##FROM openjdk:17-jre-slim
#FROM mcr.microsoft.com/openjdk/jdk:17-ubuntu
#
## Set the working directory
#WORKDIR /app
#
## Define an argument to accept the JAR file name
#ARG JAR_FILE=target/webapp-0.0.1-SNAPSHOT.jar
#
## Copy the packaged Spring Boot JAR file to the working directory
#COPY ${JAR_FILE} /app/app.jar
#
## Expose the application's port
#EXPOSE 8080
#
## Start the Spring Boot application
#ENTRYPOINT ["java", "-jar", "/app/app.jar"]