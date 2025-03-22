#!/bin/bash

# Variables
IMAGE_NAME="romantic-game"
DOCKERHUB_USERNAME="babayagaaws"  # Replace with your Docker Hub username
DOCKERHUB_REPO="$DOCKERHUB_USERNAME/$IMAGE_NAME"

# Step 1: Create the Dockerfile
cat <<EOL > Dockerfile
# Use the official Nginx image as the base
FROM nginx:alpine

# Copy your custom Nginx configuration file into the container
COPY /home/ubuntu/Kub/Game/Kub/default.conf /etc/nginx/conf.d/default.conf

# Copy static files into the container
COPY /home/ubuntu/Kub/Game/index.html /usr/share/nginx/html/index.html
COPY /home/ubuntu/Kub/Game/1.jpg /usr/share/nginx/html/1.jpg
COPY /home/ubuntu/Kub/Game/2.jpg /usr/share/nginx/html/2.jpg

# Expose port 80
EXPOSE 80

# Start Nginx when the container launches
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