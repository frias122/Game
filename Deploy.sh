#!/bin/bash

# Variables
IMAGE_NAME="romantic-game"
DOCKERHUB_USERNAME="babayagaaws"  # Replace with your Docker Hub username
DOCKERHUB_REPO="$DOCKERHUB_USERNAME/$IMAGE_NAME"

# Step 1: Create the Dockerfile
cat <<EOL > Dockerfile
FROM nginx:alpine

USER root

# Create the required directories and set permissions
RUN mkdir -p /var/cache/nginx/client_temp && \
    chown -R nginx:nginx /var/cache/nginx && \
    chmod -R 755 /var/cache/nginx

# Copy your application files
COPY index.html /usr/share/nginx/html/
COPY 1.jpg /usr/share/nginx/html/
COPY 2.jpg /usr/share/nginx/html/

# Expose port 80 (the default port for HTTP)
EXPOSE 80

# Start Nginx when the container runs
CMD ["nginx", "-g", "daemon off;"]
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