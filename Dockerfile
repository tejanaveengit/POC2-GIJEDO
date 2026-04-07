# Use official Java runtime
FROM openjdk:17-jdk-slim

# Set working directory
WORKDIR /app

# Copy compiled Java file
COPY App.class .

# Run the application
CMD ["java", "App"]
