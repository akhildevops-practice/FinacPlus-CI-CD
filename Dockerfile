# Use an official Java runtime as the base image
FROM openjdk:17-jdk-slim

# Set the working directory in the container
WORKDIR /app

# Copy the JAR file from the target directory to the container
COPY target/demo-0.0.1-SNAPSHOT.jar app.jar

# Expose the application port
EXPOSE 8080

# Set the command to run the application
ENTRYPOINT ["java", "-jar", "app.jar"]

