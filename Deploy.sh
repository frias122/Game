#!/bin/bash

# Variables
IMAGE_NAME="joel-trisha-web-page"
DOCKERHUB_USERNAME="babayagaaws"  # Replace with your Docker Hub username
DOCKERHUB_REPO="$DOCKERHUB_USERNAME/$IMAGE_NAME"

# Step 1: Create the Dockerfile
cat <<EOL > Dockerfile
# Use a base image (e.g., Python, Node.js, or a minimal Linux image)
FROM python:3.9

# Set the working directory
WORKDIR /app

# Copy the application files into the container
COPY index.html /app/index.html
COPY 1.jpg /app/1.jpg
COPY 2.jpg /app/2.jpg

# Expose the port your application listens on
EXPOSE 8080

# Command to run your application
CMD ["python", "-m", "http.server", "8080"]
EOL

echo "Dockerfile created successfully."

# Step 2: Build the Docker image
echo "Building Docker image..."
docker build -t $IMAGE_NAME .

# Step 3: Tag the Docker image
echo "Tagging Docker image..."
docker tag $IMAGE_NAME $DOCKERHUB_REPO

# Step 4: Log in to Docker Hub
echo "Logging in to Docker Hub..."
docker login

# Step 5: Push the Docker image to Docker Hub
echo "Pushing Docker image to Docker Hub..."
docker push $DOCKERHUB_REPO

echo "Done! Your image is available at https://hub.docker.com/r/$DOCKERHUB_REPO"