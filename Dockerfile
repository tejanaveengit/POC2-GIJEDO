# Use a lightweight base image
FROM alpine:3.19

# Set working directory
WORKDIR /app

# Copy application files
COPY app.sh /app/app.sh

# Make script executable
RUN chmod +x /app/app.sh

# Run the app
CMD ["./app.sh"]
