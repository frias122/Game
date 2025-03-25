#!/bin/bash

# Variables
IMAGE_NAME="joel-trisha-web-page"
DOCKERHUB_USERNAME="babayagaaws"  # Replace with your Docker Hub username
DOCKERHUB_REPO="$DOCKERHUB_USERNAME/$IMAGE_NAME"
TAG="latest"

# Step 1: Create the Dockerfile with Ubuntu base and debugging tools
cat <<EOL > Dockerfile
# Use Ubuntu as base image
FROM ubuntu:22.04

# Set non-interactive frontend to avoid prompts during build
ENV DEBIAN_FRONTEND=noninteractive

# Update package lists and install tools
RUN apt-get update && \\
    apt-get install -y \\
    # Python and web server
    python3 \\
    # Network debugging tools
    telnet \\
    iputils-ping \\
    curl \\
    net-tools \\
    # Text editors
    vim \\
    nano \\
    # Clean up
    && apt-get clean \\
    && rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /app

# Copy the application files into the container
COPY index.html /app/index.html
COPY countdown.html /app/countdown.html
COPY 1.jpg /app/1.jpg
COPY 2.jpg /app/2.jpg

# Expose the port your application listens on
EXPOSE 8080

# Command to run your application
CMD ["python3", "-m", "http.server", "8080"]
EOL

echo "Dockerfile created successfully with essential tools."

# Step 2: Build the Docker image
echo "Building Docker image with tag $TAG..."
docker build -t $IMAGE_NAME:$TAG .

# Step 3: Tag the Docker image
echo "Tagging Docker image..."
docker tag $IMAGE_NAME:$TAG $DOCKERHUB_REPO:$TAG

# Step 4: Log in to Docker Hub
echo "Logging in to Docker Hub..."
docker login -u "$DOCKERHUB_USERNAME"

# Step 5: Push the Docker image to Docker Hub
echo "Pushing Docker image to Docker Hub..."
docker push $DOCKERHUB_REPO:$TAG

echo "--------------------------------------------------"
echo "Docker image successfully built and pushed!"
echo "Image URL: https://hub.docker.com/r/$DOCKERHUB_REPO"
echo "Run the container with:"
echo "docker run -d -p 8080:8080 --name trisha-web $DOCKERHUB_REPO:$TAG"
echo "--------------------------------------------------"